package scribe

import (
	"fmt"

	"github.com/ra341/homework/internal/downloads"
	"github.com/ra341/homework/scribe/manager"
	"github.com/ra341/homework/scribe/ytdlp"
)

type ClientConfig interface {
	BrowserDir() string
	DownloadsDir() string
}

func NewClient(config ClientConfig) (downloads.DownloadClient, error) {
	srv, err := ytdlp.NewService(config.BrowserDir())
	if err != nil {
		return nil, fmt.Errorf("could not create ytdlp service: %w", err)
	}

	downloaderSrv, err := manager.NewService(config.DownloadsDir(), srv)
	if err != nil {
		return nil, fmt.Errorf("could not create manager service: %s", err)
	}

	downloaderCli := manager.NewClient(downloaderSrv)
	return downloaderCli, nil
}

type ClientHttpConfig interface {
	HttpServiceUrl() string
}

func NewClientHttp(config ClientHttpConfig) (downloads.DownloadClient, error) {
	url := config.HttpServiceUrl()
	if url == "" {

	}
	return manager.NewClientHttp(url)
}
