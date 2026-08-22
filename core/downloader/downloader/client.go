package downloader

import (
	"github.com/ra341/homework/common/sm"
	"github.com/ra341/homework/internal/downloader"
)

type Client struct {
	srv *Service
}

func NewClient() downloader.DownloadClient {
	s := &Client{
		srv: &Service{
			DownloadFolder: "",
			ytd:            nil,
			downloadItems:  sm.Map[string, *DownloadItem]{},
		},
	}

	return s
}

func (c *Client) Download(video string) (downloadId string, err error) {
	//TODO implement me
	panic("implement me")
}

func (c *Client) Progress(id string) (*downloader.DownloadProgress, error) {
	//TODO implement me
	panic("implement me")
}
