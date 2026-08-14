package media

import (
	"context"
	"net/http"

	"connectrpc.com/connect"
	v1 "github.com/ra341/homework/generated/api/media/v1"
	"github.com/ra341/homework/generated/api/media/v1/v1connect"
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/media/content"
)

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) (string, http.Handler) {
	h := &Handler{
		srv: srv,
	}

	return v1connect.NewMediaServiceHandler(h)
}

func (h *Handler) AddAndDownload(ctx context.Context, c *connect.Request[v1.AddAndDownloadRequest]) (*connect.Response[v1.AddAndDownloadResponse], error) {
	con := CreateDownloadMedia{
		media: CreateMedia{
			Content: content.CreateContent{
				Title:       c.Msg.Media.Content.Title,
				Desc:        c.Msg.Media.Content.Desc,
				ContentType: content.Type(c.Msg.Media.Content.ContentType),
			},
			Asset: asset.CreateAsset{
				AssetType: asset.Type(c.Msg.Media.Asset.AssetType),
				AssetRole: asset.Role(c.Msg.Media.Asset.AssetRole),
				Filepath:  c.Msg.Media.Asset.Filepath,
			},
		},
		downloadLink: c.Msg.DownloadLink,
	}

	err := h.srv.CreateAndDownload(&con)
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&v1.AddAndDownloadResponse{}), nil
}
