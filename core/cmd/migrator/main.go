package main

import (
	"fmt"
	"io"
	"os"

	"ariga.io/atlas-provider-gorm/gormschema"
	"github.com/ra341/homework/internal/auth/session"
	"github.com/ra341/homework/internal/downloads"
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/media/content"
	"github.com/ra341/homework/internal/users"
)

func main() {
	models := []any{
		&asset.Asset{},
		&content.Content{},
		&downloads.Download{},
		&users.User{},
		&session.Session{},
	}

	stmts, err := gormschema.New("sqlite").Load(models...)
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to load gorm schema: %v\n", err)
		os.Exit(1)
	}
	io.WriteString(os.Stdout, stmts)
}
