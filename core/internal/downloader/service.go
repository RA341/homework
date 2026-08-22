package downloader

import (
	"crypto/sha1"
	"fmt"
	"os"
	"path/filepath"
	"time"

	"github.com/rs/zerolog/log"
)

type DownloadClient interface {
	Download(video string) (downloadId string, err error)
	Progress(id string) (*DownloadProgress, error)
}

type AssetFinalizer interface {
	Finalize(id uint, downloadPath string) error
}

type Service struct {
	conf *Config

	store Store
	asset AssetFinalizer
	cli   DownloadClient

	downloadWorker *DownloadWorker
}

func NewService(conf *Config, store Store, cli DownloadClient, asset AssetFinalizer) (s *Service, err error) {
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
	if s.conf.MaxDownloads == 0 {
		s.conf.MaxDownloads = 5
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
		s.conf.MaxDownloads,
		s.conf.MaxDownloads, // todo add new config exitThreshold
		s.store,
		s,
	)

	s.launchWorker()

	return nil
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
	err := s.store.SetStatus(id, Queued)
	if err != nil {
		return err
	}

	err = s.store.SetProgress(id, &DownloadProgress{
		TimeLeftSecs:           0,
		DownloadBytesPerSecond: 0,
		Total:                  0,
		Completed:              0,
		Error:                  "",
	})
	if err != nil {
		log.Warn().Err(err).Msg("Could not clear old progress while retrying")
	}

	s.launchWorker()

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

	tick := time.NewTicker(checkInterval)
	defer tick.Stop()

	strikes := 0

	for {
		select {
		case <-tick.C:
			if strikes > s.conf.ProgressCheckThreshold {
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

func (s *Service) setErr(msg *Download, err error) {
	err2 := s.store.SetDownloadErr(msg.ID, err.Error())
	if err2 != nil {
		log.Warn().Err(err2).Uint("id", msg.ID).
			Msg("Could not set error status for download")
	}
}

//func (s *Service) launchWorker() {
//	ok := s.workerLock.TryAcquire()
//	if ok {
//		log.Info().Msg("launched download worker")
//		go s.worker()
//	} else {
//		log.Info().Msg("download worker is already running")
//	}
//}

//func (s *Service) worker() {
//	s.workerRunning = true
//	defer func() {
//		s.workerLock.Release()
//		s.workerRunning = false
//	}()
//
//	downloadSem := sem.New(s.conf.MaxDownloads)
//	wg := sync.WaitGroup{}
//
//	strikes := 0
//	const exitThreshold = 2
//
//	for {
//		if strikes >= exitThreshold {
//			log.Info().Int("strikes", strikes).Msg("no additional queued items found, exiting worker")
//			return
//		}
//
//		queued, err := s.store.ListQueued(s.conf.MaxDownloads)
//		if err != nil {
//			log.Warn().Err(err).Msg("Could not load downloading items")
//			return
//		}
//
//		l := len(queued)
//		if l == 0 {
//			log.Info().
//				Int("strikes", strikes+1).
//				Msg("waiting for existing downloads to complete")
//			wg.Wait()
//
//			strikes++
//			<-time.After(time.Second)
//			continue
//		}
//
//		log.Debug().Int("Count", l).Msg("Found queued items")
//		strikes = 0
//
//		for _, d := range queued {
//			downloadSem.Acquire()
//			err = s.store.SetStatus(d.ID, Downloading)
//			if err != nil {
//				log.Warn().Err(err).Any("download", d).Msg("Could not set status to downloading, skipping...")
//				continue
//			}
//
//			wg.Go(func() {
//				defer downloadSem.Release()
//				s.download(&d)
//			})
//		}
//	}
//}
