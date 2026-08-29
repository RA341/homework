package knob

import (
	"errors"
	"fmt"
	"strconv"
	"strings"
)

type Element struct {
	Default  string
	Env      string
	Required bool
	Help     string
	Secret   bool
	Path     string
}

func (ke *Element) load(tagValue string) error {
	keyMap := make(map[string]string)
	err := ParseTag(tagValue, keyMap)
	if err != nil {
		return err
	}

	for key, val := range keyMap {
		switch strings.ToLower(key) {
		case "default":
			ke.Default = val
		case "env":
			ke.Env = val
		case "help":
			ke.Help = val
		case "required":
			parseBool, _ := strconv.ParseBool(val)
			ke.Required = parseBool
		case "secret":
			parseBool, _ := strconv.ParseBool(val)
			ke.Secret = parseBool
		}
	}

	return nil
}

// ParseTag parses tag values and breaks into map[string]string
// use this parse tag value to extract custom attributes
func ParseTag(tagValue string, keyMap map[string]string) error {
	tagValue = strings.TrimSpace(tagValue)
	keyvalues := strings.SplitSeq(tagValue, ",")

	var errs error
	for v := range keyvalues {
		if v == "" {
			continue
		}

		splitV := strings.Split(v, "=")
		splitLen := len(splitV)
		if splitLen > 2 || splitLen == 0 {
			err := fmt.Errorf("invalid attr: '%s' expected 1 or 2 elements, got %d", splitV, splitLen)
			errs = errors.Join(errs, err)
			continue
		}

		key := strings.ToLower(strings.TrimSpace(splitV[0]))
		value := ""
		if splitLen == 2 {
			value = strings.TrimSpace(splitV[1])
		}

		keyMap[key] = value
	}

	return errs
}
