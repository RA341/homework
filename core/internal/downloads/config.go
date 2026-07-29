package downloads

import (
	"github.com/ra341/homework/common/pick"
)

type Config struct {
	SocketPath   string
	DownloadsDir string
}

const DefaultSocket = "/tmp/hw.sock"

func NewConfig(wd string) *Config {
	return &Config{
		SocketPath: pick.Pk[string]().
			Env("HW_SOCKET_PATH").
			GetOrDefault(DefaultSocket),
		DownloadsDir: pick.
			Pk[string]().
			Env("HW_DOWNLOADS_DIR").
			GetOrDefault(wd + "/downloads"),
	}
}
