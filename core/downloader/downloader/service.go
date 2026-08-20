package downloader

import (
	"crypto/sha1"
	"fmt"
	"os"
	"path/filepath"

	"github.com/ra341/homework/common/sm"
)

type Service struct {
	DownloadFolder string
	ytd            Provider

	downloadItems sm.Map[string, *Progress]
}

func NewDownloader(DownloadFolder string, ytd Provider) (*Service, error) {
	d := &Service{
		DownloadFolder: DownloadFolder,
		ytd:            ytd,
	}
	err := d.init()

	return d, err
}

func (d *Service) init() (err error) {
	downloadBaseFolder := "downloads"
	downloadBaseFolder, err = filepath.Abs(downloadBaseFolder)
	if err != nil {
		return err
	}
	err = os.MkdirAll(downloadBaseFolder, os.ModePerm)
	if err != nil {
		return err
	}

	d.DownloadFolder = downloadBaseFolder
	return nil
}

func (d *Service) Start(url string) (err error) {
	sum := sha1.Sum([]byte(url))
	downloadId := fmt.Sprintf("%x", sum)
	downloadFolder := filepath.Join(d.DownloadFolder, downloadId)

	err = os.MkdirAll(downloadFolder, os.ModePerm)
	if err != nil {
		return err
	}

	d.downloadItems.Store(downloadId, &Progress{
		Status: Queued,
	})

	d.ytd.Download(url, downloadFolder,
		func(p *Progress) {
			fmt.Println("Downloading...", p)
			d.downloadItems.LoadOrStore(downloadId, p)
		},
	)

	return nil
}
