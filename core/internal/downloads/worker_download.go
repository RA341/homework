package downloads

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
	ExitThreshold int

	downloadStore DownloadStore
	downloader    Downloader

	workerLock    sem.Sem
	workerRunning chan struct{}

	triggerDownloads chan struct{}
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

		triggerDownloads: make(chan struct{}, 1),
		workerLock:       sem.New(1),
	}
}

func (dw *DownloadWorker) Start() {
	ok := dw.workerLock.TryAcquire()
	if ok {
		log.Info().Msg("launched download worker")
		// send max workers, threshold first because we might change max workers during runtime
		// and directly accessing may cause race condition after the worker is running
		go dw.worker(dw.MaxWorkers)
	} else {
		dw.triggerRecheck()
		log.Info().Msg("download worker is already running")
	}
}

func (dw *DownloadWorker) triggerRecheck() {
	select {
	case dw.triggerDownloads <- struct{}{}:
	default:
		log.Warn().Msg("trigger chan is full")
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

func (dw *DownloadWorker) worker(maxWorkers int) {
	dw.workerRunning = make(chan struct{}, 1)
	defer func() {
		dw.workerLock.Release()
		close(dw.workerRunning)
		log.Info().Msg("worker stopped")
	}()

	downloadSem := sem.New(maxWorkers)
	wg := sync.WaitGroup{}

	strikes := 0
	for {
		var done bool
		done, strikes = dw.loop(
			&wg,
			&downloadSem,
			strikes,
			dw.ExitThreshold,
			maxWorkers,
		)
		if done {
			return
		}
	}
}

func (dw *DownloadWorker) loop(
	wg *sync.WaitGroup,
	downloadSem *sem.Sem,
	strikes int,
	exitThreshold int,
	queueLimit int,
) (done bool, strikesOut int) {
	const waitInterval = 5 * time.Second

	wgDone := make(chan struct{}, 1)
	exitCondition := strikes > exitThreshold
	if exitCondition {
		go func() {
			// in the event a retry is called
			// we leak go the routine, but since
			// once all tasks are done we exit immediately anyway
			// wgDone is also leaked until go routine is done
			wg.Wait()
			close(wgDone)
		}()

		select {
		case <-wgDone:
			log.Info().Msg("exiting loop")
			return true, strikes
		case <-dw.triggerDownloads:
			log.Info().Msg("trigger received starting loop again")
			strikes = 0
			return false, strikes
		}
	}

	queued, err := dw.downloadStore.ListQueued(queueLimit)
	if err != nil {
		log.Warn().Err(err).Msg("Could not load downloading items")
		return false, strikes
	}

	if len(queued) == 0 {
		strikes++
		<-time.After(waitInterval)
		return false, strikes
	}

	strikes = 0

	for _, d := range queued {
		downloadSem.Acquire()
		err = dw.downloadStore.SetStatus(d.ID, Downloading)
		if err != nil {
			log.Warn().Err(err).Any("download", d).Msg("Could not set status to downloading, skipping...")
			continue
		}

		wg.Go(func() {
			defer downloadSem.Release()
			dw.downloader.download(&d)
		})
	}

	return false, strikes
}
