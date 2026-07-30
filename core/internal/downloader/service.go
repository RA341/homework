package downloader

import (
	"bufio"
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"strings"
	"sync"

	"github.com/ra341/homework/common/fu"
	"github.com/rs/zerolog/log"
)

type Service struct {
	store Store
	conf  *Config
	cli   *http.Client

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

func (s *Service) Init() error {
	socketPath := s.conf.SocketPath

	client := &http.Client{
		Transport: &http.Transport{
			DialContext: func(ctx context.Context, _, _ string) (net.Conn, error) {
				return net.Dial("unix", socketPath)
			},
		},
	}
	s.cli = client

	return s.PingDownloader()
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

func (s *Service) PingDownloader() error {
	get, err := s.cli.Get(s.formatUrl("/hello"))
	if err != nil {
		return err
	}
	defer fu.CloseCloser(get.Body)

	if get.StatusCode != http.StatusOK {
		body, err := io.ReadAll(get.Body)
		if err != nil {
			return fmt.Errorf("can't read response body: %w", err)
		}
		return fmt.Errorf("unexpected status code=%d, body=%s", get.StatusCode, body)
	}

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
				s.Download(&d)
			})
		}

		wg.Wait()
	}
}

func (s *Service) Download(msg *Download) {
	_, err := s.RunDownload(msg.DownloadLink)
	if err != nil {
		err := s.store.SetDownloadErr(msg.ID, err.Error())
		if err != nil {
			log.Warn().Err(err).Uint("id", msg.ID).
				Msg("Could not set error status for download")
		}
		return
	}

	// todo start asset scan
}

func (s *Service) RunDownload(video string) (string, error) {
	return "", fmt.Errorf("implement me idiot")

	endpoint := s.formatUrl("/ytdlp/download")

	body := map[string]string{
		"url": video,
	}

	jsonBody, err := json.Marshal(body)
	if err != nil {
		return "", err
	}
	// todo context
	ctx := context.Background()
	req, err := http.NewRequestWithContext(
		ctx,
		"POST",
		endpoint,
		bytes.NewBuffer(jsonBody),
	)
	if err != nil {
		return "", fmt.Errorf("failed to create request: %w", err)
	}

	// SSE headers + Content-Type for the body
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "text/event-stream")
	req.Header.Set("Cache-Control", "no-cache")
	req.Header.Set("Connection", "keep-alive")

	resp, err := s.cli.Do(req)
	if err != nil {
		return "", fmt.Errorf("failed to perform request: %w", err)
	}
	defer fu.CloseCloser(resp.Body)

	if resp.StatusCode != http.StatusOK {
		respBody, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("unexpected status code: %d, body: %s", resp.StatusCode, respBody)
	}

	// Loop over resp.Body using bufio.NewReader just like before
	var lastEvent string
	var errorMsg string
	reader := bufio.NewReader(resp.Body)
	for {
		line, err := reader.ReadString('\n')
		if len(line) > 0 {
			fmt.Print(line)

			// SSE event formatting: "event: <name>\n", "data: <content>\n"
			if after, ok := strings.CutPrefix(line, "event:"); ok {
				lastEvent = strings.TrimSpace(after)
			} else if after0, ok0 := strings.CutPrefix(line, "data:"); ok0 {
				dataVal := strings.TrimSpace(after0)
				if lastEvent == "error" {
					var errData struct {
						Message string `json:"message"`
					}
					if err := json.Unmarshal([]byte(dataVal), &errData); err == nil {
						errorMsg = errData.Message
					} else {
						errorMsg = dataVal
					}
				}
			}
		}
		if err != nil {
			if err == io.EOF {
				break
			}
			return "", err
		}
	}

	if errorMsg != "" {
		return "", fmt.Errorf("download failed: %s", errorMsg)
	}

	return "", nil
}

func (s *Service) formatUrl(path string) string {
	return fmt.Sprintf("%s%s", "http://unix", path)
}
