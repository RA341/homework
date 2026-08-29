package scribe

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/ra341/homework/common/knob"
	"github.com/ra341/homework/common/router"
	"github.com/ra341/homework/scribe/manager"
	"github.com/ra341/homework/scribe/ytdlp"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func init() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: "15:04:05"})
}

type Config struct {
	BrowserDir  string `knob:"default=browser,env=BROWSER_DIR,help=dir to use for browser files"`
	DownloadDir string `knob:"default=downloads,env=DOWNLOAD_DIR,help=downloads directory"`

	Port int `knob:"default=9922,env=PORT,help=port for the server"`
}

func (c *Config) load() {
	const EnvPrefix = "SCRIBE_"
	prefixer := knob.NewPrefixer(EnvPrefix)

	err := knob.LoadConfig(
		c,
		knob.WithEnvPrefixer(prefixer),
		knob.WithValueLoaders(knob.AbsDirValueLoader()),
	)
	if err != nil {
		log.Fatal().Err(err).Msg("Could not load config")
	}

	knob.PrettyPrint(c, prefixer)
}

type App struct {
	config Config

	downloader *manager.Service
}

func (a *App) Run() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	a.config.load()
	a.loadServices()

	mux := http.NewServeMux()
	a.RegisterHandlers(mux)

	//mux.Handle("/", server.base.UIHandler)
	//finalMux := api.WithCors(mux, allowedOrigins)

	log.Info().Int("port", a.config.Port).Msg("Starting scribe server...")
	router.RunServer(ctx, a.config.Port, mux)
}

func (a *App) loadConfig() {

}

func (a *App) loadServices() {
	var err error

	ytd, err := ytdlp.NewService(a.config.BrowserDir)
	if err != nil {
		log.Fatal().Err(err).Msg("could not init yt-dlp")
	}

	a.downloader, err = manager.NewService(a.config.DownloadDir, ytd)
	if err != nil {
		log.Fatal().Err(err).Msg("could not init downloader")
	}
}

func (a *App) RegisterHandlers(mux *http.ServeMux) {
	mux.HandleFunc("/hello", func(writer http.ResponseWriter, request *http.Request) {
		_, _ = writer.Write([]byte("fuck you Ezekiel"))
	})

	rou := router.Router{ParentMux: mux}
	rou.AddRouter(manager.NewHandlerHttp(a.downloader))
}
