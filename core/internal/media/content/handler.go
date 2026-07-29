package content

import (
	"context"
	"net/http"

	"connectrpc.com/connect"
	"github.com/ra341/homework/common/list"
	v1 "github.com/ra341/homework/generated/api/content/v1"
	"github.com/ra341/homework/generated/api/content/v1/v1connect"
)

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) (string, http.Handler) {
	h := Handler{srv: srv}
	return v1connect.NewContentServiceHandler(&h)
}

func (h *Handler) List(ctx context.Context, c *connect.Request[v1.ListRequest]) (*connect.Response[v1.ListResponse], error) {
	msg := c.Msg
	res, err := h.srv.List(msg.Query, uint(msg.After), uint(msg.Before), uint(msg.Limit))
	if err != nil {
		return nil, err
	}

	conv := func(c Content) *v1.Content {
		return &v1.Content{
			Id:          uint64(c.ID),
			Title:       c.Title,
			Description: c.Description,
			Type:        c.Type.String(),

			CreatedAt: c.CreatedAt.Unix(),
			UpdatedAt: c.UpdatedAt.Unix(),
		}
	}

	return connect.NewResponse(&v1.ListResponse{
		Results: list.Map(res.Results, conv),
		After:   uint64(res.After),
		Before:  uint64(res.Before),
		Count:   uint64(res.Count),
	}), nil
}
