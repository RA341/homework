package app

import (
	"encoding/json"
	"fmt"
	"log"

	"github.com/ra341/homework/internal/auth/authentication"
	"github.com/ra341/homework/internal/auth/session"
	"github.com/ra341/homework/internal/browser"
	"github.com/ra341/homework/internal/downloads"
	"github.com/ra341/homework/internal/media"
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/users"
)

type ServerConfig struct {
	Port int `knob:"default=9911,env=PORT,help=default port for server"`
}

type Config struct {
	Server ServerConfig

	Auth    authentication.Config
	Session session.Config
	Users   users.Config

	Assets    asset.Config
	Downloads downloads.Config
	Media     media.Config
	Browser   browser.Config
}

func (c *Config) Load() error {
	k := Knob{prefixer: func(s string) string {
		return s
	}}

	err := k.WalkStruct(c, "")
	if err != nil {
		log.Fatal(err)
	}

	b, _ := json.MarshalIndent(c, "", "  ")
	fmt.Println(string(b))

	return fmt.Errorf("implement me idiot")
}
