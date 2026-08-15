package asset

import (
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strconv"

	"github.com/google/uuid"
	"github.com/ra341/homework/common/fu"
	"github.com/rs/zerolog/log"
)

type Service struct {
	Db Store

	AssetFolder string
}

func NewService(store Store, AssetFolder string) *Service {
	return &Service{
		Db:          store,
		AssetFolder: AssetFolder,
	}
}

func (s *Service) Init() error {
	abs, err := filepath.Abs(s.AssetFolder)
	if err != nil {
		return err
	}

	s.AssetFolder = abs

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

	return s.Db.GetByContentAndRole(int(contentId), assetRole)
}

func (s *Service) Create(id uint, c *CreateAsset) (Asset, error) {
	abs, err := filepath.Abs(c.Filepath)
	if err != nil {
		return Asset{}, err
	}

	folderId, err := uuid.NewV7()
	if err != nil {
		return Asset{}, err
	}

	c.Filepath = filepath.Join(abs, folderId.String())
	return s.Db.Create(id, c.AssetType, c.AssetRole, c.Filepath)
}

func (s *Service) Scan(assetId uint) error {
	asset, err := s.Db.GetById(assetId)
	if err != nil {
		return err
	}

	dir, err := os.ReadDir(asset.StoragePath)
	if err != nil {
		return err
	}

	if len(dir) == 0 {
		return fmt.Errorf("asset has no associated files")
	}

	return nil
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

	ass, err := s.Db.GetById(assetId)
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

	ass.StoragePath = assetPath
	err = s.Db.Save(ass)
	return err
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
