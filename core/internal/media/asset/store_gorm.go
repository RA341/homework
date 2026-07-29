package asset

import "gorm.io/gorm"

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

func (s *StoreGorm) Get(id int, role Role) (*Asset, error) {
	dest := Asset{}
	err := s.db.
		Where("role = ?", role).
		First(&dest, id).
		Error

	return &dest, err
}
