package downloader

import "gorm.io/gorm"

type StoreGorm struct {
	db *gorm.DB
}

func NewStoreGorm(db *gorm.DB) Store {
	return StoreGorm{
		db: db,
	}
}

func (s StoreGorm) LoadQueued(limit int) ([]Download, error) {
	var downloads []Download
	err := s.db.
		Where("status = ?", Queued).
		Limit(limit).
		Find(&downloads).
		Error

	return downloads, err
}

func (s StoreGorm) SetDownloadErr(id uint, err string) error {
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

func (s StoreGorm) AddDownload(download Download) error {
	return s.db.Create(&download).Error
}
