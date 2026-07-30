package downloader

import "gorm.io/gorm"

type DownloadState int

const (
	Queued DownloadState = iota
	Downloading
	Error
	Success
)

type Download struct {
	gorm.Model

	Name         string
	DownloadLink string

	Status DownloadState

	Error        string
	DownloadPath string
}
