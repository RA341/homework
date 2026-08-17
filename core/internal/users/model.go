package users

import "gorm.io/gorm"

type User struct {
	gorm.Model

	Username       string
	HashedPassword string
}
