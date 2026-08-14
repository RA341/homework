package media

import (
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/media/content"
)

type CreateDownloadMedia struct {
	media        CreateMedia
	downloadLink string
}

type CreateMedia struct {
	Content CreateContent
	Asset   CreateAsset
}

type CreateContent struct {
	Title       string
	Desc        string
	ContentType content.Type
}

type CreateAsset struct {
	AssetType asset.Type
	AssetRole asset.Role
	Filepath  string
}
