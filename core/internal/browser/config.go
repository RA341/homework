package browser

import "time"

type Config struct {
	ServiceUrl          string
	VncUrl              string
	HealthCheckInterval time.Duration
}

func (c *Config) BaseUrl() string {
	return c.ServiceUrl
}
