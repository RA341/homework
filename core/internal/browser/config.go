package browser

import "time"

type Config struct {
	ServiceUrl          string        `knob:"default=http://localhost:8998,env=CHROMTROL_URL,help=url for the chromtrol service"`
	VncUrl              string        `knob:"default=http://localhost:3012,env=CHROMTROL_VNC_URL,help=url for the chromtrol vnc endpoint"`
	HealthCheckInterval time.Duration `knob:"default=5m,env=HEALTH_CHECK_INTERVAL,help=time between healthcheck for chromtrol"`
}

func (c *Config) BaseUrl() string {
	return c.ServiceUrl
}
