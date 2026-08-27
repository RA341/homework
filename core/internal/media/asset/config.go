package asset

type Config struct {
	AssetDir string `knob:"default=assets,env=ASSET_DIR,help=dir to store the files,"`
}
