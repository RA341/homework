package downloader

import "context"

type Provider interface {
	Download(item *DownloadItem, setProgress func(p *Progress))
}

type DownloadItem struct {
	Ctx            context.Context
	Url            string
	DownloadFolder string
	WorkerDone     chan struct{}

	progress *Progress
	cancel   context.CancelFunc
}

func (d *DownloadItem) WaitForWorker() {
	<-d.WorkerDone
}

type DownloadStatus int

const (
	Queued = iota
	Downloading
	Error
	Complete
)

type Progress struct {
	Status DownloadStatus

	TimeInSecs         int64
	DownloadBytesSpeed float64

	Downloaded int64
	Total      int64

	Error string
}
