package session

import (
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"time"
)

var (
	ErrSessionExpired = errors.New("session expired")
)

type Service struct {
	store         Store
	defaultExpiry time.Duration
}

func NewService(store Store, defaultExpiry time.Duration) *Service {
	if defaultExpiry <= 0 {
		defaultExpiry = 24 * time.Hour
	}
	return &Service{
		store:         store,
		defaultExpiry: defaultExpiry,
	}
}

// Create generates a secure random refresh token, hashes it,
// and saves a new session with the given expiry (falls back to defaultExpiry if 0 or negative).
// Returns the session and the raw refresh token string.
func (s *Service) Create(userID uint64, expiry time.Duration) (sess *Session, rawRefresh string, err error) {
	exp := expiry
	if exp == 0 {
		exp = s.defaultExpiry
	}

	rawToken, hashedToken, err := s.generateToken()
	if err != nil {
		return nil, "", err
	}

	session := &Session{
		UserID:        userID,
		RefreshHashed: hashedToken,
		RefreshExpiry: time.Now().Add(exp),
	}

	if err := s.store.Create(session); err != nil {
		return nil, "", err
	}

	return session, rawToken, nil
}

// Delete deletes the session by its ID.
func (s *Service) Delete(id uint) error {
	return s.store.Delete(id)
}

// CheckRefresh hashes the raw refresh token, retrieves the session,
// and checks if it's expired.
func (s *Service) CheckRefresh(rawRefreshToken string) (*Session, error) {
	hashed := s.hashToken(rawRefreshToken)
	session, err := s.store.GetByRefreshHashed(hashed)
	if err != nil {
		return nil, err
	}

	if time.Now().After(session.RefreshExpiry) {
		return nil, ErrSessionExpired
	}

	return session, nil
}

// Refresh checks the validity of the current raw refresh token,
// generates a new raw refresh token, hashes it, updates the session,
// and returns the updated session and new raw refresh token.
func (s *Service) Refresh(rawRefreshToken string, newExpiry time.Duration) (sess *Session, rawRefresh string, err error) {
	session, err := s.CheckRefresh(rawRefreshToken)
	if err != nil {
		return nil, "", err
	}

	exp := newExpiry
	if exp == 0 {
		exp = s.defaultExpiry
	}

	newRawToken, newHashedToken, err := s.generateToken()
	if err != nil {
		return nil, "", err
	}

	session.RefreshHashed = newHashedToken
	session.RefreshExpiry = time.Now().Add(exp)

	if err := s.store.Update(session); err != nil {
		return nil, "", err
	}

	return session, newRawToken, nil
}

func (s *Service) generateToken() (string, string, error) {
	bytes := make([]byte, 32)
	if _, err := rand.Read(bytes); err != nil {
		return "", "", err
	}
	raw := hex.EncodeToString(bytes)
	hash := s.hashToken(raw)
	return raw, hash, nil
}

func (s *Service) hashToken(token string) string {
	hash := sha256.Sum256([]byte(token))
	return hex.EncodeToString(hash[:])
}
