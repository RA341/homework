package downloader

import (
	"sync"
	"time"

	"github.com/ra341/homework/common/sem"
	"github.com/rs/zerolog/log"
)

type DownloadStore interface {
	ListQueued(limit int) ([]Download, error)
	SetStatus(id uint, state DownloadState) error
}

type Downloader interface {
	download(download *Download)
}

type DownloadWorker struct {
	MaxWorkers    int
	downloadStore DownloadStore
	downloader    Downloader

	workerLock    sem.Sem
	workerRunning chan struct{}
	ExitThreshold int
}

func NewDownloadWorker(
	MaxWorkers int,
	ExitThreshold int,
	downloadStore DownloadStore,
	downloader Downloader,
) *DownloadWorker {
	return &DownloadWorker{
		MaxWorkers:    MaxWorkers,
		ExitThreshold: ExitThreshold,

		downloadStore: downloadStore,
		downloader:    downloader,
		workerLock:    sem.New(1),
	}
}

func (dw *DownloadWorker) Start() {
	ok := dw.workerLock.TryAcquire()
	if ok {
		log.Info().Msg("launched download worker")
		// send max workers, threshold first because we might change max workers during runtime
		// and directly accessing may cause race condition after the worker is running
		go dw.worker(dw.MaxWorkers, dw.ExitThreshold)
	} else {
		log.Info().Msg("download worker is already running")
	}
}

func (dw *DownloadWorker) wait() {
	<-dw.workerRunning
}

func (dw *DownloadWorker) isRunning() bool {
	select {
	case <-dw.workerRunning:
		return false
	default:
		return true
	}
}

func (dw *DownloadWorker) worker(maxWorkers, exitThreshold int) {
	dw.workerRunning = make(chan struct{}, 1)

	downloadChan := make(chan *Download, 1)
	consumerExited := make(chan struct{}, 1)

	defer func() {
		log.Debug().Msg("beginning worker cleanup")

		close(downloadChan)
		//log.Debug().Msg("stopping consumer")
		<-consumerExited
		//log.Debug().Msg("consumer stopped")

		dw.workerLock.Release()
		close(dw.workerRunning)

		log.Info().Msg("worker stopped")

		queued, err := dw.downloadStore.ListQueued(maxWorkers)
		if err != nil {
			log.Warn().Err(err).Msg("Could not load downloading items")
			return
		}

		if len(queued) != 0 {
			log.Info().Msg("queued items starting worker again")
			dw.Start()
		}
	}()

	const waitInterval = 5 * time.Second

	downloadSem := sem.New(maxWorkers)
	go dw.consumer(&downloadSem, downloadChan, consumerExited)

	strikes := 0
	for {
		exitCondition := strikes > exitThreshold
		if exitCondition {
			return
		}

		queued, err := dw.downloadStore.ListQueued(maxWorkers)
		if err != nil {
			log.Warn().Err(err).Msg("Could not load downloading items")
			return
		}

		if len(queued) == 0 {
			strikes++
			<-time.After(waitInterval)
			continue
		}

		strikes = 0
		for _, q := range queued {
			downloadChan <- &q
		}
	}
}

func (dw *DownloadWorker) consumer(
	downloadSem *sem.Sem,
	downloadChan chan *Download,
	consumerDone chan struct{},
) {
	wg := sync.WaitGroup{}

	for d := range downloadChan {
		downloadSem.Acquire()
		err := dw.downloadStore.SetStatus(d.ID, Downloading)
		if err != nil {
			log.Warn().Err(err).Any("download", d).Msg("Could not set status to downloading, skipping...")
			continue
		}

		wg.Go(func() {
			defer downloadSem.Release()
			dw.downloader.download(d)
		})
	}

	wg.Wait()
	close(consumerDone)
}
