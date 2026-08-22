package downloader

import (
	"github.com/ra341/homework/common/pick"
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
	return &Config{
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
}
