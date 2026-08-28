package media

import (
	"io"
	"os"
	"path/filepath"

	"github.com/ra341/homework/common/fu"
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/media/content"
)

type Downloader interface {
	Add(AssetId uint, Name string, DownloadLink string) error
}

type Service struct {
	conf *Config

	content    *content.Service
	asset      *asset.Service
	downloader Downloader
}

func NewService(
	conf *Config,
	contentService *content.Service,
	assetService *asset.Service,
	downloader Downloader,
) (*Service, error) {
	s := &Service{
		content:    contentService,
		asset:      assetService,
		downloader: downloader,
		conf:       conf,
	}

	err := s.Init()

	return s, err
}

func (s *Service) Init() error {
	abs, err := filepath.Abs(s.conf.UploadDir)
	if err != nil {
		return err
	}

	err = os.MkdirAll(abs, 0777)
	return err
}

func (s *Service) CreateAndUpload(uploadMedia *CreateUploadMedia) (err error) {
	var uploadPath = filepath.Join(s.conf.UploadDir, filepath.Clean(uploadMedia.media.Asset.Filepath))

	saveFile, err := os.OpenFile(uploadPath, os.O_CREATE|os.O_WRONLY, 0666)
	if err != nil {
		return err
	}
	defer fu.CloseCloser(saveFile)
	defer func() {
		if err != nil {
			_ = os.RemoveAll(uploadPath)
		}
	}()

	_, err = io.Copy(saveFile, uploadMedia.upload)
	if err != nil {
		return err
	}

	uploadMedia.media.Asset.Filepath = uploadPath
	_, err = s.Create(&uploadMedia.media)
	return err
}

func (s *Service) CreateAndDownload(content *CreateDownloadMedia) error {
	assetId, err := s.Create(&content.media)
	if err != nil {
		return err
	}

	return s.downloader.Add(
		assetId,
		content.media.Content.Title,
		content.downloadLink,
	)
}

func (s *Service) Create(con *CreateMedia) (uint, error) {
	cont, err := s.content.Create(con.Content.Title, con.Content.Desc, con.Content.ContentType)
	if err != nil {
		return 0, err
	}

	ass, err := s.asset.Create(cont.ID, &con.Asset)
	if err != nil {
		return 0, err
	}
	return ass.ID, nil
}
