package router

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"time"

	"github.com/rs/zerolog/log"
)

func RunServer(ctx context.Context, port int, mux *http.ServeMux) {
	protocols := &http.Protocols{}
	protocols.SetUnencryptedHTTP2(true)
	protocols.SetHTTP2(true)
	protocols.SetHTTP1(true)

	srv := &http.Server{
		Addr:      fmt.Sprintf(":%d", port),
		Protocols: protocols,
		Handler:   mux,
	}

	go func() {
		var err error
		err = srv.ListenAndServe()
		if err != nil && !errors.Is(err, http.ErrServerClosed) {
			log.Fatal().Err(err).Msg("Error starting server")
		}
	}()

	<-ctx.Done()

	log.Info().Msg("Context cancelled. Shutting down server...")
	shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	if err := srv.Shutdown(shutdownCtx); err != nil {
		log.Error().Err(err).Msg("Error occurred while shutting down server")
		return
	}

	log.Info().Msg("Server gracefully stopped.")
}
