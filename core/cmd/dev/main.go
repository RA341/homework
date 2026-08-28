package main

import (
	"github.com/ra341/homework/internal/app"
	"github.com/ra341/homework/internal/downloads"
	"github.com/ra341/homework/scribe"
)

func main() {
	a := app.App{}
	cli := func(config scribe.FactoryClientConfig) (downloads.DownloadClient, error) {
		return scribe.NewClientUnified(config)
	}
	a.Run(
		app.WithScribeCli(cli),
	)

}
