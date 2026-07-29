package list

func Map[T any, Q any](input []T, convert func(T) Q) []Q {
	out := make([]Q, 0, len(input))

	for _, item := range input {
		out = append(out, convert(item))
	}

	return out
}
