package content

import (
	"gorm.io/gorm"
)

//go:generate enumer -type=Type -json -text -output gen_enum_type.go
type Type int

const (
	Unknown Type = iota
	Movie
	Series
	Episode
	Video
	Image
	Gallery
	Season
)

type Content struct {
	gorm.Model

	Type        Type
	Title       string
	Description string
	//Status           string
}
