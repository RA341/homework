package authentication

import (
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/ra341/homework/internal/auth/session"
	"github.com/ra341/homework/internal/users"
	"github.com/rs/zerolog/log"
)

type Service struct {
	session *session.Service
	user    *users.Service
	conf    *Config
}

func NewService(conf *Config, session *session.Service, user *users.Service) *Service {
	s := &Service{
		session: session,
		user:    user,
		conf:    conf,
	}

	return s
}

func (s *Service) Login(username, pass string) (Token, Token, error) {
	userId, err := s.user.VerifyCredentials(username, pass)
	if err != nil {
		log.Error().Err(err).Msg("Failed to verify credentials")
		return Token{}, Token{}, fmt.Errorf("invalid username/password")
	}

	sess, rawRefresh, err := s.session.Create(uint64(userId), 0)
	if err != nil {
		return Token{}, Token{}, err
	}

	jwtToken, err := s.generateJWT(uint64(userId))
	if err != nil {
		return Token{}, Token{}, err
	}

	return jwtToken, Token{
		Value:  rawRefresh,
		Expiry: sess.RefreshExpiry.Unix(),
	}, nil
}

func (s *Service) Logout(rawRefreshToken string) error {
	return s.session.DeleteByToken(rawRefreshToken)
}

func (s *Service) Refresh(rawRefreshToken string) (Token, Token, error) {
	sess, newRawRefresh, err := s.session.Refresh(rawRefreshToken, 0)
	if err != nil {
		return Token{}, Token{}, err
	}

	jwtToken, err := s.generateJWT(sess.UserID)
	if err != nil {
		return Token{}, Token{}, err
	}

	return jwtToken, Token{
		Value:  newRawRefresh,
		Expiry: sess.RefreshExpiry.Unix(),
	}, nil
}

type UserClaims struct {
	UserID uint64 `json:"user_id"`
	jwt.RegisteredClaims
}

func (s *Service) generateJWT(userID uint64) (Token, error) {
	now := time.Now()
	exp := now.Add(s.conf.JwtExpiry)
	expUnix := exp.Unix()

	claims := UserClaims{
		UserID:    userID,
		ExpiresAt: jwt.NewNumericDate(exp),
		IssuedAt:  jwt.NewNumericDate(now),
		Issuer:    s.conf.JwtIssuer,
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(s.conf.GetJwtSecret())
	if err != nil {
		return Token{}, err
	}
	return Token{Value: tokenString, Expiry: expUnix}, nil
}

func (s *Service) verifyRefresh(sessionToken string) (uint, error) {
	token, err := s.verifyJwt(sessionToken)
	if err != nil {
		return 0, err
	}

	u, err := s.readClaim(token)
	if err != nil {
		return 0, err
	}

	// Return the parsed user ID on success
	return u, nil
}

func (s *Service) verifyJwt(sessionToken string) (*jwt.Token, error) {
	// Use ParseWithClaims and pass an empty &UserClaims{} instance
	token, err := jwt.ParseWithClaims(sessionToken, &UserClaims{}, func(tok *jwt.Token) (any, error) {
		if _, ok := tok.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", tok.Header["alg"])
		}
		return s.conf.GetJwtSecret(), nil
	})

	return token, err
}

func (s *Service) readClaim(token *jwt.Token) (uint, error) {
	claims, ok := token.Claims.(*UserClaims)
	if !ok || !token.Valid {
		return 0, fmt.Errorf("invalid token claims")
	}

	return uint(claims.UserID), nil
}
