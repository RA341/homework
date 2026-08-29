package scribe

import (
	"fmt"

	"github.com/ra341/homework/internal/downloads"
	"github.com/ra341/homework/scribe/manager"
	"github.com/ra341/homework/scribe/ytdlp"
)

type FactoryClientConfig interface {
	ClientUnifiedConfig
	ClientHttpConfig
}

type ClientFactory func(config FactoryClientConfig) (downloads.DownloadClient, error)

type ClientUnifiedConfig interface {
	GetBrowserDir() string
	GetDownloadsDir() string
}

func NewClientUnified(config FactoryClientConfig) (downloads.DownloadClient, error) {
	srv, err := ytdlp.NewService(config.GetBrowserDir())
	if err != nil {
		return nil, fmt.Errorf("could not create ytdlp service: %w", err)
	}

	downloaderSrv, err := manager.NewService(config.GetDownloadsDir(), srv)
	if err != nil {
		return nil, fmt.Errorf("could not create manager service: %s", err)
	}

	downloaderCli := manager.NewClient(downloaderSrv)
	return downloaderCli, nil
}

type ClientHttpConfig interface {
	GetServiceUrl() string
}

func NewClientHttp(config FactoryClientConfig) (downloads.DownloadClient, error) {
	url := config.GetServiceUrl()
	if url == "" {

	}
	return manager.NewClientHttp(url)
}
