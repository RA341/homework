package app

import (
	"github.com/ra341/homework/internal/auth/authentication"
	"github.com/ra341/homework/internal/auth/session"
	"github.com/ra341/homework/internal/browser"
	"github.com/ra341/homework/internal/downloads"
	"github.com/ra341/homework/internal/media"
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/users"
)

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

type ServerConfig struct {
	Port int
}
