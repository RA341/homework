package knob

type Prefixer func(string) string

func NewPrefixer(prefix string) Prefixer {
	return func(s string) string {
		return prefix + s
	}
}
