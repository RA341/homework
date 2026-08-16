package browser

import (
	"context"
	"net/http"

	"connectrpc.com/connect"
	v1 "github.com/ra341/homework/generated/api/browser/v1"
	"github.com/ra341/homework/generated/api/browser/v1/v1connect"
)

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) (string, http.Handler) {
	h := &Handler{srv: srv}
	return v1connect.NewBrowserServiceHandler(h)
}

func (h *Handler) Start(ctx context.Context, c *connect.Request[v1.StartRequest]) (*connect.Response[v1.StartResponse], error) {
	_, _, err := h.srv.cli.Start()
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&v1.StartResponse{}), nil
}

func (h *Handler) Stop(ctx context.Context, c *connect.Request[v1.StopRequest]) (*connect.Response[v1.StopResponse], error) {
	_, _, err := h.srv.cli.Stop()
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&v1.StopResponse{}), nil
}

func (h *Handler) Status(ctx context.Context, c *connect.Request[v1.StatusRequest]) (*connect.Response[v1.StatusResponse], error) {
	_, _, err := h.srv.cli.Status()
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&v1.StatusResponse{}), nil
}
