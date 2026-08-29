package knob

import (
	"errors"
	"fmt"
	"strconv"
	"strings"
)

type Element struct {
	Default    string
	Env        string
	Required   bool
	Help       string
	Secret     bool
	Path       string
	IsFilePath bool
}

func (ke *Element) parseTag(tagValue string) error {
	keyMap := make(map[string]string)
	err := ke.loadKeymap(tagValue, keyMap)
	if err != nil {
		return err
	}

	for key, val := range keyMap {
		switch key {
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
		case "filepath":
			parseBool, _ := strconv.ParseBool(val)
			ke.IsFilePath = parseBool
		default:
			return fmt.Errorf("unsupported key %s", key)
		}
	}

	return nil
}

func (ke *Element) loadKeymap(tagValue string, keyMap map[string]string) error {
	tagValue = strings.TrimSpace(tagValue)
	keyvalues := strings.SplitSeq(tagValue, ",")

	var errs error
	for v := range keyvalues {
		if v == "" {
			continue
		}

		splitV := strings.Split(v, "=")
		if len(splitV) != 2 {
			err := fmt.Errorf("invalid attr: %s expected len 2 after split, got %d", splitV, len(splitV))
			errs = errors.Join(errs, err)
			continue
		}

		key := strings.ToLower(strings.TrimSpace(splitV[0]))
		value := strings.TrimSpace(splitV[1])
		keyMap[key] = value
	}

	return errs
}
