package downloads

type Config struct {
	DownloadsDir     string
	BrowserDir       string
	ScribeServiceUrl string

	CheckThreshold    int
	CheckIntervalSecs int

	WorkerMaxDownloads  int
	WorkerExitThreshold int
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
