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
	// todo fix list
	err := s.db.Limit(int(limit)).
		Order("created_at DESC").
		Find(&downloads).
		Error

	return downloads, err
}

func (s *StoreGorm) ListQueued(limit int) ([]Download, error) {
	var downloads []Download
	err := s.db.
		Where("status = ?", Queued).
		Limit(limit).
		Find(&downloads).
		Error

	return downloads, err
}

func (s *StoreGorm) EditLink(id int64, link string) error {
	err := s.db.
		Model(&Download{}).
		Where("id = ?", id).
		UpdateColumn("download_link", link).
		Error
	return err
}

func (s *StoreGorm) SetDownloadErr(id uint, errStr string) error {
	return s.db.
		Model(&Download{}).
		Where("id = ?", id).
		Updates(Download{
			Progress: DownloadProgress{
				Error:  errStr,
				Status: Error,
			},
		}).
		Error
}

func (s *StoreGorm) AddDownload(download *Download) error {
	return s.db.Create(&download).Error
}

func (s *StoreGorm) SetProgress(id uint, status *DownloadProgress) error {
	return s.db.Model(&Download{}).
		Where("id = ?", id).
		Updates(
			Download{Progress: *status},
		).
		Error
}
