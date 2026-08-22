package main

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/ra341/homework/common/fu"
	"github.com/ra341/homework/internal/app"
	"github.com/rs/zerolog/log"
)

func main() {
	a := app.App{}

	// todo this wrong because of subpaths fix
	rootDir := loadWeb()
	defer fu.CloseCloser(rootDir)
	fs := rootDir.FS()

	ui := http.FileServerFS(fs)

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	a.Run(
		app.WithUI(ui),
		app.WithCtx(ctx),
	)
}

func loadWeb() *os.Root {
	root, err := os.OpenRoot("web")
	if err != nil {
		log.Fatal().Err(err).Msg("failed to load web dir")
	}
	return root
}
