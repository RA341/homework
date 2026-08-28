package manager

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"time"

	"github.com/ra341/homework/common/fu"
	"github.com/ra341/homework/internal/downloads"
)

type ClientHttp struct {
	basepath string
	hcli     *http.Client
}

func (c *ClientHttp) Cancel(id string) error {
	//TODO implement me
	panic("implement me")
}

func NewClientHttp(basepath string) (downloads.DownloadClient, error) {
	client := &http.Client{
		Timeout: 10 * time.Second,
		Transport: &http.Transport{
			DialContext: (&net.Dialer{
				Timeout: 5 * time.Second,
			}).DialContext,
			TLSHandshakeTimeout: 5 * time.Second,
		},
	}

	cli := &ClientHttp{
		hcli:     client,
		basepath: basepath,
	}

	return cli, nil
}

func (c *ClientHttp) ping() error {
	get, err := c.hcli.Get(c.formatUrl("/hello"))
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

func (c *ClientHttp) Progress(id string) (*downloads.Progress, error) {
	//TODO implement me
	panic("implement me")
}

func (c *ClientHttp) Download(url string) (downloadId string, err error) {
	s := fmt.Sprintf("download?url=%s", url)

	body, err := c.runRequest(s)
	if err != nil {
		return "", err
	}

	v := &DownloadResponse{}
	err = json.Unmarshal(body, v)
	if err != nil {
		return "", err
	}

	return v.Id, nil
}

//func (c *Client) Progress(id string) (downloader.DownloadState, *downloader.DownloadProgress, error) {
//	s := fmt.Sprintf("status?id=%s", id)
//
//	body, err := c.runRequest(s)
//	if err != nil {
//		return downloader.Failed, nil, err
//	}
//
//	var progress Progress
//
//	err = json.Unmarshal(body, &progress)
//	if err != nil {
//		return downloader.Failed, nil, err
//	}
//
//	downProgress := downloader.DownloadProgress{
//		TimeLeftSecs:           uint(progress.TimeInSecs),
//		DownloadBytesPerSecond: uint(progress.DownloadBytesSpeed),
//		Total:                  uint(progress.Downloaded),
//		Completed:              uint(progress.Total - progress.Downloaded),
//		Error:                  progress.Error,
//	}
//
//	return downloader, nil, err
//}

func (c *ClientHttp) runRequest(s string) ([]byte, error) {
	ctx := context.Background()
	endpoint := c.formatDownloaderUrl(s)
	req, err := http.NewRequestWithContext(ctx, "GET", endpoint, nil)
	if err != nil {
		return nil, err
	}

	resp, err := c.hcli.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to perform request: %w", err)
	}
	defer fu.CloseCloser(resp.Body)

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read response body: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		respBody := string(body)
		return nil, fmt.Errorf("unexpected response %d: %s", resp.StatusCode, respBody)
	}

	return body, nil
}

func (c *ClientHttp) formatUrl(s string) string {
	return fmt.Sprintf("%s/%s", c.basepath, s)
}

func (c *ClientHttp) formatDownloaderUrl(s string) string {
	return fmt.Sprintf("%s/%s/%s", c.basepath, downloaderEndpointPrefix, s)
}
