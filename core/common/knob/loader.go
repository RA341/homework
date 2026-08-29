package knob

import (
	"fmt"
	"os"
	"reflect"
	"strconv"
)

type TypeMapFn func(rv reflect.Value, value string, ele *Element) error

type ValueLoader func(tagValue string, element *Element, fieldStrValue string) (string, error)

type Loader struct {
	EnvPrefixer EnvPrefixer
	TypeMapper  map[reflect.Type]TypeMapFn

	ValueLoaders []ValueLoader
}

func LoadConfig(conf any, opts ...Opt) (err error) {
	l := &Loader{
		TypeMapper: DefaultMappers(),
	}

	for _, op := range opts {
		op(l)
	}

	k := Knob{
		functor: l.assignValue,
	}

	err = k.walkStruct(conf, "")
	return err
}

func (k *Loader) assignValue(rv reflect.Value, element *Element, tagValue string) error {
	strValue, err := k.loadValues(element, tagValue)
	if err != nil {
		return err
	}

	mapFn, ok := k.TypeMapper[rv.Type()]
	if ok {
		return mapFn(rv, strValue, element)
	}

	// primitive base values
	switch rv.Kind() {
	case reflect.String:
		rv.SetString(strValue)
	case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
		atoi, err := strconv.Atoi(strValue)
		if err != nil {
			return fmt.Errorf("%s = invalid int str: %s", element.Path, err)
		}
		rv.SetInt(int64(atoi))
	case reflect.Bool:
		parsedBool, err := strconv.ParseBool(strValue)
		if err != nil {
			return fmt.Errorf("%s = invalid bool str: %s", element.Path, err)
		}
		rv.SetBool(parsedBool)
	case reflect.Float32, reflect.Float64:
		float, err := strconv.ParseFloat(strValue, 64)
		if err != nil {
			return fmt.Errorf("%s = invalid float str: %s", element.Path, err)
		}
		rv.SetFloat(float)
	default:
		return fmt.Errorf("%s = unsupported type: %s", element.Path, rv.Type())
	}

	return nil
}

func (k *Loader) loadValues(element *Element, tagValue string) (string, error) {
	// todo potentially look at file

	prefixedEnv := k.EnvPrefixer(element.Env)
	strValue, ok := os.LookupEnv(prefixedEnv)
	if !ok {
		if element.Required {
			return "", fmt.Errorf("env is required, use %s to set value", prefixedEnv)
		}

		if element.Default == "" {
			return "", fmt.Errorf("value has no defaults, any non-required value must have defaults, add 'default:some_default' to your struct tag %s", tagValue)
		}

		strValue = element.Default
	}

	var err error
	// run custom value loaders hooks
	for _, vl := range k.ValueLoaders {
		strValue, err = vl(tagValue, element, strValue)
		if err != nil {
			return "", err
		}
	}

	return strValue, nil
}
