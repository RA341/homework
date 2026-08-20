package app

import (
	"context"
	"net/http"
	"os"

	"github.com/ra341/homework/common/router"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func init() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: "15:04:05"})
}

func StartServer() {
	ctx := context.Background()

	app := App{}
	app.loadServices()

	port := ":9922"

	mux := http.NewServeMux()
	app.RegisterHandlers(mux)

	//mux.Handle("/", server.base.UIHandler)
	//finalMux := api.WithCors(mux, allowedOrigins)

	log.Info().Str("port", port).Msg("Starting homework downloader server...")
	router.RunServer(ctx, port, mux)
}
