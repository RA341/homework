package downloads

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

	"github.com/ra341/homework/common/fu"
)

type Service struct {
	conf *Config
	cli  *http.Client
}

func NewService(conf *Config) (*Service, error) {
	s := &Service{
		conf: conf,
	}
	err := s.Init()
	return s, err
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

func (s *Service) Download(video string) (string, error) {
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
			if strings.HasPrefix(line, "event:") {
				lastEvent = strings.TrimSpace(strings.TrimPrefix(line, "event:"))
			} else if strings.HasPrefix(line, "data:") {
				dataVal := strings.TrimSpace(strings.TrimPrefix(line, "data:"))
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
