package scribe

import (
	"context"
	"fmt"
	"net/http"
	"os"

	"github.com/ra341/homework/common/router"
	"github.com/ra341/homework/internal/downloads"
	"github.com/ra341/homework/scribe/manager"
	"github.com/ra341/homework/scribe/ytdlp"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func init() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: "15:04:05"})
}

func NewClient(browserData, downloadFolder string) (downloads.DownloadClient, error) {
	srv, err := ytdlp.NewService(browserData)
	if err != nil {
		return nil, fmt.Errorf("could not create ytdlp service: %w", err)
	}

	downloaderSrv, err := manager.NewService(downloadFolder, srv)
	if err != nil {
		log.Fatal().Err(err).Msg("could not create downloader")
	}

	downloaderCli := manager.NewClient(downloaderSrv)
	return downloaderCli, nil
}

type App struct {
	downloader *manager.Service
}

func (a *App) Run() {
	ctx := context.Background()

	a.loadServices()

	port := 9922

	mux := http.NewServeMux()
	a.RegisterHandlers(mux)

	//mux.Handle("/", server.base.UIHandler)
	//finalMux := api.WithCors(mux, allowedOrigins)

	log.Info().Int("port", port).Msg("Starting homework downloader server...")
	router.RunServer(ctx, port, mux)
}

func (a *App) loadServices() {
	var err error

	browserData := "../dev/browser"
	ytd, err := ytdlp.NewService(browserData)
	if err != nil {
		log.Fatal().Err(err).Msg("could not init yt-dlp")
	}

	downloadFolder := "downloads"
	a.downloader, err = manager.NewService(downloadFolder, ytd)
	if err != nil {
		log.Fatal().Err(err).Msg("could not init downloader")
	}
}

func (a *App) RegisterHandlers(mux *http.ServeMux) {
	mux.HandleFunc("/hello", func(writer http.ResponseWriter, request *http.Request) {
		_, _ = writer.Write([]byte("fuck you Ezekiel"))
	})

	rou := router.Router{ParentMux: mux}
	rou.AddRouter(manager.NewHandlerHttp(a.downloader))
}
