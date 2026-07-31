package downloader

type Store interface {
	LoadQueued(limit int) ([]Download, error)
	SetDownloadErr(id uint, err string) error
	AddDownload(download Download) error
	List(query string, after string, before string, limit uint) ([]Download, error)
	Get(id uint) (Download, error)
	SetStatus(id uint, state DownloadState) error
	setProgress(status *DownloadProgress) error
}
