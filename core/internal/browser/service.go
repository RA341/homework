package browser

import (
	"context"
	"time"

	"github.com/rs/zerolog/log"
)

type Service struct {
	config *Config
	ctx    context.Context
	cli    *ChromtrolClient

	healthStatus string
	triggerChan  chan struct{}
}

func NewService(ctx context.Context, config *Config) *Service {
	cli := NewClient(config)
	s := &Service{
		config:      config,
		ctx:         ctx,
		cli:         cli,
		triggerChan: make(chan struct{}, 1),
	}

	go s.StartHealthCheckWorker()
	s.TriggerCheck()

	return s
}

func (s *Service) IsHealthy() (bool, string) {
	status := s.healthStatus
	ok := status == ""
	return ok, status
}

func (s *Service) TriggerCheck() {
	select {
	case s.triggerChan <- struct{}{}:
		//log.Debug().Msg("sent trigger for healthcheck")
	default:
		//log.Debug().Msg("trigger channel is full")
	}
}

func (s *Service) StartHealthCheckWorker() {
	checkTimer := time.NewTicker(s.config.HealthCheckInterval)

	for {
		select {
		case <-s.triggerChan:
			s.runCheck()
		case <-checkTimer.C:
			s.runCheck()
		case <-s.ctx.Done():
			log.Info().Msg("shutting down browser healthcheck worker")
			return
		}
	}
}

func (s *Service) runCheck() {
	//log.Debug().Msg("starting health check")

	_, _, err := s.cli.Status(s.ctx)
	if err != nil {
		log.Error().Err(err).Msg("failed healthcheck for browser service")
		s.healthStatus = err.Error()
		return
	}

	s.healthStatus = ""
}
