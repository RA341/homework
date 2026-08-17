package authentication

import (
	"context"
	"errors"
	"testing"
	"time"

	"connectrpc.com/connect"
	v1 "github.com/ra341/homework/generated/api/auth/v1"
	"github.com/ra341/homework/internal/auth/session"
	"github.com/ra341/homework/internal/users"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

func TestHandler(t *testing.T) {
	// Setup SQLite in-memory database
	db, err := gorm.Open(sqlite.Open("file::memory:?cache=shared"), &gorm.Config{})
	if err != nil {
		t.Fatalf("failed to open database: %v", err)
	}

	// AutoMigrate all models
	if err := db.AutoMigrate(&users.User{}, &session.Session{}); err != nil {
		t.Fatalf("failed to migrate database: %v", err)
	}

	// Setup users service
	usersStore := users.NewStore(db)
	usersService := users.NewService(usersStore)

	// Setup session service
	sessionStore := session.NewStore(db)
	sessionService := session.NewService(sessionStore, 24*time.Hour)

	// Setup authentication service and handler
	secret := "test-secret"
	srv := NewService(secret, sessionService, usersService)
	_, httpHandler := NewHandler(srv)
	if httpHandler == nil {
		t.Fatal("expected http.Handler to be non-nil")
	}

	handler := &Handler{srv: srv}

	// Pre-create a test user
	username := "alice"
	password := "alice-password"
	err = usersService.Create(username, password)
	if err != nil {
		t.Fatalf("failed to create test user: %v", err)
	}

	var rawRefresh string

	t.Run("Login success", func(t *testing.T) {
		req := connect.NewRequest(&v1.LoginRequest{
			Username: username,
			Password: password,
		})

		resp, err := handler.Login(context.Background(), req)
		if err != nil {
			t.Fatalf("Login failed: %v", err)
		}

		if resp.Msg.Session.Value == "" {
			t.Error("expected non-empty access token")
		}
		if resp.Msg.Session.Expiry <= 0 {
			t.Error("expected positive access token expiry timestamp")
		}

		if resp.Msg.Refresh.Value == "" {
			t.Error("expected non-empty refresh token")
		}
		if resp.Msg.Refresh.Expiry <= 0 {
			t.Error("expected positive refresh token expiry timestamp")
		}

		rawRefresh = resp.Msg.Refresh.Value
	})

	t.Run("Login failure", func(t *testing.T) {
		req := connect.NewRequest(&v1.LoginRequest{
			Username: username,
			Password: "wrong-password",
		})

		_, err := handler.Login(context.Background(), req)
		if err == nil {
			t.Error("expected error for wrong password, got nil")
		} else {
			var connectErr *connect.Error
			ok := errors.As(err, &connectErr)
			if !ok {
				t.Fatalf("expected connect.Error, got %T", err)
			}
			if connectErr.Code() != connect.CodeUnauthenticated {
				t.Errorf("expected CodeUnauthenticated, got %v", connectErr.Code())
			}
		}
	})

	t.Run("Refresh success", func(t *testing.T) {
		req := connect.NewRequest(&v1.RefreshRequest{
			RefreshToken: rawRefresh,
		})

		resp, err := handler.Refresh(context.Background(), req)
		if err != nil {
			t.Fatalf("Refresh failed: %v", err)
		}

		if resp.Msg.Session.Value == "" {
			t.Error("expected non-empty access token")
		}
		if resp.Msg.Session.Expiry <= 0 {
			t.Error("expected positive access token expiry timestamp")
		}

		if resp.Msg.Refresh.Value == "" {
			t.Error("expected non-empty refresh token")
		}
		if resp.Msg.Refresh.Expiry <= 0 {
			t.Error("expected positive refresh token expiry timestamp")
		}

		rawRefresh = resp.Msg.Refresh.Value
	})

	t.Run("Logout success", func(t *testing.T) {
		req := connect.NewRequest(&v1.LogoutRequest{
			RefreshToken: rawRefresh,
		})

		_, err := handler.Logout(context.Background(), req)
		if err != nil {
			t.Fatalf("Logout failed: %v", err)
		}

		// Try to refresh with the logged out token - should fail
		refreshReq := connect.NewRequest(&v1.RefreshRequest{
			RefreshToken: rawRefresh,
		})
		_, err = handler.Refresh(context.Background(), refreshReq)
		if err == nil {
			t.Error("expected error when refreshing with revoked token, got nil")
		}
	})
}
