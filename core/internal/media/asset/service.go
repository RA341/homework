package asset

import (
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strconv"
	"sync"

	"github.com/google/uuid"
	"github.com/ra341/homework/common/fu"
	"github.com/ra341/homework/common/sem"
	"github.com/rs/zerolog/log"
)

type Service struct {
	store Store

	AssetFolder string

	Sem              sem.Sem
	IsScannerRunning bool
}

func NewService(store Store, AssetFolder string) (*Service, error) {
	s := &Service{
		store:       store,
		AssetFolder: AssetFolder,
		Sem:         sem.New(1),
	}

	err := s.Init()
	return s, err
}

func (s *Service) Init() error {
	abs, err := filepath.Abs(s.AssetFolder)
	if err != nil {
		return err
	}

	s.AssetFolder = abs
	// todo put in scheduled task
	//s.StartScan()

	return nil
}

func (s *Service) GetByContentId(contentIdStr string, assetRoleStr string) (*Asset, error) {
	contentId, err := strconv.ParseInt(contentIdStr, 10, 64)
	if err != nil {
		return nil, fmt.Errorf("invalid contentId " + err.Error())
	}

	assetRole, err := RoleString(assetRoleStr)
	if err != nil {
		return nil, fmt.Errorf("invalid assetRole" + err.Error())
	}

	return s.store.GetByContentAndRole(int(contentId), assetRole)
}

func (s *Service) Delete(assetId uint, deleteFile bool) error {
	ass, err := s.store.GetById(assetId)
	if err != nil {
		return err
	}

	if deleteFile && ass.StoragePath != "" {
		err = os.RemoveAll(ass.StoragePath)
		if err != nil {
			return err
		}
	}

	err = s.store.Delete(assetId)
	return err
}

func (s *Service) Create(contentId uint, c *CreateAsset) (Asset, error) {
	abs, err := filepath.Abs(c.Filepath)
	if err != nil {
		return Asset{}, err
	}

	folderId, err := uuid.NewV7()
	if err != nil {
		return Asset{}, err
	}

	c.Filepath = filepath.Join(abs, folderId.String())
	return s.store.Create(contentId, c.AssetType, c.AssetRole, c.Filepath)
}

func (s *Service) StartScan() {
	ok := s.Sem.TryAcquire()
	if ok {
		go s.worker()
	} else {
		log.Debug().Msg("scanner already running")
	}
}

func (s *Service) worker() {
	s.IsScannerRunning = true

	defer func() {
		log.Debug().Msg("asset scan finished")
		s.Sem.Release()
		s.IsScannerRunning = false
	}()

	log.Debug().Msg("asset scanner started")

	limit := 10
	scanSem := sem.New(limit)
	wg := sync.WaitGroup{}

	var lastId uint = 0
	for {
		assets, err := s.store.ListNonEmptyAssets(lastId, limit)
		if err != nil {
			log.Err(err).Msg("scan failed")
			return
		}

		assetCount := len(assets)
		if assetCount == 0 {
			log.Warn().Msg("no additional assets found, waiting for existing scans to finish")
			wg.Wait()
			return
		}

		for _, ass := range assets {
			scanSem.Acquire()
			wg.Go(func() {
				defer scanSem.Release()

				err = s.scanAsset(&ass)
				if err != nil {
					log.Warn().Err(err).Msg("asset scan failed")
				}
			})
		}

		// assets should always
		if assetCount == 0 {
			log.Err(err).Msg("0 assets found, THIS SHOULD NEVER HAPPEN, PLEASE OPEN A ISSUE")
			return
		}
		lastId = assets[assetCount-1].ID
	}
}

func (s *Service) scanAsset(ass *Asset) error {
	file, err := os.Stat(ass.StoragePath)
	if err != nil {
		return err
	}

	fileModified := file.ModTime().After(ass.UpdatedAt)
	if ass.FileMetadata.IsScanned || fileModified {
		log.Debug().
			Str("path", filepath.Dir(ass.StoragePath)).
			Msg("asset scanned, no changes to file")
		return nil
	}

	ass.FileMetadata.IsScanned = true
	ass.FileMetadata.Size = uint(file.Size())

	// todo
	//ass.fm.Duration
	//ass.fm.Height
	//ass.fm.Width

	err = s.store.Save(ass)
	log.Debug().
		Str("path", filepath.Dir(ass.StoragePath)).
		Msg("scanned asset")

	return err
}

func (s *Service) Finalize(assetId uint, downloadFolder string) error {
	dir, err := os.ReadDir(downloadFolder)
	if err != nil {
		return err
	}

	dirLen := len(dir)
	if dirLen < 1 {
		return fmt.Errorf("could not find any items in download dir")
	}

	// todo remove handle multiple files, for now err
	if dirLen > 1 {
		return fmt.Errorf("found too many items in download dir")
	}

	item := dir[0]

	ass, err := s.store.GetById(assetId)
	if err != nil {
		return err
	}

	assetFolderId, err := uuid.NewUUID()
	if err != nil {
		return err
	}
	finalFolder := filepath.Join(s.AssetFolder, assetFolderId.String())

	err = os.MkdirAll(finalFolder, 0750)
	if err != nil {
		return err
	}

	downloadPath := filepath.Join(downloadFolder, item.Name())
	assetPath := filepath.Join(finalFolder, item.Name())

	err = s.move(downloadPath, assetPath)
	if err != nil {
		return err
	}

	oldAssetPath := ass.StoragePath

	ass.StoragePath = assetPath
	err = s.store.Save(ass)
	if err != nil {
		return err
	}

	if oldAssetPath != "" {
		err = os.RemoveAll(oldAssetPath)
		if err != nil {
			log.Warn().Err(err).Msg("could not remove old asset folder")
		}
	}

	return nil
}

func (s *Service) move(downloadPath string, assetPath string) error {
	ok := s.assetMove(downloadPath, assetPath)
	if ok {
		return nil
	}

	err := s.assetCopy(downloadPath, assetPath)
	return err
}

func (s *Service) assetCopy(downloadPath string, assetPath string) error {
	srcFile, err := os.OpenFile(downloadPath, os.O_RDONLY, 0600)
	if err != nil {
		return err
	}
	defer fu.CloseCloser(srcFile)

	destFile, err := os.OpenFile(assetPath, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0600)
	if err != nil {
		return err
	}
	defer fu.CloseCloser(destFile)

	_, err = io.Copy(destFile, srcFile)
	if err != nil {
		return err
	}

	log.Debug().Msg("moved asset using io.Copy")
	return nil
}

func (s *Service) assetMove(downloadPath string, assetPath string) bool {
	err := os.Rename(downloadPath, assetPath)
	if err == nil {
		log.Debug().Msg("moved asset using os.Rename")
		return true
	}

	log.Warn().
		Err(err).
		Str("src", downloadPath).
		Str("dst", assetPath).
		Msg("could not rename asset, attempting to copy")

	return false
}
