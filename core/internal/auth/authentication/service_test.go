package authentication

import (
	"testing"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/ra341/homework/internal/auth/session"
	"github.com/ra341/homework/internal/users"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

func TestAuthenticationService(t *testing.T) {
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

	// Setup authentication service
	secretStr := "test-jwt-secret-key-12345"
	secret := []byte(secretStr)
	authService := NewService(secretStr, sessionService, usersService)

	// Pre-create a test user
	username := "bob"
	password := "secure-password"
	err = usersService.Create(username, password)
	if err != nil {
		t.Fatalf("failed to create test user: %v", err)
	}

	t.Run("Login success", func(t *testing.T) {
		sess, jwtToken, rawRefresh, err := authService.Login(username, password)
		if err != nil {
			t.Fatalf("login failed: %v", err)
		}

		if sess == nil {
			t.Fatal("expected session to be non-nil")
		}

		if jwtToken == "" {
			t.Error("expected non-empty JWT token")
		}

		if rawRefresh == "" {
			t.Error("expected non-empty raw refresh token")
		}

		// Verify JWT token claims
		token, err := jwt.Parse(jwtToken, func(tok *jwt.Token) (interface{}, error) {
			return secret, nil
		})
		if err != nil {
			t.Fatalf("failed to parse JWT token: %v", err)
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok || !token.Valid {
			t.Fatal("invalid token claims")
		}

		if claims["username"] != username {
			t.Errorf("expected username %s in JWT claims, got %s", username, claims["username"])
		}
	})

	t.Run("Login invalid credentials", func(t *testing.T) {
		_, _, _, err := authService.Login(username, "wrong-password")
		if err == nil {
			t.Error("expected error for invalid password, got nil")
		}
	})

	t.Run("Refresh success", func(t *testing.T) {
		_, _, rawRefresh, err := authService.Login(username, password)
		if err != nil {
			t.Fatalf("login failed: %v", err)
		}

		// Refresh token
		sess, newJWT, newRawRefresh, err := authService.Refresh(rawRefresh)
		if err != nil {
			t.Fatalf("refresh failed: %v", err)
		}

		if sess == nil {
			t.Fatal("expected session to be non-nil")
		}

		if newJWT == "" {
			t.Error("expected non-empty new JWT token")
		}

		if newRawRefresh == "" {
			t.Error("expected non-empty new raw refresh token")
		}

		// Verify new JWT token claims
		token, err := jwt.Parse(newJWT, func(tok *jwt.Token) (interface{}, error) {
			return secret, nil
		})
		if err != nil {
			t.Fatalf("failed to parse new JWT token: %v", err)
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok || !token.Valid {
			t.Fatal("invalid new token claims")
		}

		if claims["username"] != username {
			t.Errorf("expected username %s in JWT claims, got %s", username, claims["username"])
		}
	})

	t.Run("Logout", func(t *testing.T) {
		sess, _, rawRefresh, err := authService.Login(username, password)
		if err != nil {
			t.Fatalf("login failed: %v", err)
		}

		err = authService.Logout(sess.ID)
		if err != nil {
			t.Fatalf("logout failed: %v", err)
		}

		// Trying to refresh should fail now
		_, _, _, err = authService.Refresh(rawRefresh)
		if err == nil {
			t.Error("expected error refreshing after logout, got nil")
		}
	})
}
