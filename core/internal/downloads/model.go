package downloads

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
	// Canceled by user
	Canceled
)

type Download struct {
	gorm.Model

	AssetID uint
	Asset   asset.Asset `gorm:"foreignKey:AssetID;constraint:OnDelete:CASCADE;not null"`

	Name         string
	DownloadLink string
	Progress     Progress `gorm:"embedded;embeddedPrefix:progress_"`
	DownloadPath string
}

type Progress struct {
	Status DownloadState
	Error  string

	TimeLeftSecs           uint
	DownloadBytesPerSecond uint

	Completed uint
	Total     uint
}

type DownloadStats struct {
	Count       int64
	AvgTimeLeft float64
	AvgSpeed    float64
	SumSpeed    float64
	TotalBytes  uint64
}
