package downloader

type Store interface {
	ListQueued(limit int) ([]Download, error)
	AddDownload(download *Download) error
	List(query string, after string, before string, limit uint) ([]Download, error)
	Get(id uint) (Download, error)

	SetDownloadErr(id uint, err string) error
	SetStatus(id uint, state DownloadState) error
	setProgress(id uint, status *DownloadProgress) error
	EditLink(id int64, link string) error
}
