package authentication

import (
	"context"
	"net/http"

	"connectrpc.com/connect"
	v1 "github.com/ra341/homework/generated/api/auth/v1"
	"github.com/ra341/homework/generated/api/auth/v1/v1connect"
)

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) (string, http.Handler) {
	h := &Handler{
		srv: srv,
	}

	return v1connect.NewAuthServiceHandler(h)
}

func (h *Handler) Login(ctx context.Context, c *connect.Request[v1.LoginRequest]) (*connect.Response[v1.LoginResponse], error) {
	sessionToken, refreshToken, err := h.srv.Login(c.Msg.Username, c.Msg.Password)
	if err != nil {
		return nil, connect.NewError(connect.CodeUnauthenticated, err)
	}

	return connect.NewResponse(&v1.LoginResponse{
		Session: &v1.Token{
			Value:  sessionToken.Value,
			Expiry: sessionToken.Expiry,
		},
		Refresh: &v1.Token{
			Value:  refreshToken.Value,
			Expiry: refreshToken.Expiry,
		},
	}), nil
}

func (h *Handler) Logout(ctx context.Context, c *connect.Request[v1.LogoutRequest]) (*connect.Response[v1.LogoutResponse], error) {
	err := h.srv.Logout(c.Msg.RefreshToken)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&v1.LogoutResponse{}), nil
}

func (h *Handler) Refresh(ctx context.Context, c *connect.Request[v1.RefreshRequest]) (*connect.Response[v1.RefreshResponse], error) {
	sessionToken, refreshToken, err := h.srv.Refresh(c.Msg.RefreshToken)
	if err != nil {
		return nil, connect.NewError(connect.CodeUnauthenticated, err)
	}

	return connect.NewResponse(&v1.RefreshResponse{
		Session: &v1.Token{
			Value:  sessionToken.Value,
			Expiry: sessionToken.Expiry,
		},
		Refresh: &v1.Token{
			Value:  refreshToken.Value,
			Expiry: refreshToken.Expiry,
		},
	}), nil
}
