package users

import (
	"context"
	"net/http"

	"connectrpc.com/connect"
	v1 "github.com/ra341/homework/generated/api/user/v1"
	"github.com/ra341/homework/generated/api/user/v1/v1connect"
)

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) (string, http.Handler) {
	h := &Handler{srv: srv}

	return v1connect.NewUserServiceHandler(h)
}

func (h *Handler) Self(ctx context.Context, c *connect.Request[v1.SelfRequest]) (*connect.Response[v1.SelfResponse], error) {
	id, _ := GetUserIDCtx(ctx)
	user, err := h.srv.GetById(uint(id))
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&v1.SelfResponse{
		User: &v1.User{
			UserId:   uint64(user.ID),
			Username: user.Username,
		},
	}), err
}
