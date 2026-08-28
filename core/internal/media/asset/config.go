package asset

type Config struct {
	AssetDir string `knob:"default=assets,env=ASSET_DIR,filepath=true,help=dir to store the files,"`
}
