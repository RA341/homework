package authentication

import (
	"net/http"

	"github.com/ra341/homework/internal/users"
	"github.com/rs/zerolog/log"
)

const SessionHeader = "session"
const RefreshHeader = "refresh"

func NewAuthMiddleware(srv *Service) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			sessionToken := r.Header.Get(SessionHeader)
			if sessionToken != "" {
				userId, err := srv.verifyRefresh(sessionToken)
				if err == nil {
					ctx := users.SetUserIdCtx(r.Context(), uint64(userId))
					next.ServeHTTP(w, r.WithContext(ctx))
					return
				}
				//log.Debug().Err(err).Msg("could not verify session")
			}

			// If session token is missing, invalid or expired, check refresh token
			refreshToken := r.Header.Get(RefreshHeader)
			if refreshToken == "" {
				//log.Debug().Msg("no refresh token provided")
				http.Error(w, "Unauthorized", http.StatusUnauthorized)
				return
			}

			newSessionToken, newRefreshToken, err := srv.Refresh(refreshToken)
			if err != nil {
				http.Error(w, "Unauthorized", http.StatusUnauthorized)
				return
			}

			// Set new tokens in response headers
			w.Header().Set(SessionHeader, newSessionToken.Value)
			w.Header().Set(RefreshHeader, newRefreshToken.Value)
			log.Debug().Msg("session refreshed")

			refresh, err := srv.verifyRefresh(newSessionToken.Value)
			if err != nil {
				log.Warn().Err(err).Msg("Could not read new session token")
				http.Error(w, "Internal Server Error", http.StatusInternalServerError)
				return
			}

			ctx := users.SetUserIdCtx(r.Context(), uint64(refresh))
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}
