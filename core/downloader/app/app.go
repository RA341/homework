package app

import (
	"context"
	"net/http"
	"os"

	"github.com/ra341/homework/common/router"
	"github.com/ra341/homework/downloader/downloader"
	"github.com/ra341/homework/downloader/ytdlp"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func init() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: "15:04:05"})
}

type App struct {
	downloader *downloader.Service
}

func (a *App) Run() {
	ctx := context.Background()

	app := App{}
	app.loadServices()

	port := 9922

	mux := http.NewServeMux()
	app.RegisterHandlers(mux)

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
	a.downloader, err = downloader.NewDownloader(downloadFolder, ytd)
	if err != nil {
		log.Fatal().Err(err).Msg("could not init downloader")
	}
}

func (a *App) RegisterHandlers(mux *http.ServeMux) {
	mux.HandleFunc("/hello", func(writer http.ResponseWriter, request *http.Request) {
		_, _ = writer.Write([]byte("fuck you Ezekiel"))
	})

	rou := router.Router{ParentMux: mux}
	rou.AddRouter(downloader.NewHandlerHttp(a.downloader))
}
