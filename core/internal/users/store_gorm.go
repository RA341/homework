package users

import (
	"gorm.io/gorm"
)

type StoreGorm struct {
	db *gorm.DB
}

func NewStore(db *gorm.DB) Store {
	return &StoreGorm{db: db}
}

func (s *StoreGorm) List() ([]User, error) {
	var list []User
	err := s.db.Find(&list).Error
	return list, err
}

func (s *StoreGorm) GetById(id uint) (*User, error) {
	user := &User{}
	err := s.db.Find(user, id).Error

	return user, err
}

func (s *StoreGorm) Count() (int, error) {
	var c int64
	err := s.db.Model(&User{}).Count(&c).Error
	return int(c), err
}

func (s *StoreGorm) Create(user *User) error {
	return s.db.Create(user).Error
}

func (s *StoreGorm) Delete(id uint) error {
	return s.db.Delete(&User{}, id).Error
}

func (s *StoreGorm) Edit(user *User) error {
	return s.db.Save(user).Error
}

func (s *StoreGorm) GetByUsername(username string) (*User, error) {
	dest := &User{}
	err := s.db.Where("username = ?", username).First(dest).Error
	if err != nil {
		return nil, err
	}
	return dest, nil
}
