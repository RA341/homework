package manager

import (
	"context"
	"crypto/sha1"
	"fmt"
	"os"
	"path/filepath"

	"github.com/ra341/homework/common/sm"
	"github.com/ra341/homework/internal/downloads"
	"github.com/rs/zerolog/log"
)

type Service struct {
	DownloadFolder string
	ytd            Provider

	downloadItems sm.Map[string, *DownloadItem]
}

func NewService(DownloadFolder string, ytd Provider) (*Service, error) {
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

func (d *Service) Download(url string) (id string, err error) {
	sum := sha1.Sum([]byte(url))
	downloadId := fmt.Sprintf("%x", sum)
	downloadFolder := filepath.Join(d.DownloadFolder, downloadId)

	err = os.MkdirAll(downloadFolder, os.ModePerm)
	if err != nil {
		return id, err
	}

	ctx, cancelFn := context.WithCancel(context.Background())
	item := &DownloadItem{
		Ctx:            ctx,
		cancel:         cancelFn,
		Url:            url,
		DownloadFolder: downloadFolder,
		WorkerDone:     make(chan struct{}, 1),
	}

	d.downloadItems.Store(downloadId, item)

	go d.worker(downloadId, item)

	return downloadId, nil
}

func (d *Service) Cancel(downloadId string) error {
	val, ok := d.downloadItems.Load(downloadId)
	if !ok {
		return fmt.Errorf("download not found")
	}

	val.cancel()
	val.WaitForWorker()
	d.downloadItems.Delete(downloadId)

	return nil
}

func (d *Service) Progress(downloadId string) (*downloads.Progress, error) {
	val, ok := d.downloadItems.Load(downloadId)
	if !ok {
		return nil, fmt.Errorf("download not found")
	}

	return &val.progress, nil
}

func (d *Service) progressSetter(id string) func(p *downloads.Progress) {
	return func(p *downloads.Progress) {
		//log.Debug().Any("download", p).Msg("Downloading")

		item, ok := d.downloadItems.Load(id)
		if !ok {
			log.Error().Str("id", id).Msg("Download item not found, THIS SHOULD NEVER HAPPEN")
			return
		}

		item.progress = *p
		d.downloadItems.Store(id, item)
	}
}

func (d *Service) worker(downloadId string, item *DownloadItem) {
	defer func() {
		// for anybody listening for this download
		close(item.WorkerDone)
	}()

	d.ytd.Download(item, d.progressSetter(downloadId))
}
