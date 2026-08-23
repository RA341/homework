package app

import (
	"fmt"

	"github.com/ra341/homework/downloader/downloader"
	"github.com/ra341/homework/downloader/ytdlp"
	"github.com/ra341/homework/internal/downloads"
	"github.com/rs/zerolog/log"
)

func NewDownloaderClient(browserData, downloadFolder string) (downloads.DownloadClient, error) {
	srv, err := ytdlp.NewService(browserData)
	if err != nil {
		return nil, fmt.Errorf("could not create ytdlp service: %w", err)
	}

	downloaderSrv, err := downloader.NewService(downloadFolder, srv)
	if err != nil {
		log.Fatal().Err(err).Msg("could not create downloader")
	}

	downloaderCli := downloader.NewClient(downloaderSrv)
	return downloaderCli, nil
}
