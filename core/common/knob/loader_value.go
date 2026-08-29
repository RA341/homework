package knob

import (
	"os"
	"path/filepath"
)

func AbsDirValueLoader() ValueLoader {
	return func(tagValue string, element *Element, strValue string) (string, error) {
		tagMap := make(map[string]string)
		err := ParseTag(tagValue, tagMap)
		if err != nil {
			return strValue, err
		}

		val, ok := tagMap["filepath"]
		if !ok || val != "true" {
			return strValue, err
		}

		strValue, err = filepath.Abs(strValue)
		if err != nil {
			return strValue, err
		}

		err = os.MkdirAll(strValue, os.ModePerm)
		return strValue, err
	}
}
