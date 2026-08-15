package downloader

import (
	"github.com/ra341/homework/internal/media/asset"
	"gorm.io/gorm"
)

type DownloadState int

const (
	Queued DownloadState = iota
	Downloading
	// Error indicates failed download
	Error
	// Complete indicates a successful download
	Complete
	// Failed indicates if something with the server is wrong (not download issues)
	Failed
)

type Download struct {
	gorm.Model

	AssetID uint
	Asset   asset.Asset `gorm:"foreignKey:AssetID; not null"`

	Name         string
	DownloadLink string
	Status       DownloadState
	Progress     DownloadProgress `gorm:"embedded;embeddedPrefix:progress_"`
	DownloadPath string
}

type DownloadProgress struct {
	TimeLeftSecs           uint
	DownloadBytesPerSecond uint

	Complete uint
	Left     uint
	Error    string
}
