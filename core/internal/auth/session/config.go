package session

import "time"

type Config struct {
	SessionExpiry time.Duration `knob:"default=24h,env=SESSION_EXPIRY,help=how long before a re-login is required,"`
}
