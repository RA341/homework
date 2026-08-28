package users

import (
	"context"
	"fmt"

	"github.com/rs/zerolog/log"
	"golang.org/x/crypto/bcrypt"
)

type Service struct {
	conf *Config
	Store
}

func NewService(store Store, conf *Config) (*Service, error) {
	s := &Service{
		Store: store,
		conf:  conf,
	}
	err := s.Init()

	return s, err
}

func (s *Service) Init() error {
	return s.ensureDefaultUser()
}

func (s *Service) ensureDefaultUser() error {
	count, err := s.Store.Count()
	if err != nil {
		return err
	}

	if count != 0 {
		//log.Debug().Int("users", count).Msg("skipping default user creation, users exist")
		return nil
	}

	err = s.Create(s.conf.DefaultUser, s.conf.DefaultPassword)
	if err != nil {
		return err
	}
	log.Info().Msg("created default user")

	return err
}

func (s *Service) Create(username, password string) error {
	hashedPass, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	us := User{
		Username:       username,
		HashedPassword: string(hashedPass),
	}

	err = s.Store.Create(&us)
	return err
}

func (s *Service) Update(us *User) error {
	if us.HashedPassword != "" {
		hashedPass, err := bcrypt.GenerateFromPassword([]byte(us.HashedPassword), bcrypt.DefaultCost)
		if err != nil {
			return err
		}
		us.HashedPassword = string(hashedPass)
	}

	err := s.Store.Edit(us)
	return err
}

func (s *Service) VerifyCredentials(user string, pass string) (uint, error) {
	u, err := s.GetByUsername(user)
	if err != nil {
		return 0, fmt.Errorf("invalid username: %w", err)
	}

	err = bcrypt.CompareHashAndPassword([]byte(u.HashedPassword), []byte(pass))
	if err != nil {
		return 0, fmt.Errorf("invalid password %w", err)
	}

	return u.ID, nil
}

type contextKey struct{}

var userKey = contextKey{}

// SetUserIdCtx returns a new context with the given user ID.
func SetUserIdCtx(ctx context.Context, userID uint64) context.Context {
	return context.WithValue(ctx, userKey, userID)
}

// GetUserIDCtx retrieves the user ID from the context.
func GetUserIDCtx(ctx context.Context) (uint64, bool) {
	userID, ok := ctx.Value(userKey).(uint64)
	return userID, ok
}
