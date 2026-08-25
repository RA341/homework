package manager

import "github.com/ra341/homework/internal/downloads"

type ClientUnified struct {
	srv *Service
}

func NewClient(srv *Service) downloads.DownloadClient {
	s := &ClientUnified{
		srv: srv,
	}
	return s
}

func (c *ClientUnified) Download(url string) (downloadId string, err error) {
	return c.srv.Download(url)
}

func (c *ClientUnified) Cancel(id string) error {
	return c.srv.Cancel(id)
}

func (c *ClientUnified) Progress(id string) (*downloads.Progress, error) {
	return c.srv.Progress(id)
}
