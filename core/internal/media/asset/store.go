package asset

type Store interface {
	Create(contentId uint, assetType Type, assetRole Role, StoragePath string) (Asset, error)
	Get(id int, role Role) (*Asset, error)
}
