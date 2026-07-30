package downloader

import (
	"sync"

	"github.com/rs/zerolog/log"
)

type Queue[T any] struct {
	ch chan T
	wg sync.WaitGroup

	WorkerFunc func(message T)
}

func NewQueue[T any](maxWorkers uint, worker func(message T)) *Queue[T] {
	return &Queue[T]{
		ch:         make(chan T, maxWorkers),
		wg:         sync.WaitGroup{},
		WorkerFunc: worker,
	}
}

func (q *Queue[T]) Enqueue(message T) {
	q.ch <- message
}

func (q *Queue[T]) Dequeue() {
	for {
		select {
		case val, ok := <-q.ch:
			if !ok {
				log.Info().Msg("Channel closed")
				return
			}

			q.wg.Go(func() {
				q.WorkerFunc(val)
			})
		}
	}
}
