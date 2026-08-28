package manager

import (
	"encoding/json/v2"
	"net/http"
)

type HandlerHttp struct {
	srv *Service
}

const downloaderEndpointPrefix = "/downloader"

func NewHandlerHttp(srv *Service) (string, http.Handler) {
	h := &HandlerHttp{
		srv: srv,
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/download", h.Download)

	return downloaderEndpointPrefix, mux
}

func (h *HandlerHttp) Status(w http.ResponseWriter, r *http.Request) {
	id := r.URL.Query().Get("id")
	if id == "" {
		http.Error(w, "id is required", http.StatusBadRequest)
		return
	}

	status, err := h.srv.Progress(id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	marshal, err := json.Marshal(status)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	_, _ = w.Write(marshal)
}

type DownloadResponse struct {
	Id string
}

func (h *HandlerHttp) Download(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()
	url := query.Get("url")
	if url == "" {
		w.WriteHeader(http.StatusBadRequest)
		_, _ = w.Write([]byte("url is empty"))
		return
	}

	downloadID, err := h.srv.Download(url)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		_, _ = w.Write([]byte("could not start download " + err.Error()))
		return
	}

	resp := &DownloadResponse{
		Id: downloadID,
	}

	marshal, err := json.Marshal(resp)
	if err != nil {
		return
	}

	w.WriteHeader(http.StatusOK)
	_, _ = w.Write(marshal)
}
