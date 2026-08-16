package browser

type Service struct {
	cli    *ChromtrolClient
	vncUrl string
}

func NewService(baseurl, vncUrl string) (*Service, error) {
	cli := NewClient(baseurl)
	s := &Service{cli: cli}
	err := s.Init()

	return s, err
}

func (s *Service) Init() error {
	_, _, err := s.cli.Stop()
	return err
}
