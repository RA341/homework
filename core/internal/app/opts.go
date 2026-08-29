package app

import (
	"io/fs"
	"net/http"
	"os"

	"github.com/ra341/homework/scribe"
	"github.com/rs/zerolog/log"
)

type Option func(*App)

func WithUIDir(path string) Option {
	return func(a *App) {
		rootDir, err := os.OpenRoot(path)
		if err != nil {
			log.Fatal().Err(err).Str("path", path).Msg("failed to open dir for ui")
		}

		a.uiDir = rootDir
		uiFs := http.FileServerFS(a.uiDir.FS())
		a.ui = uiFs
	}
}

func WithUIFS(fileSystem fs.FS) Option {
	return func(s *App) {
		uiFs := http.FileServerFS(fileSystem)
		s.ui = uiFs
	}
}

func WithUI(ui http.Handler) Option {
	return func(s *App) { s.ui = ui }
}

func WithScribeCli(cli scribe.ClientFactory) Option {
	return func(app *App) {
		app.scribeCliFactory = cli
	}
}
