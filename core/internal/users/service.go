package users

import (
	"fmt"

	"golang.org/x/crypto/bcrypt"
)

type Service struct {
	Store
}

func NewService(store Store) *Service {
	return &Service{
		Store: store,
	}
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
