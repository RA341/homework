package downloader

import (
	"fmt"
	"path/filepath"
	"sync"
	"time"

	"github.com/rs/zerolog/log"
)

type DownloadClient interface {
	download(video string, downloadPath string) (downloadId string, err error)
	progress(id string) (DownloadState, *DownloadProgress, error)
}

type Service struct {
	store Store
	conf  *Config

	cli DownloadClient

	maxDownloads int
	workerLock   chan struct{}
}

func NewService(conf *Config, store Store, cli DownloadClient) (s *Service, err error) {
	s = &Service{
		conf:       conf,
		store:      store,
		cli:        cli,
		workerLock: make(chan struct{}, 1),
	}

	if s.maxDownloads == 0 {
		s.maxDownloads = 5
	}

	s.launchWorker()
	return s, nil
}

func (s *Service) AddDownload(Name string, DownloadLink string, DownloadPath string) error {
	download := Download{
		Status: Queued,

		Name:         Name,
		DownloadLink: DownloadLink,
		DownloadPath: DownloadPath,
	}

	err := s.store.AddDownload(download)
	if err != nil {
		return err
	}

	s.launchWorker()
	return nil
}

func (s *Service) Retry(id uint) error {
	err := s.store.SetStatus(id, Queued)
	if err != nil {
		return err
	}

	s.launchWorker()

	return nil
}

func (s *Service) launchWorker() {
	select {
	case s.workerLock <- struct{}{}:
		log.Info().Msg("launched worker")
		go s.worker()
	default:
		log.Info().Msg("worker is already running")
	}
}

func (s *Service) worker() {
	defer func() {
		<-s.workerLock
	}()

	sem := make(chan struct{}, s.maxDownloads)
	wg := sync.WaitGroup{}

	strikes := 0
	const exitThreshold = 5

	for {
		if strikes > exitThreshold {
			log.Info().Int("strikes", strikes).Msg("no downloads found, exiting worker")
			return
		}

		downloading, err := s.store.ListQueued(s.maxDownloads)
		if err != nil {
			log.Warn().Err(err).Msg("Could not load downloading items")
			return
		}

		l := len(downloading)
		if l == 0 {
			log.Info().Msg("No additional downloading items found, waiting for existing downloads to complete")
			wg.Wait()
			strikes++
			<-time.After(time.Second)
		}

		log.Debug().Int("Count", l).Msg("Found downloading items")
		strikes = 0

		for _, d := range downloading {
			wg.Go(func() {
				sem <- struct{}{}
				defer func() {
					<-sem
				}()

				s.download(&d)
			})
		}
	}
}

func (s *Service) download(msg *Download) {
	var err error
	defer func() {
		if err != nil {
			s.setErr(msg, err)
		}
	}()

	err = s.store.SetStatus(msg.ID, Downloading)
	if err != nil {
		return
	}

	state, err := s.runDownload(msg)
	if err != nil {
		return
	}

	err = s.store.SetStatus(msg.ID, state)
	if err != nil {
		return
	}

	// todo start asset scan
}

func (s *Service) runDownload(down *Download) (DownloadState, error) {
	absPath, err := filepath.Abs(down.DownloadPath)
	if err != nil {
		return 0, err
	}

	downloadId, err := s.cli.download(down.DownloadLink, absPath)
	if err != nil {
		return 0, err
	}

	checkInterval := 5 * time.Second

	tick := time.NewTicker(checkInterval)
	defer tick.Stop()

	// todo move to config

	strikes := 0

	for {
		select {
		case <-tick.C:
			if strikes > s.conf.ProgressCheckThreshold {
				return Error, fmt.Errorf("could not get progress after %d tries, please check logs", strikes)
			}

			status, progress, err := s.cli.progress(downloadId)
			if err != nil {
				strikes++
				log.Warn().
					Err(err).
					Int("strikes", strikes).
					Msg("Could not get download status, increasing strikes")
				continue
			}

			strikes = 0

			err = s.store.setProgress(down.ID, progress)
			if err != nil {
				log.Warn().Err(err).Msg("Could not set download progress")
			}

			log.Debug().Any("data", progress).Msg("Download progress")

			if status == Complete || status == Error {
				return status, nil
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
