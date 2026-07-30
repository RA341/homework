package downloader

type Store interface {
	LoadQueued(limit int) ([]Download, error)
	SetDownloadErr(id uint, err string) error
	AddDownload(download Download) error
}
