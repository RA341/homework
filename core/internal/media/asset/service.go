package asset

import (
	"fmt"
	"strconv"
)

type Service struct {
	Db Store
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

func NewService(store Store) *Service {
	return &Service{Db: store}
}

//func (s *Service) Create(assetType Type, StoragePath string) (Asset, error) {
//	return s.Db.CreateAsset(assetType, StoragePath)
//}
