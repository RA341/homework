package media

type Config struct {
	UploadDir string `knob:"default=uploads,env=UPLOAD_DIR,help=dir to temporarily store upload files"`
}
