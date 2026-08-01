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

type PythonDownloader struct {
	cli *http.Client
}

func NewPyClient(socketPath string) (DownloadClient, error) {
	client := &http.Client{
		Transport: &http.Transport{
			DialContext: func(ctx context.Context, _, _ string) (net.Conn, error) {
				return net.Dial("unix", socketPath)
			},
		},
	}

	c := &PythonDownloader{
		cli: client,
	}

	return c, c.ping()
}

func (s *PythonDownloader) ping() error {
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

func (s *PythonDownloader) download(video string, downloadPath string) (downloadId string, err error) {
	endpoint := s.formatUrl("/download")

	body := map[string]string{
		"url":           video,
		"download_path": downloadPath,
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

	respBody, err := s.readBodyAndStatus(err, resp)
	if err != nil {
		return "", err
	}

	return string(respBody), nil
}

func (s *PythonDownloader) progress(id string) (DownloadState, *DownloadProgress, error) {
	resp, err := s.cli.Get(s.formatUrl("/status?id=" + id))
	if err != nil {
		return Error, nil, err
	}
	defer fu.CloseCloser(resp.Body)

	progress := &DownloadProgress{}

	respBody, err := s.readBodyAndStatus(err, resp)
	if err != nil {
		return Error, progress, err
	}

	err = json.Unmarshal(respBody, progress)
	if err != nil {
		return 0, nil, err
	}

	if resp.StatusCode == http.StatusOK {
		return Complete, progress, nil
	}

	// 206 downloading
	return Downloading, progress, nil
}

func (s *PythonDownloader) readBodyAndStatus(err error, resp *http.Response) ([]byte, error) {
	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("could not read body %w", err)
	}

	if resp.StatusCode >= http.StatusMultipleChoices {
		return nil, fmt.Errorf("unexpected status code: %d, body: %s", resp.StatusCode, respBody)
	}

	return respBody, nil
}

func (s *PythonDownloader) formatUrl(path string) string {
	return fmt.Sprintf("%s%s", "http://unix", path)
}
