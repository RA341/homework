package authentication

import "time"

type Config struct {
	JwtSecret []byte        `knob:"env=JWT_SECRET,help=secret used to encrypt credentials,required=true,secret=true"`
	JwtIssuer string        `knob:"default=homework,env=JWT_AUDIENCE,help=label to distinguish server jwt,secret=false"`
	JwtExpiry time.Duration `knob:"default=1h,env=JWT_EXPIRY,help=time limit for a jwt to be valid,"`
}
