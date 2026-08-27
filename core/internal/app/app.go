package app

import (
	"context"
	"net/http"
	"os"
	"path/filepath"

	"github.com/joho/godotenv"
	"github.com/ra341/homework/common/database"
	"github.com/ra341/homework/common/router"
	"github.com/ra341/homework/internal/auth/authentication"
	"github.com/ra341/homework/internal/auth/session"
	"github.com/ra341/homework/internal/browser"
	"github.com/ra341/homework/internal/downloads"
	"github.com/ra341/homework/internal/media"
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/media/content"
	"github.com/ra341/homework/internal/users"
	"github.com/ra341/homework/scribe"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"gorm.io/gorm"
)

func init() {
	//zerolog.CallerMarshalFunc = func(pc uintptr, file string, line int) string {
	//	short := file
	//
	//
	//
	//	filepath.Base()
	//	// keep last 2 path segments: package dir + filename
	//	if idx := strings.LastIndexByte(file, '/'); idx != -1 {
	//		if idx2 := strings.LastIndexByte(file[:idx], '/'); idx2 != -1 {
	//			short = file[idx2+1:]
	//		}
	//	}
	//	return short + ":" + strconv.Itoa(line)
	//}

	log.Logger = log.With().Caller().Logger().Output(
		zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: "15:04:05"},
	)
}

type App struct {
	ctx context.Context
	ui  http.Handler

	conf Config
	db   *gorm.DB

	content *content.Service
	asset   *asset.Service
	media   *media.Service

	downloads        *downloads.Service
	scribeCliFactory scribe.ClientFactory

	browser *browser.Service
	user    *users.Service
	auth    *authentication.Service
	session *session.Service
}

func (a *App) Run(opts ...Option) {
	a.conf.Server.Port = 9911
	a.ctx = context.Background()
	for _, opt := range opts {
		opt(a)
	}

	a.loadConfig()

	mux := http.NewServeMux()
	a.addServices()
	a.addHandlers(mux)

	//mux.Handle("/", server.base.UIHandler)
	//allowedOrigins := []string{"https://beacon.pro.radn.dev"}
	//finalMux := api.WithCors(mux, allowedOrigins)

	log.Info().Int("port", a.conf.Server.Port).Msg("Starting homework server...")
	router.RunServer(a.ctx, a.conf.Server.Port, mux)
}

func (a *App) loadConfig() {
	config := Config{}
	err := godotenv.Load()
	if err != nil {
		log.Warn().Err(err).Msg("Error loading .env file")
	}

	err = config.Load()
	if err != nil {
		log.Fatal().Err(err).Msg("failed to load configuration")
	}

	a.conf = config
}

func (a *App) addServices() {
	workingDir, dataDir := a.initAppDataDir()

	a.initDB(dataDir)

	a.addAssetSrv()
	a.addContentSrv()
	a.addBrowserSrv()
	a.addDownloadsSrv(workingDir)
	a.addMediaSrv()

	a.addSessionSrv()
	a.addUserSrv()
	a.addAuthSrv()
}

func (a *App) addAuthSrv() {
	a.auth = authentication.NewService(&a.conf.Auth, a.session, a.user)
}

func (a *App) addUserSrv() {
	var err error

	userStore := users.NewStore(a.db)
	a.user, err = users.NewService(userStore, &a.conf.Users)
	if err != nil {
		log.Warn().Err(err).Msg("could not init user service")
	}
}

func (a *App) addSessionSrv() {
	sessionDb := session.NewStore(a.db)
	a.session = session.NewService(sessionDb, &a.conf.Session)
}

func (a *App) initAppDataDir() (workingDir string, dataDir string) {
	var err error

	workingDir, err = os.Getwd()
	if err != nil {
		log.Fatal().Err(err).Msg("could not get working directory")
	}

	dataDir = filepath.Join(workingDir, "data")
	err = os.MkdirAll(dataDir, 0755)
	if err != nil {
		log.Fatal().Err(err).Str("path", dataDir).Msg("could make data dir")
	}

	return workingDir, dataDir
}

func (a *App) addMediaSrv() {
	var err error

	a.media, err = media.NewService(
		&a.conf.Media,
		a.content,
		a.asset,
		a.downloads,
	)
	if err != nil {
		log.Fatal().Err(err).Msg("could not create media service")
	}
}

