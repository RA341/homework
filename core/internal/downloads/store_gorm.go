package downloads

import (
	"fmt"

	"gorm.io/gorm"
)

type StoreGorm struct {
	db *gorm.DB
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
		Where("progress_status = ?", Queued).
		Limit(limit).
		Find(&downloads).
		Error

	return downloads, err
}

func (s *StoreGorm) Get(id uint) (Download, error) {
	return Download{}, fmt.Errorf("not implemented idiot")
}

func (s *StoreGorm) SetStatus(id uint, status DownloadState) error {
	return s.db.
		Model(&Download{}).
		Where("id = ?", id).
		Update("progress_status", status).
		Error
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
			Progress: Progress{
				Error: errStr,
			},
		}).
		Error
}

func (s *StoreGorm) Stats() (*DownloadStats, error) {
	stats := &DownloadStats{}

	err := s.db.Model(&Download{}).
		Select(`
        	COUNT(*) as count,
        	AVG(progress_time_left_secs) as avg_time_left,
        	AVG(progress_download_bytes_per_second) as avg_speed,
        	SUM(progress_download_bytes_per_second) as sum_speed,
        	SUM(progress_total) as total_bytes
    	`).
		Where("progress_status = ?", Downloading).
		Scan(stats).
		Error

	return stats, err
}

func (s *StoreGorm) AddDownload(download *Download) error {
	return s.db.Create(&download).Error
}

func (s *StoreGorm) SetProgress(id uint, status *Progress) error {
	return s.db.Model(&Download{}).
		Where("id = ?", id).
		Updates(map[string]any{
			"progress_status":                    status.Status,
			"progress_error":                     status.Error,
			"progress_time_left_secs":            status.TimeLeftSecs,
			"progress_download_bytes_per_second": status.DownloadBytesPerSecond,
			"progress_completed":                 status.Completed,
			"progress_total":                     status.Total,
		}).
		Error
}
