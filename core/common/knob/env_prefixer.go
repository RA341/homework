package knob

type EnvPrefixer func(string) string

func NewPrefixer(prefix string) EnvPrefixer {
	return func(s string) string {
		return prefix + s
	}
}
