package media

import (
	"io"

	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/media/content"
)

type CreateDownloadMedia struct {
	media        CreateMedia
	downloadLink string
}

type CreateUploadMedia struct {
	media  CreateMedia
	upload io.Reader
}

type CreateMedia struct {
	Content content.CreateContent
	Asset   asset.CreateAsset
}
