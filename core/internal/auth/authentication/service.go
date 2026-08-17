package authentication

import (
	"crypto/rand"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/ra341/homework/internal/auth/session"
	"github.com/ra341/homework/internal/users"
	"github.com/rs/zerolog/log"
)

type Service struct {
	session   *session.Service
	user      *users.Service
	jwtSecret []byte
}

func NewService(jwtSecret string, session *session.Service, user *users.Service) *Service {
	s := &Service{
		session:   session,
		user:      user,
		jwtSecret: []byte(jwtSecret),
	}
	s.Init()

	return s
}

func (s *Service) Init() {
	if len(s.jwtSecret) == 0 {
		log.Warn().Msg("please set the JWT secret. A random secret has been assigned, and sessions will be invalidated on server restart if not set")

		secret := make([]byte, 32)
		_, err := rand.Read(secret)

		if err != nil {
			s.jwtSecret = []byte("fallback-jwt-secret-key-change-me")
		} else {
			s.jwtSecret = secret
		}
	}
}

func (s *Service) Login(username, pass string) (*session.Session, string, string, error) {
	userId, err := s.user.VerifyCredentials(username, pass)
	if err != nil {
		log.Error().Err(err).Msg("Failed to verify credentials")
		return nil, "", "", fmt.Errorf("invalid username/password")
	}

	sess, rawRefresh, err := s.session.Create(uint64(userId), 0)
	if err != nil {
		return nil, "", "", err
	}

	jwtToken, err := s.generateJWT(uint64(userId), username)
	if err != nil {
		return nil, "", "", err
	}

	return sess, jwtToken, rawRefresh, nil
}

func (s *Service) Logout(sessionID uint) error {
	return s.session.Delete(sessionID)
}

func (s *Service) Refresh(rawRefreshToken string) (*session.Session, string, string, error) {
	sess, newRawRefresh, err := s.session.Refresh(rawRefreshToken, 0)
	if err != nil {
		return nil, "", "", err
	}

	jwtToken, err := s.generateJWT(sess.UserID, sess.User.Username)
	if err != nil {
		return nil, "", "", err
	}

	return sess, jwtToken, newRawRefresh, nil
}

func (s *Service) generateJWT(userID uint64, username string) (string, error) {
	claims := jwt.MapClaims{
		"user_id":  userID,
		"username": username,
		"exp":      time.Now().Add(15 * time.Minute).Unix(),
		"iat":      time.Now().Unix(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(s.jwtSecret)
}
