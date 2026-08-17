package asset

type Store interface {
	Create(contentId uint, assetType Type, assetRole Role, StoragePath string) (Asset, error)
	GetById(id uint) (*Asset, error)
	GetByContentAndRole(id int, role Role) (*Asset, error)
	Save(ass *Asset) error
	Delete(assetId uint) error
}
