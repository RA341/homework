package main

import (
	"github.com/ra341/homework/internal/app"
	"github.com/ra341/homework/scribe"
)

func main() {
	a := app.App{}
	a.Run(
		app.WithScribeCli(scribe.NewClient),
	)

}
