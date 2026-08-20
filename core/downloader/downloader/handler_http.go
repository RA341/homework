package downloader

import "net/http"

type HandlerHttp struct {
	srv *Service
}

func NewHandlerHttp(srv *Service) (string, http.Handler) {
	h := &HandlerHttp{
		srv: srv,
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/download", h.Download)

	return "/downloader", mux
}

func (h *HandlerHttp) Download(writer http.ResponseWriter, request *http.Request) {
	query := request.URL.Query()
	url := query.Get("url")
	if url == "" {
		writer.WriteHeader(http.StatusBadRequest)
		_, _ = writer.Write([]byte("url is empty"))
		return
	}

	err := h.srv.Start(url)
	if err != nil {
		writer.WriteHeader(http.StatusBadRequest)
		_, _ = writer.Write([]byte("could not start download " + err.Error()))
		return
	}

	writer.WriteHeader(http.StatusOK)
	_, _ = writer.Write([]byte("Download Started"))
}
