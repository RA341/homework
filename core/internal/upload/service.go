package upload

import (
	"io"
	"os"
	"path/filepath"

	"github.com/ra341/homework/common/fu"
	"github.com/ra341/homework/internal/media"
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/media/content"
)

type Service struct {
	media       *media.Service
	MediaFolder string
}

func NewService(folder string, media *media.Service) (*Service, error) {
	abs, err := filepath.Abs(folder)
	if err != nil {
		return nil, err
	}

	err = os.MkdirAll(abs, 0777)
	if err != nil {
		return nil, err
	}

	return &Service{
		MediaFolder: abs,
		media:       media,
	}, nil

}

func (s *Service) Upload(
	title, desc, filename string,
	contentType content.Type,
	assetType asset.Type,
	assetRole asset.Role,
	uploadFile io.Reader,
) (err error) {
	var uploadPath = filepath.Join(s.MediaFolder, filepath.Clean(filename))

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

	_, err = io.Copy(saveFile, uploadFile)
	if err != nil {
		return err
	}

	err = s.media.Create(
		title,
		desc,
		contentType,
		assetType,
		assetRole,
		uploadPath,
	)
	if err != nil {
		return err
	}

	return nil
}
