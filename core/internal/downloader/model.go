package downloader

import (
	"gorm.io/gorm"
)

type DownloadState int

const (
	Queued DownloadState = iota
	Downloading
	Error
	Complete
)

type Download struct {
	gorm.Model

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
