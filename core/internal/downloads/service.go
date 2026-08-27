package downloads

import (
	"context"
	"crypto/sha1"
	"fmt"
	"os"
	"path/filepath"
	"time"

	"github.com/ra341/homework/common/sm"
	"github.com/rs/zerolog/log"
)

type DownloadClient interface {
	Download(video string) (downloadId string, err error)
	Cancel(id string) error
	Progress(id string) (*Progress, error)
}

type AssetFinalizer interface {
	Finalize(id uint, downloadPath string) error
}

type Service struct {
	conf *Config

	store Store
	asset AssetFinalizer
	cli   DownloadClient

	cancelMap      sm.Map[uint, context.CancelFunc]
	downloadWorker *DownloadWorker
}

func NewService(
	conf *Config,
	store Store,
	cli DownloadClient,
	asset AssetFinalizer,
) (s *Service, err error) {
	s = &Service{
		conf:  conf,
		store: store,
		cli:   cli,
		asset: asset,
	}

	err = s.Init()

	return s, err
}

func (s *Service) Init() error {
	if s.conf.WorkerMaxDownloads == 0 {
		s.conf.WorkerMaxDownloads = 5
	}
	if s.conf.CheckIntervalSecs == 0 {
		s.conf.CheckIntervalSecs = 5
	}

	abs, err := filepath.Abs(s.conf.DownloadsDir)
	if err != nil {
		return fmt.Errorf("could not load abs path for downloads dir: %w", err)
	}
	err = os.MkdirAll(abs, os.ModePerm)
	if err != nil {
		return fmt.Errorf("could not create downloads dir: %w", err)
	}
	s.conf.DownloadsDir = abs

	s.downloadWorker = NewDownloadWorker(
		s.conf.WorkerMaxDownloads,
		s.conf.WorkerExitThreshold, // todo add new config exitThreshold
		s.store,
		s,
	)

	s.launchWorker()

	return nil
}

func (s *Service) Stats() (*DownloadStats, error) {
	return s.store.Stats()
}

func (s *Service) Add(assetId uint, Name string, DownloadLink string) (err error) {
	download := Download{
		AssetID:      assetId,
		Name:         Name,
		DownloadLink: DownloadLink,
	}
	download.Progress.Status = Queued

	err = s.store.AddDownload(&download)
	if err != nil {
		return err
	}

	s.launchWorker()
	return nil
}

func (s *Service) Edit(id int64, link string) error {
	return s.store.EditLink(id, link)
}

func (s *Service) Retry(id uint) error {
	err := s.store.SetProgress(id, &Progress{
		Status:                 Queued,
		TimeLeftSecs:           0,
		DownloadBytesPerSecond: 0,
		Total:                  0,
		Completed:              0,
		Error:                  "",
	})
	if err != nil {
		return err
	}

	s.launchWorker()

	return nil
}

func (s *Service) Cancel(id uint) error {
	cancelFn, ok := s.cancelMap.Load(id)
	if !ok {
		return fmt.Errorf("download not found, are you sure its downloading")
	}

	cancelFn()
	return nil
}

func (s *Service) launchWorker() {
	s.downloadWorker.Start()
}

func (s *Service) download(download *Download) {
	var err error
	defer func() {
		if err != nil {
			s.setErr(download, err)
		}
	}()

	sum := sha1.Sum([]byte(download.DownloadLink))
	downloadId := fmt.Sprintf("%x", sum)

	downloadFolder := filepath.Join(s.conf.DownloadsDir, downloadId)
	downloadFolder, err = filepath.Abs(downloadFolder)
	if err != nil {
		return
	}
	download.DownloadPath = downloadFolder

	state, err := s.monitorDownload(download)
	if err != nil {
		return
	}

	if state == Complete {
		err = s.asset.Finalize(download.AssetID, download.DownloadPath)
		if err != nil {
			return
		}

		err = os.RemoveAll(download.DownloadPath)
		if err != nil {
			log.Warn().
				Err(err).
				Str("folder", download.DownloadPath).
				Msg("Could not remove download folder")
		}
	}

	err = s.store.SetStatus(download.ID, state)
	if err != nil {
		return
	}
}

func (s *Service) monitorDownload(down *Download) (DownloadState, error) {
	downloadId, err := s.cli.Download(down.DownloadLink)
	if err != nil {
		return 0, err
	}

	checkInterval := time.Duration(s.conf.CheckIntervalSecs) * time.Second

	ctx, cancelFn := context.WithCancel(context.Background())
	s.cancelMap.Store(down.ID, cancelFn)
	defer func() {
		s.cancelMap.Delete(down.ID)
	}()

	tick := time.NewTicker(checkInterval)
	defer tick.Stop()

	strikes := 0

	for {
		select {
		case <-ctx.Done():
			err = s.cli.Cancel(downloadId)
			if err != nil {
				log.Warn().Err(err).Msg("error while canceling download")
			}
			return Canceled, fmt.Errorf("download cancelled by user")
		case <-tick.C:
			if strikes > s.conf.CheckThreshold {
				return Failed, fmt.Errorf("could not get progress after %d tries, please check logs", strikes)
			}

			progress, err := s.cli.Progress(downloadId)
			if err != nil {
				strikes++
				log.Warn().
					Err(err).
					Int("strikes", strikes).
					Msg("Could not get download status, increasing strikes")
				continue
			}

			strikes = 0

			err = s.store.SetProgress(down.ID, progress)
			if err != nil {
				log.Warn().Err(err).Msg("Could not set download progress")
			}

			//log.Debug().Any("data", progress).Msg("Download progress")

			if progress.Status == Complete || progress.Status == Error {
				return progress.Status, nil
			}
		}
	}
}

func (s *Service) setErr(msg *Download, downloadErr error) {
	err := s.store.SetDownloadErr(msg.ID, downloadErr.Error())
	if err != nil {
		log.Warn().
			Err(err).
			Uint("id", msg.ID).
			Msg("Could not set error status for download")
	}
}
