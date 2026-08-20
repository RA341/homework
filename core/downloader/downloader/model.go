package downloader

type Provider interface {
	Download(url string, outputFolder string, setProgress func(p *Progress))
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
