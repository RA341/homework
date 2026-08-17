package sem

type Sem struct {
	sem chan struct{}
}

func New(count int) Sem {
	return Sem{
		sem: make(chan struct{}, count),
	}
}

func (s *Sem) TryAcquire() bool {
	select {
	case s.sem <- struct{}{}:
		return true
	default:
		return false
	}
}

func (s *Sem) Acquire() {
	s.sem <- struct{}{}
}

func (s *Sem) Release() {
	<-s.sem
}
