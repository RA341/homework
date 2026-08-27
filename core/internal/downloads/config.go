package downloads

import "time"

type Config struct {
	DownloadsDir     string `knob:"default=downloads,env=DOWNLOAD_DIR,help=dir to store temp downloaded files"`
	BrowserDir       string `knob:"default=browser,env=BROWSER_DIR,help=dir to find browser configs and cookies"`
	ScribeServiceUrl string `knob:"default=http://localhost:9922,env=SCRIBE_URL,help=url for the scribe service if running in separate containers"`

	CheckThreshold    int           `knob:"default=3,env=PROGGRESS_CHECK_THRESHOLD,help=amount of times to retry progress check after a failed check"`
	CheckIntervalSecs time.Duration `knob:"default=5s,env=PROGRESS_INTERVAL_DUR,help=time between a progress check for a download"`

	WorkerMaxDownloads  int `knob:"default=10,env=MAX_DOWNLOADS,help=max concurrent downloads"`
	WorkerExitThreshold int `knob:"default=5,env=WORKER_EXIT_THRESHOLD,help=amount of times to check for new downloads before exiting download worker"`
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

//func NewConfig(wd string) *Config {
//	c := &Config{
//		// todo load dyn
//		WorkerMaxDownloads:  5,
//		WorkerExitThreshold: 5,
//
//		ScribeServiceUrl: pick.Pk[string]().
//			Env("HW_SERVER_URL").
//			GetOrDefault("http://localhost:9922"),
//		DownloadsDir: pick.
//			Pk[string]().
//			Env("HW_DOWNLOADS_DIR").
//			GetOrDefault(wd + "/downloads"),
//		BrowserDir: pick.
//			Pk[string]().
//			Env("HW_BROWSER_DIR").
//			GetOrDefault(wd + "/browser"),
//	}
//
//	log.Debug().Any("val", c).Msg("config")
//	return c
//}
