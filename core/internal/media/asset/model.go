package asset

import (
	"time"

	"github.com/ra341/homework/internal/media/content"
	"gorm.io/gorm"
)

type Asset struct {
	gorm.Model

	ContentID uint             `gorm:"index:idx_asset"`
	Content   *content.Content `gorm:"foreignKey:ContentID"`
	Role      Role             `gorm:"index:idx_asset"`
	Type      Type

	StoragePath string
	fm          FileMetadata `gorm:"embedded;embeddedPrefix:metadata_"`
}

type FileMetadata struct {
	MimeType string
	Width    uint
	Height   uint
	Duration time.Duration
	Size     uint
}

//go:generate enumer -type=Type -json -text -output gen_enum_type.go
type Type int

const (
	Unknown Type = iota
	Video
	Image
	Subtitle
	Audio
)

//go:generate enumer -type=Role -json -text -output gen_enum_role.go
type Role int

const (
	Main Role = iota
	Thumbnail
	Backdrop
	Trailer
	Poster
)
