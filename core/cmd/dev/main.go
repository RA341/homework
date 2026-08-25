package main

import (
	"github.com/ra341/homework/internal/app"
	"github.com/ra341/homework/scribe"
	"github.com/rs/zerolog/log"
)

func main() {
	scribeCli, err := scribe.NewClient(
		"../dev/browser",
		"downloads",
	)
	if err != nil {
		log.Fatal().Err(err).Msg("could init scribe client")
	}

	a := app.App{}
	a.Run(
		app.WithScribeCli(scribeCli),
	)

}