func (a *App) addDownloadsSrv(dir string) {
	var err error

	//browserData := "browser"
	//downloaderCli, err := scribe.NewClient(browserData, config.DownloadsDir)
	//if err != nil {
	//	log.Fatal().Err(err).Msg("could not create downloader client")
	//}

	downloadDb := downloads.NewStoreGorm(a.db)

	scribeCli, err := a.scribeCliFactory(&a.conf.Downloads)
	if err != nil {
		log.Fatal().Err(err).Msg("could not load scribe client")
		return
	}

	a.downloads, err = downloads.NewService(
		&a.conf.Downloads,
		downloadDb,
		scribeCli,
		a.asset,
	)
	if err != nil {
		// todo handle gracefully
		log.Fatal().Err(err).Msg("could not create downloads service")
	}
}

func (a *App) addContentSrv() {
	contentStore := content.NewStore(a.db)
	a.content = content.NewService(contentStore)
}

func (a *App) addAssetSrv() {
	var err error

	//assetFolder := "assets"

	assetStore := asset.NewStore(a.db)
	a.asset, err = asset.NewService(assetStore, &a.conf.Assets)
	if err != nil {
		log.Fatal().Msg("error initializing asset service")
	}
	return
}

func (a *App) addBrowserSrv() {

	a.browser = browser.NewService(a.ctx, &a.conf.Browser)
	return
}

func (a *App) initDB(dataPath string) {
	dbPath := filepath.Join(dataPath, "hw.db")
	db, err := database.InitDB(dbPath)
	if err != nil {
		log.Fatal().Err(err).Str("path", dbPath).Msg("could not init database")
	}

	models := []any{
		&asset.Asset{},
		&content.Content{},
		&downloads.Download{},
		&users.User{},
		&session.Session{},
	}

	err = db.AutoMigrate(models...)
	if err != nil {
		log.Fatal().Err(err).Msg("could auto migrate models database")
	}

	a.db = db
}

func (a *App) addHandlers(r *http.ServeMux) {
	ro := router.Router{ParentMux: r}

	const ApiPrefix = "/api"
	apiMux := http.NewServeMux()
	a.addApiHandlers(apiMux)

	logger := router.LoggerMiddleware(false)

	ro.AddRouter(ApiPrefix, logger(apiMux))

	a.addUIHandler(r)

}

func (a *App) addApiHandlers(r *http.ServeMux) {
	rou := router.Router{ParentMux: r}

	const publicPrefix = "/public"
	publicMux := http.NewServeMux()
	a.addPublicHandlers(publicMux)
	rou.AddRouter(publicPrefix, publicMux)

	const protectedPrefix = "/protected"
	protectedMux := http.NewServeMux()
	a.addProtectedHandlers(protectedMux)
	authM := authentication.NewAuthMiddleware(a.auth)
	rou.AddRouter(protectedPrefix, authM(protectedMux))
}

func (a *App) addProtectedHandlers(mux *http.ServeMux) {
	rou := router.Router{ParentMux: mux}

	mux.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		_, _ = w.Write([]byte("pong"))
	})

	// normal http handlers need prefix stripping
	rou.AddRouter(media.NewHandlerHttp(a.media))
	rou.AddRouter(asset.NewHandlerHttp(a.asset))

	// connect rpc should not strip the prefix
	rou.AddHandler(users.NewHandler(a.user))
	rou.AddHandler(browser.NewHandler(a.browser))
	rou.AddHandler(media.NewHandler(a.media))
	rou.AddHandler(downloads.NewHandler(a.downloads))
	rou.AddHandler(content.NewHandler(a.content))
}

func (a *App) addPublicHandlers(mux *http.ServeMux) {
	rou := router.Router{ParentMux: mux}

	rou.AddHandler(authentication.NewHandler(a.auth))
	rou.AddRouter(browser.NewHandlerHttp(a.browser))

	mux.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		_, _ = w.Write([]byte("pong"))
	})
}

func (a *App) addUIHandler(r *http.ServeMux) {
	if a.ui == nil {
		r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
			_, _ = w.Write([]byte("No ui set fuck off"))
		})
		return
	}

	r.Handle("/", a.ui)
}
