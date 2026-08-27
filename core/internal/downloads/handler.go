package downloads

import (
	"context"
	"fmt"
	"net/http"

	"connectrpc.com/connect"
	"github.com/ra341/homework/common/list"
	v1 "github.com/ra341/homework/generated/api/downloader/v1"
	"github.com/ra341/homework/generated/api/downloader/v1/v1connect"
)

////go:generate autospec -struct IHandler -service DownloaderService -package downloader.v1 -go_package github.com/ra341/homework/generated/api/downloader/v1 -out ../../../spec/protos/downloader/v1/downloader.proto
//type IHandler interface {
//	Download(name, downloadLink, filepath string)
//	List(base pagination.Base[string]) (pagination.Result[Download], error)
//}

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) (string, http.Handler) {
	h := &Handler{
		srv: srv,
	}
	return v1connect.NewDownloaderServiceHandler(h)
}

func (h *Handler) Stats(ctx context.Context, c *connect.Request[v1.StatsRequest]) (*connect.Response[v1.StatsResponse], error) {
	stats, err := h.srv.store.Stats()
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&v1.StatsResponse{
		Count:       stats.Count,
		AvgTimeLeft: stats.AvgTimeLeft,
		AvgSpeed:    stats.AvgSpeed,
		SumSpeed:    stats.SumSpeed,
		TotalBytes:  stats.TotalBytes,
	}), nil
}

func (h *Handler) Cancel(ctx context.Context, c *connect.Request[v1.CancelRequest]) (*connect.Response[v1.CancelResponse], error) {
	err := h.srv.Cancel(uint(c.Msg.Id))
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&v1.CancelResponse{}), err
}

func (h *Handler) Edit(ctx context.Context, c *connect.Request[v1.EditRequest]) (*connect.Response[v1.EditResponse], error) {
	err := h.srv.Edit(c.Msg.DownloadId, c.Msg.DownloadLink)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&v1.EditResponse{}), nil
}

func (h *Handler) Download(ctx context.Context, c *connect.Request[v1.DownloadRequest]) (*connect.Response[v1.DownloadResponse], error) {
	return nil, connect.NewError(connect.CodeUnimplemented, fmt.Errorf("downloader.v1.DownloaderService.Download is not implemented"))
}

func (h *Handler) Retry(ctx context.Context, c *connect.Request[v1.RetryRequest]) (*connect.Response[v1.RetryResponse], error) {
	err := h.srv.Retry(uint(c.Msg.Id))
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&v1.RetryResponse{}), nil
}

func (h *Handler) List(ctx context.Context, c *connect.Request[v1.ListRequest]) (*connect.Response[v1.ListResponse], error) {
	re, err := h.srv.store.List(c.Msg.Query, c.Msg.After, c.Msg.Before, uint(c.Msg.Limit))
	if err != nil {
		return nil, err
	}

	resp := v1.ListResponse{
		Result: &v1.DownloadResult{
			Results: list.Map(re, toDownload),
			Count:   uint32(len(re)),
		},
	}

	return connect.NewResponse(&resp), nil
}

func toDownload(t Download) *v1.Download {
	progress := &v1.DownloadProgress{
		TimeLeftSecs:           uint64(t.Progress.TimeLeftSecs),
		DownloadBytesPerSecond: uint64(t.Progress.DownloadBytesPerSecond),
		Complete:               uint64(t.Progress.Completed),
		Total:                  uint64(t.Progress.Total),
		Error:                  t.Progress.Error,
	}

	return &v1.Download{
		Id:           uint64(t.ID),
		CreatedAtSec: uint64(t.CreatedAt.Unix()),
		UpdatedAtSec: uint64(t.UpdatedAt.Unix()),
		Name:         t.Name,
		DownloadLink: t.DownloadLink,
		Status:       v1.DownloadState(t.Progress.Status),
		Progress:     progress,
		DownloadPath: t.DownloadPath,
	}
}
