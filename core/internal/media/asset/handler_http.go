package asset

import (
	"net/http"
)

type HandlerHttp struct {
	srv *Service
}

func NewHandlerHttp(srv *Service) (string, http.Handler) {
	h := HandlerHttp{srv: srv}

	mux := http.NewServeMux()
	mux.HandleFunc("/load", h.Load)

	return "/assets", mux
}

func (h *HandlerHttp) Load(w http.ResponseWriter, r *http.Request) {
	params := r.URL.Query()

	contentIdStr := params.Get("contentId")
	assetRoleStr := params.Get("assetRole")

	asset, err := h.srv.Get(contentIdStr, assetRoleStr)
	if err != nil {
		_, _ = w.Write([]byte(err.Error()))
		return
	}

	http.ServeFile(w, r, asset.StoragePath)
}
