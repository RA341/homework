package app

import (
	"context"
	"net/http"

	"github.com/ra341/homework/internal/downloads"
)

type Option func(*App)

func WithCtx(ctx context.Context) Option {
	return func(s *App) { s.ctx = ctx }
}

func WithUI(ui http.Handler) Option {
	return func(s *App) { s.ui = ui }
}

func WithPort(port int) Option {
	return func(s *App) { s.port = port }
}

func WithScribeCli(cli downloads.DownloadClient) Option {
	return func(app *App) {
		app.scribeCli = cli
	}
}
