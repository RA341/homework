package downloader

import (
	"context"
	"net/http"

	"connectrpc.com/connect"
	v1 "github.com/ra341/homework/generated/api/downloader/v1"
	"github.com/ra341/homework/generated/api/downloader/v1/v1connect"
)

//go:generate autospec -struct IHandler -service DownloaderService -package downloader.v1 -go_package github.com/ra341/homework/generated/api/downloader/v1 -out ../../../spec/protos/downloader/v1/downloader.proto
type IHandler interface {
	Download(name, downloadLink, filepath string) error
}

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) (string, http.Handler) {
	h := &Handler{
		srv: srv,
	}
	return v1connect.NewDownloaderServiceHandler(h)
}

func (h *Handler) Download(_ context.Context, c *connect.Request[v1.DownloadRequest]) (*connect.Response[v1.DownloadResponse], error) {
	err := h.srv.AddDownload(c.Msg.Name, c.Msg.DownloadLink, c.Msg.Filepath)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&v1.DownloadResponse{}), nil
}
