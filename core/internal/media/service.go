package media

import (
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/media/content"
)

type Downloader interface {
	Add(Name string, DownloadLink string, DownloadPath string) error
}

type Service struct {
	content    *content.Service
	asset      *asset.Service
	downloader Downloader
}

func NewService(
	contentService *content.Service,
	assetService *asset.Service,
	downloader Downloader,
) *Service {
	return &Service{
		content:    contentService,
		asset:      assetService,
		downloader: downloader,
	}
}

func (s *Service) CreateAndDownload(
	content CreateDownloadMedia,
) error {
	err := s.Create(&content.media)
	if err != nil {
		return err
	}

	return s.downloader.Add(
		content.media.Content.Title,
		content.downloadLink,
		content.media.Asset.Filepath,
	)
}

func (s *Service) Create(con *CreateMedia) error {
	cont, err := s.content.Create(con.Content.Title, con.Content.Desc, con.Content.ContentType)
	if err != nil {
		return err
	}

	_, err = s.asset.Db.Create(cont.ID, con.Asset.AssetType, con.Asset.AssetRole, con.Asset.Filepath)
	return err
}
