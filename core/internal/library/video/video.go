package video

import (
	"github.com/ra341/homework/internal/media/content"
	"gorm.io/gorm"
)

type Video struct {
	gorm.Model

	ContentId uint
	Content   content.Content `gorm:"foreignKey:ContentId"`
}
