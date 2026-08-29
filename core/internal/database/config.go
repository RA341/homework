package database

type Config struct {
	DatabaseDir string `knob:"default=appdata,env=DATABASE_DIR,help=dir to store the app database,filepath=true"`
}
