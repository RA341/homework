package session

import (
	"time"

	"github.com/ra341/homework/internal/users"
	"gorm.io/gorm"
)

type Session struct {
	gorm.Model

	UserID uint64
	User   users.User

	RefreshHashed string
	RefreshExpiry time.Time
}
