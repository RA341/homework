package media

import (
	"github.com/ra341/homework/common/pagination"
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/media/content"
)

type Service struct {
	content *content.Service
	asset   *asset.Service
}

func NewService(
	contentService *content.Service,
	assetService *asset.Service,
) *Service {
	return &Service{
		content: contentService,
		asset:   assetService,
	}
}

func (s *Service) List(query string, after, before, limit uint) (pagination.Result[content.Content], error) {
	return s.content.List(query, after, before, limit)
}

func (s *Service) Create(
	title, desc string,
	contentType content.Type,
	assetType asset.Type,
	assetRole asset.Role,
	filepath string,
) error {
	cont, err := s.content.Create(title, desc, contentType)
	if err != nil {
		return err
	}

	_, err = s.asset.Db.Create(cont.ID, assetType, assetRole, filepath)
	return err
}
