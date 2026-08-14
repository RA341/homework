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
	Add(Name string, DownloadLink string, DownloadPath string) error
}

type Service struct {
	MediaFolder string

	content    *content.Service
	asset      *asset.Service
	downloader Downloader
}

func NewService(
	contentService *content.Service,
	assetService *asset.Service,
	downloader Downloader,
	MediaFolder string,
) (*Service, error) {
	s := &Service{
		content:     contentService,
		asset:       assetService,
		downloader:  downloader,
		MediaFolder: MediaFolder,
	}

	err := s.Init()

	return s, err
}

func (s *Service) Init() error {
	abs, err := filepath.Abs(s.MediaFolder)
	if err != nil {
		return err
	}

	err = os.MkdirAll(abs, 0777)
	return err
}

func (s *Service) CreateAndUpload(uploadMedia *CreateUploadMedia) (err error) {
	var uploadPath = filepath.Join(s.MediaFolder, filepath.Clean(uploadMedia.media.Asset.Filepath))

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
	return s.Create(&uploadMedia.media)
}

func (s *Service) CreateAndDownload(content *CreateDownloadMedia) error {
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

	_, err = s.asset.Create(cont.ID, &con.Asset)
	return err
}
