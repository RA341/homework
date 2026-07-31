package downloader

import (
	"fmt"

	"gorm.io/gorm"
)

type StoreGorm struct {
	db *gorm.DB
}

func (s *StoreGorm) Get(id uint) (Download, error) {
	return Download{}, fmt.Errorf("not implemented idiot")
}

func (s *StoreGorm) SetStatus(id uint, status DownloadState) error {
	return s.db.
		Model(&Download{}).
		Where("id = ?", id).
		Update("status", status).
		Error
}

func NewStoreGorm(db *gorm.DB) Store {
	return &StoreGorm{
		db: db,
	}
}

func (s *StoreGorm) List(query string, after string, before string, limit uint) ([]Download, error) {
	var downloads []Download

	err := s.db.Limit(int(limit)).
		Find(&downloads).
		Error

	return downloads, err
}

func (s *StoreGorm) LoadQueued(limit int) ([]Download, error) {
	var downloads []Download
	err := s.db.
		Where("status = ?", Queued).
		Limit(limit).
		Find(&downloads).
		Error

	return downloads, err
}

func (s *StoreGorm) SetDownloadErr(id uint, err string) error {
	err2 := s.db.
		Model(&Download{}).
		Where("id = ?", id).
		Updates(map[string]any{
			"status": Error,
			"error":  err,
		}).
		Error

	return err2
}

func (s *StoreGorm) AddDownload(download Download) error {
	return s.db.Create(&download).Error
}

func (s *StoreGorm) setProgress(status *DownloadProgress) error {
	return s.db.Model(&Download{}).Updates(
		Download{Progress: *status},
	).Error
}
