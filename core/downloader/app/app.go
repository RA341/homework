package app

import (
	"net/http"

	"github.com/ra341/homework/common/router"
	"github.com/ra341/homework/downloader/downloader"
	"github.com/ra341/homework/downloader/ytdlp"
	"github.com/rs/zerolog/log"
)

type App struct {
	downloader *downloader.Service
}

func (a *App) loadServices() {
	var err error

	browserData := "../dev/browser"
	ytd, err := ytdlp.NewService(browserData)
	if err != nil {
		log.Fatal().Err(err).Msg("could not init yt-dlp")
	}

	downloadFolder := "downloads"
	a.downloader, err = downloader.NewDownloader(downloadFolder, ytd)
	if err != nil {
		log.Fatal().Err(err).Msg("could not init downloader")
	}
}

func (a *App) RegisterHandlers(mux *http.ServeMux) {
	rou := router.Router{ParentMux: mux}

	rou.AddRouter(downloader.NewHandlerHttp(a.downloader))
}
