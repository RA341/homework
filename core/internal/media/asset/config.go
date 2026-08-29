package asset

type Config struct {
	AssetDir string `knob:"default=assets,env=ASSET_DIR,filepath,help=dir to store the files,"`
}
