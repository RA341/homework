package manager

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

func (c *Client) Download(url string) (downloadId string, err error) {
	return c.srv.Download(url)
}

func (c *Client) Cancel(id string) error {
	return c.srv.Cancel(id)
}

func (c *Client) Progress(id string) (*downloads.Progress, error) {
	return c.srv.Progress(id)
}
