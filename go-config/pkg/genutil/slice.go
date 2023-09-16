package genutil

// Remove nil and zero values from a slice of any type.
func Compact[T comparable](list []T) []T {
	result := make([]T, 0)
	var zero T
	for _, v := range list {
		var vv interface{} = v
		if vv != nil && v != zero {
			result = append(result, v)
		}
	}
	return result
}
