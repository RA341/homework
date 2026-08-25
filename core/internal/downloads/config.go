package downloads

import (
	"github.com/ra341/homework/common/pick"
	"github.com/rs/zerolog/log"
)

type Config struct {
	SocketPath string

	DownloadsDir     string
	BrowserDir       string
	ScribeServiceUrl string

	ProgressCheckThreshold int
	CheckIntervalSecs      int
	MaxDownloads           int
}

func (c *Config) GetBrowserDir() string {
	return c.BrowserDir
}

func (c *Config) GetDownloadsDir() string {
	return c.DownloadsDir
}

func (c *Config) GetServiceUrl() string {
	return c.ScribeServiceUrl
}

const DefaultSocket = "/tmp/hw.sock"

func NewConfig(wd string) *Config {
	c := &Config{
		ScribeServiceUrl: pick.Pk[string]().
			Env("HW_SERVER_URL").
			GetOrDefault("http://localhost:9922"),
		SocketPath: pick.Pk[string]().
			Env("HW_SOCKET_PATH").
			GetOrDefault(DefaultSocket),
		DownloadsDir: pick.
			Pk[string]().
			Env("HW_DOWNLOADS_DIR").
			GetOrDefault(wd + "/downloads"),
		BrowserDir: pick.
			Pk[string]().
			Env("HW_BROWSER_DIR").
			GetOrDefault(wd + "/browser"),
	}

	log.Debug().Any("val", c).Msg("config")
	return c
}
