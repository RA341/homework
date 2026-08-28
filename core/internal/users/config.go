package users

//const defaultUser = "admin"
//const defaultPassword = "hwisnice"

type Config struct {
	DefaultUser     string `knob:"default=hwadmin,env=DEFAULT_USER,help=username for default account; only used if there are no existing accounts"`
	DefaultPassword string `knob:"default=hwpass,env=DEFAULT_PASS,help=password for default account"`
}
