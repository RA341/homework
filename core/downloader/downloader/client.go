package downloader

import "github.com/ra341/homework/internal/downloads"

type Client struct {
	srv *Service
}

func NewClient(srv *Service) downloads.DownloadClient {
	s := &Client{
		srv: srv,
	}
	return s
}

func (c *Client) Download(video string) (downloadId string, err error) {
	//TODO implement me
	panic("implement me")
}

func (c *Client) Progress(id string) (*downloads.DownloadProgress, error) {
	//TODO implement me
	panic("implement me")
}
