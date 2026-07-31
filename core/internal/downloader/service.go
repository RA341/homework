package downloader

import (
	"sync"
	"time"

	"github.com/rs/zerolog/log"
)

type Service struct {
	store Store
	conf  *Config

	downloadClient *DownloadClient

	maxDownloads int
	mu           chan struct{}
}

func NewService(conf *Config, store Store) (*Service, error) {
	s := &Service{
		conf:  conf,
		store: store,
		mu:    make(chan struct{}, 1),
	}

	if s.maxDownloads == 0 {
		s.maxDownloads = 5
	}

	// todo
	//err := s.Init()

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
	case s.mu <- struct{}{}:
		log.Info().Msg("launched worker")
		go s.worker()
	default:
		log.Info().Msg("worker is already running")
	}
}

func (s *Service) worker() {
	defer func() { <-s.mu }()

	for {
		downloading, err := s.store.LoadQueued(s.maxDownloads)
		if err != nil {
			log.Warn().Err(err).Msg("Could not load downloading items")
			return
		}

		l := len(downloading)
		if l == 0 {
			log.Info().Msg("No items found, exiting worker")
			return
		}

		log.Info().Int("Count", l).Msg("Found downloading items")

		wg := sync.WaitGroup{}
		for _, d := range downloading {
			wg.Go(func() {
				s.download(&d)
			})
		}

		wg.Wait()
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

	_, err = s.runDownload(msg.DownloadLink)
	if err != nil {
		return
	}

	// todo start asset scan
}

func (s *Service) runDownload(video string) (string, error) {
	downloadId, err := s.downloadClient.download(video)
	if err != nil {
		return "", err
	}

	tick := time.NewTicker(time.Minute)
	defer tick.Stop()

	for {
		select {
		case <-tick.C:
			status, err := s.downloadClient.Status(downloadId)
			if err != nil {
				log.Warn().Err(err).Msg("Could not get download status")
				continue
			}

			err = s.store.setProgress(&status)
			if err != nil {
				log.Warn().Err(err).Msg("Could not set download progress")
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
