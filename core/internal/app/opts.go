package app

import (
	"context"
	"net/http"
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
