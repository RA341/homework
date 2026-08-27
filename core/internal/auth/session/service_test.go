package session

import (
	"errors"
	"testing"
	"time"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

func TestSessionService(t *testing.T) {
	// Setup SQLite in-memory database
	db, err := gorm.Open(sqlite.Open("file::memory:?cache=shared"), &gorm.Config{})
	if err != nil {
		t.Fatalf("failed to open database: %v", err)
	}

	// AutoMigrate Session model
	if err := db.AutoMigrate(&Session{}); err != nil {
		t.Fatalf("failed to migrate database: %v", err)
	}

	store := NewStore(db)
	conf := &Config{
		SessionExpiry: 1 * time.Hour,
	}
	service := NewService(store, conf)

	userID := uint64(12345)

	t.Run("Create and CheckRefresh", func(t *testing.T) {
		session, rawToken, err := service.Create(userID, 0)
		if err != nil {
			t.Fatalf("failed to create session: %v", err)
		}

		if rawToken == "" {
			t.Error("expected non-empty raw token")
		}

		if session.UserID != userID {
			t.Errorf("expected UserID %d, got %d", userID, session.UserID)
		}

		// Retrieve and check session
		checkedSession, err := service.CheckRefresh(rawToken)
		if err != nil {
			t.Fatalf("failed to check refresh: %v", err)
		}

		if checkedSession.ID != session.ID {
			t.Errorf("expected session ID %d, got %d", session.ID, checkedSession.ID)
		}
	})

	t.Run("CheckRefresh Expired", func(t *testing.T) {
		// Create session with negative expiry (already expired)
		_, rawToken, err := service.Create(userID, -1*time.Second)
		if err != nil {
			t.Fatalf("failed to create expired session: %v", err)
		}

		_, err = service.CheckRefresh(rawToken)
		if !errors.Is(err, ErrSessionExpired) {
			t.Errorf("expected ErrSessionExpired, got %v", err)
		}
	})

	t.Run("Refresh Session", func(t *testing.T) {
		session, rawToken, err := service.Create(userID, 1*time.Hour)
		if err != nil {
			t.Fatalf("failed to create session: %v", err)
		}

		// Refresh it
		_, newRawToken, err := service.Refresh(rawToken, 2*time.Hour)
		if err != nil {
			t.Fatalf("failed to refresh session: %v", err)
		}

		if newRawToken == rawToken {
			t.Error("expected a new refresh token")
		}

		// Check new session
		checkedSession, err := service.CheckRefresh(newRawToken)
		if err != nil {
			t.Fatalf("failed to check new refresh token: %v", err)
		}

		if checkedSession.ID != session.ID {
			t.Errorf("expected same session ID %d, got %d", session.ID, checkedSession.ID)
		}

		// The old token should now be invalid because it was replaced/updated
		_, err = service.CheckRefresh(rawToken)
		if err == nil {
			t.Error("expected check on old token to fail")
		}
	})

	t.Run("Delete Session", func(t *testing.T) {
		session, rawToken, err := service.Create(userID, 1*time.Hour)
		if err != nil {
			t.Fatalf("failed to create session: %v", err)
		}

		err = service.Delete(session.ID)
		if err != nil {
			t.Fatalf("failed to delete session: %v", err)
		}

		_, err = service.CheckRefresh(rawToken)
		if err == nil {
			t.Error("expected check on deleted session to fail")
		}
	})
}
