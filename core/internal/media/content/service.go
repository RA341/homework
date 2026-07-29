package content

import "github.com/ra341/homework/common/pagination"

type Service struct {
	Db Store
}

func NewService(store Store) *Service {
	return &Service{Db: store}
}

func (s *Service) List(query string, after uint, before uint, limit uint) (pagination.Pagintion[Content], error) {
	return s.Db.List(query, after, before, limit)
}

func (s *Service) Create(title, desc string, contentType Type) (Content, error) {
	return s.Db.Create(title, desc, contentType)
}
