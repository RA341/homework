package router

import (
	"net/http"

	"github.com/rs/zerolog/log"
)

func LoggerMiddleware(enable bool) func(http.Handler) http.Handler {
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
