package browser

import (
	"net/http"
	"net/http/httputil"
	"net/url"

	"github.com/rs/zerolog/log"
)

//type HandlerHttp struct {
//	srv *Service
//}

func NewHandlerHttp(srv *Service) (string, http.Handler) {
	//h := HandlerHttp{
	//	srv: srv,
	//}

	mux := http.NewServeMux()

	serviceHost, err := url.Parse(srv.vncUrl)
	if err != nil {
		log.Fatal().Err(err).Msg("Failed to parse service URL")
	}

	vncProxy := httputil.NewSingleHostReverseProxy(serviceHost)
	mux.Handle("/vnc", vncProxy)

	return "browser", mux
}
