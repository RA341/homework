package app

import (
	"github.com/ra341/homework/common/knob"
	"github.com/ra341/homework/internal/auth/authentication"
	"github.com/ra341/homework/internal/auth/session"
	"github.com/ra341/homework/internal/browser"
	"github.com/ra341/homework/internal/database"
	"github.com/ra341/homework/internal/downloads"
	"github.com/ra341/homework/internal/media"
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/users"
)

type ServerConfig struct {
	Port int `knob:"default=9911,env=PORT,help=default port for server"`
	//Cors []string `knob:"default=Cors,env=CORS_CONFIG,help=cors string"`
}

type Config struct {
	Server   ServerConfig
	Database database.Config

	Auth    authentication.Config
	Session session.Config
	Users   users.Config

	Assets    asset.Config
	Downloads downloads.Config
	Media     media.Config
	Browser   browser.Config
}

func (c *Config) Load() error {
	const EnvPrefix = "HW_"
	prefixer := knob.NewPrefixer(EnvPrefix)

	err := knob.LoadConfig(
		c,
		knob.WithEnvPrefixer(prefixer),
		knob.WithValueLoaders(knob.AbsDirValueLoader()),
	)
	if err != nil {
		return err
	}

	knob.PrettyPrint(c, prefixer)

	return nil
}
