package app

import (
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/ra341/homework/common/database"
	"github.com/ra341/homework/internal/downloader"
	"github.com/ra341/homework/internal/media"
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/media/content"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"gorm.io/gorm"
)

func init() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: "15:04:05"})
}

type App struct {
	downloads      *downloader.Service
	mediaService   *media.Service
	contentService *content.Service
	assetService   *asset.Service
	db             *gorm.DB
}

func (a *App) RegisterServices() {
	dir, err := os.Getwd()
	if err != nil {
		log.Fatal().Err(err).Msg("could not get working directory")
	}

	config := downloader.NewConfig(dir)
	log.Debug().Any("val", config).Msg("config")

	dataPath := filepath.Join(dir, "data")
	err = os.MkdirAll(dataPath, 0755)
	if err != nil {
		log.Fatal().Err(err).Str("path", dataPath).Msg("could make data dir")
	}

	a.InitDB(dataPath)

	assetStore := asset.NewStore(a.db)
	assetFolder := "assets"
	a.assetService = asset.NewService(assetStore, assetFolder)

	contentStore := content.NewStore(a.db)
	a.contentService = content.NewService(contentStore)

	downloadDb := downloader.NewStoreGorm(a.db)

	pyDownloader, err := downloader.NewPyClient(config.ServerUrl)
	if err != nil {
		log.Warn().Err(err).Msg("could not create ping downloader")
		// todo handle gracefully
		//log.Fatal().Err(err).Msg("could not create py downloader")
	}

	a.downloads, err = downloader.NewService(config, downloadDb, pyDownloader, a.assetService)
	if err != nil {
		// todo handle gracefully
		log.Fatal().Err(err).Msg("could not create downloads service")
	}

	const uploadFolder = "temp"
	a.mediaService, err = media.NewService(a.contentService, a.assetService, a.downloads, uploadFolder)
	if err != nil {
		log.Fatal().Err(err).Msg("could not create media service")
	}

	//_, err = downloadService.Download("https://www.youtube.com/watch?v=fVNgE-HaKxo")
	//if err != nil {
	//	log.Fatal().Err(err).Msg("could not download video")
	//}
}

func (a *App) InitDB(dataPath string) {
	dbPath := filepath.Join(dataPath, "hw.db")
	db, err := database.InitDB(dbPath)
	if err != nil {
		log.Fatal().Err(err).Str("path", dbPath).Msg("could not init database")
	}

	models := []any{
		&asset.Asset{},
		&content.Content{},
		&downloader.Download{},
	}

	err = db.AutoMigrate(models...)
	if err != nil {
		log.Fatal().Err(err).Msg("could auto migrate models database")
	}

	a.db = db
}

func (a *App) RegisterHandlers(r *http.ServeMux) {
	ro := Rou{parentMux: r}

	const ApiPrefix = "/api"
	apiMux := http.NewServeMux()
	a.registerApiHandlers(apiMux)

	logger := loggerMiddleware(false)

	ro.AddRouter(ApiPrefix, logger(apiMux))

	const uiPrefix = "/"
	uiMux := http.NewServeMux()
	a.registerUIHandler(uiMux)
	ro.AddRouter(uiPrefix, uiMux)
}

func (a *App) registerApiHandlers(r *http.ServeMux) {
	r.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		_, _ = w.Write([]byte("pong"))
	})

	rou := Rou{parentMux: r}

	// normal http handlers need prefix stripping
	rou.AddRouter(media.NewHandlerHttp(a.mediaService))
	rou.AddRouter(asset.NewHandlerHttp(a.assetService))

	// connect rpc should not strip the prefix
	rou.AddHandler(media.NewHandler(a.mediaService))
	rou.AddHandler(downloader.NewHandler(a.downloads))
	rou.AddHandler(content.NewHandler(a.contentService))
}

func (a *App) registerUIHandler(r *http.ServeMux) {
	// todo
	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		_, _ = w.Write([]byte("No ui set fuck off"))
	})
}

func loggerMiddleware(enable bool) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		if !enable {
			return next
		}
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			log.Info().Str("method", r.Method).
				Str("path", r.URL.Path).
				Msg("request started")
			next.ServeHTTP(w, r)
		})
	}
}

type Rou struct {
	parentMux *http.ServeMux
}

// AddRouter registers a childMux under path on parentMux, stripping the prefix.
func (r *Rou) AddRouter(path string, childMux http.Handler) {
	pattern := path
	if pattern == "" {
		pattern = "/"
	}
	if pattern != "/" && !strings.HasSuffix(pattern, "/") {
		pattern = pattern + "/"
	}

	prefix := strings.TrimSuffix(path, "/")

	var handler = childMux
	if prefix != "" && prefix != "/" {
		handler = http.StripPrefix(prefix, childMux)
	}

	r.parentMux.Handle(pattern, handler)
}

// AddHandler registers a handler under path on parentMux without stripping the prefix.
func (r *Rou) AddHandler(path string, handler http.Handler) {
	pattern := path
	if pattern == "" {
		pattern = "/"
	}
	if pattern != "/" && !strings.HasSuffix(pattern, "/") {
		pattern = pattern + "/"
	}

	r.parentMux.Handle(pattern, handler)
}
