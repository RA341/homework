package app

import (
	"context"
	"net/http"
	"os"
	"path/filepath"
	"time"

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
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: "15:04:05"})
}

type App struct {
	ctx  context.Context
	ui   http.Handler
	port int

	db      *gorm.DB
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
	a.port = 9911
	a.ctx = context.Background()
	for _, opt := range opts {
		opt(a)
	}

	mux := http.NewServeMux()
	a.addServices()
	a.addHandlers(mux)

	//mux.Handle("/", server.base.UIHandler)
	//allowedOrigins := []string{"https://beacon.pro.radn.dev"}
	//finalMux := api.WithCors(mux, allowedOrigins)

	log.Info().Int("port", a.port).Msg("Starting homework server...")
	router.RunServer(a.ctx, a.port, mux)
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
	jwtSecret := "test-secret-change-me"
	a.auth = authentication.NewService(jwtSecret, a.session, a.user)
}

func (a *App) addUserSrv() {
	var err error

	userStore := users.NewStore(a.db)
	a.user, err = users.NewService(userStore)
	if err != nil {
		log.Warn().Err(err).Msg("could not init user service")
	}
}

func (a *App) addSessionSrv() {
	sessionDb := session.NewStore(a.db)
	sessionExpiry := time.Hour * 24 * 7
	a.session = session.NewService(sessionDb, sessionExpiry)
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

	const uploadFolder = "temp"
	a.media, err = media.NewService(
		a.content,
		a.asset,
		a.downloads,
		uploadFolder,
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

	config := downloads.NewConfig(dir)
	downloadDb := downloads.NewStoreGorm(a.db)

	scribeCli, err := a.scribeCliFactory(config)
	if err != nil {
		log.Fatal().Err(err).Msg("could not load scribe client")
		return
	}

	a.downloads, err = downloads.NewService(
		config,
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

	assetStore := asset.NewStore(a.db)
	assetFolder := "assets"
	a.asset, err = asset.NewService(assetStore, assetFolder)
	if err != nil {
		log.Fatal().Msg("error initializing asset service")
	}
	return
}

func (a *App) addBrowserSrv() {
	var err error

	apiUrl := "http://localhost:8998"
	vncUrl := "http://localhost:3012/"
	a.browser, err = browser.NewService(apiUrl, vncUrl)
	if err != nil {
		log.Warn().Err(err).Msg("could not create chromtrol client")
	}
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
