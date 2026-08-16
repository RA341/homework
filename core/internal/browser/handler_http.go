package browser

import (
	"net/http"
	"net/http/httputil"
	"net/url"
	"strings"

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
	vncProxy.Director = nil
	vncProxy.Rewrite = func(r *httputil.ProxyRequest) {
		r.SetURL(serviceHost)

		log.Debug().Str("out", r.Out.Method).Str("in", r.In.Method).Msg("input")

		// strip the "/vnc" prefix, keep whatever follows (e.g. /assets/index-....css)
		p := strings.TrimPrefix(r.In.URL.Path, "/vnc")

		// Ensure clean path merge between serviceHost.Path and p to avoid double slashes
		outPath := serviceHost.Path
		if strings.HasSuffix(outPath, "/") && strings.HasPrefix(p, "/") {
			outPath = outPath + p[1:]
		} else if !strings.HasSuffix(outPath, "/") && !strings.HasPrefix(p, "/") {
			outPath = outPath + "/" + p
		} else {
			outPath = outPath + p
		}
		r.Out.URL.Path = outPath
		r.Out.URL.RawPath = ""
		r.Out.URL.RawQuery = r.In.URL.RawQuery

		// Restore WebSocket handshake headers if present, since Rewrite removes hop-by-hop headers
		if upgrade := r.In.Header.Get("Upgrade"); upgrade != "" {
			r.Out.Header.Set("Upgrade", upgrade)
			if conn := r.In.Header.Get("Connection"); conn != "" {
				r.Out.Header.Set("Connection", conn)
			} else {
				r.Out.Header.Set("Connection", "Upgrade")
			}
		}

		r.SetXForwarded()
	}
	mux.HandleFunc("/vnc", func(w http.ResponseWriter, r *http.Request) {
		target := "vnc/"
		if r.URL.RawQuery != "" {
			target += "?" + r.URL.RawQuery
		}
		w.Header().Set("Location", target)
		w.WriteHeader(http.StatusMovedPermanently)
	})
	mux.Handle("/vnc/", vncProxy)

	return "/browser", mux
}
