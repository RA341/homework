package downloads

import (
	"github.com/ra341/homework/common/pick"
	"github.com/rs/zerolog/log"
)

type Config struct {
	SocketPath   string
	DownloadsDir string

	ProgressCheckThreshold int
	CheckIntervalSecs      int
	MaxDownloads           int
	ServerUrl              string
}

const DefaultSocket = "/tmp/hw.sock"

func NewConfig(wd string) *Config {
	c := &Config{
		ServerUrl: pick.Pk[string]().
			Env("HW_SERVER_URL").
			GetOrDefault("http://localhost:9922"),
		SocketPath: pick.Pk[string]().
			Env("HW_SOCKET_PATH").
			GetOrDefault(DefaultSocket),
		DownloadsDir: pick.
			Pk[string]().
			Env("HW_DOWNLOADS_DIR").
			GetOrDefault(wd + "/downloads"),
	}
	log.Debug().Any("val", c).Msg("config")
	return c
}
