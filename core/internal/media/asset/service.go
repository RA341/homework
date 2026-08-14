package asset

import (
	"fmt"
	"path/filepath"
	"strconv"
)

type Service struct {
	Db Store
}

func NewService(store Store) *Service {
	return &Service{Db: store}
}

func (s *Service) Get(contentIdStr string, assetRoleStr string) (*Asset, error) {
	contentId, err := strconv.ParseInt(contentIdStr, 10, 64)
	if err != nil {
		return nil, fmt.Errorf("invalid contentId " + err.Error())
	}

	assetRole, err := RoleString(assetRoleStr)
	if err != nil {
		return nil, fmt.Errorf("invalid assetRole" + err.Error())
	}

	return s.Db.Get(int(contentId), assetRole)
}

func (s *Service) Create(id uint, c *CreateAsset) (Asset, error) {
	abs, err := filepath.Abs(c.Filepath)
	if err != nil {
		return Asset{}, err
	}

	c.Filepath = abs
	return s.Db.Create(id, c.AssetType, c.AssetRole, c.Filepath)
}
