package asset

import (
	"gorm.io/gorm"
)

type StoreGorm struct {
	db *gorm.DB
}

func NewStore(db *gorm.DB) Store {
	return &StoreGorm{db: db}
}

func (s *StoreGorm) Create(contentId uint, assetType Type, assetRole Role, storagePath string) (Asset, error) {
	asset := Asset{
		ContentID:   contentId,
		Type:        assetType,
		Role:        assetRole,
		StoragePath: storagePath,
	}
	err := s.db.Create(&asset).Error
	return asset, err
}

func (s *StoreGorm) Save(ass *Asset) error {
	return s.db.Updates(ass).Error
}

func (s *StoreGorm) GetById(id uint) (*Asset, error) {
	dest := &Asset{}
	err := s.db.
		First(&dest, id).
		Error

	return dest, err
}

func (s *StoreGorm) Delete(assetId uint) error {
	err := s.db.Unscoped().Delete(&Asset{}, assetId).Error
	return err
}

func (s *StoreGorm) GetByContentAndRole(contentId int, role Role) (*Asset, error) {
	dest := Asset{}
	err := s.db.
		Where("role = ?", role).
		Where("content_id = ?", contentId).
		First(&dest).
		Error

	return &dest, err
}
