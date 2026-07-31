package downloader

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"

	"github.com/ra341/homework/common/fu"
)

type DownloadClient struct {
	cli *http.Client
}

func NewClient(socketPath string) (*DownloadClient, error) {
	client := &http.Client{
		Transport: &http.Transport{
			DialContext: func(ctx context.Context, _, _ string) (net.Conn, error) {
				return net.Dial("unix", socketPath)
			},
		},
	}

	c := &DownloadClient{
		cli: client,
	}

	return c, c.ping()
}

func (s *DownloadClient) ping() error {
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

func (s *DownloadClient) download(video string) (downloadId string, err error) {
	endpoint := s.formatUrl("/download")

	body := map[string]string{
		"url": video,
	}

	// todo context
	ctx := context.Background()

	jsonBody, err := json.Marshal(body)
	if err != nil {
		return "", err
	}
	req, err := http.NewRequestWithContext(ctx, "POST", endpoint, bytes.NewReader(jsonBody))
	if err != nil {
		return "", fmt.Errorf("failed to create request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := s.cli.Do(req)
	if err != nil {
		return "", fmt.Errorf("failed to perform request: %w", err)
	}
	defer fu.CloseCloser(resp.Body)

	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("could not read body %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("unexpected status code: %d, body: %s", resp.StatusCode, respBody)
	}

	return string(respBody), nil
}

func (s *DownloadClient) Status(id string) (DownloadState, DownloadProgress, error) {
	return Error, DownloadProgress{}, fmt.Errorf("implement me")
}

func (s *DownloadClient) formatUrl(path string) string {
	return fmt.Sprintf("%s%s", "http://unix", path)
}
