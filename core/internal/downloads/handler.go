package downloads

import (
	"context"
	"fmt"
	"net/http"

	"connectrpc.com/connect"
	v1 "github.com/ra341/homework/generated/api/download/v1"
	"github.com/ra341/homework/generated/api/download/v1/v1connect"
)

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) (string, http.Handler) {
	h := &Handler{
		srv: srv,
	}
	return v1connect.NewDownloadServiceHandler(h)
}

func (h *Handler) Download(ctx context.Context, c *connect.Request[v1.DownloadRequest]) (*connect.Response[v1.DownloadResponse], error) {
	return nil, connect.NewError(connect.CodeUnimplemented, fmt.Errorf("implement me idiot"))
}
