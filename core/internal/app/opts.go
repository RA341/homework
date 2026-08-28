package app

import (
	"context"
	"net/http"

	"github.com/ra341/homework/scribe"
)

type Option func(*App)

func WithCtx(ctx context.Context) Option {
	return func(s *App) { s.ctx = ctx }
}

func WithUI(ui http.Handler) Option {
	return func(s *App) { s.ui = ui }
}

func WithScribeCli(cli scribe.ClientFactory) Option {
	return func(app *App) {
		app.scribeCliFactory = cli
	}
}
