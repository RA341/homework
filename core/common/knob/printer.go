package knob

import (
	"fmt"
	"os"
	"reflect"
	"strings"

	"github.com/fatih/color"
	"github.com/olekukonko/tablewriter"
	"github.com/olekukonko/tablewriter/renderer"
	"github.com/olekukonko/tablewriter/tw"
	"github.com/rs/zerolog/log"
)

var (
	// Red asterisk indicator
	requiredMark = color.New(color.FgHiRed, color.Bold)

	// Subheader full-row highlight (white text on cyan background)
	sectionBg = color.New(color.FgHiWhite, color.BgCyan, color.Bold)
	// Column text colors
	sectionColor = color.New(color.FgMagenta, color.Bold)
	keyColor     = color.New(color.FgHiCyan)
	valColor     = color.New(color.FgGreen)
	defaultColor = color.New(color.FgYellow)
	envColor     = color.New(color.FgMagenta)
	helpColor    = color.New(color.FgHiWhite)
	secretColor  = color.New(color.FgHiRed)
)

type Printer struct {
	Elements []ElementWithVal
	prefixer EnvPrefixer
}

func PrettyPrint(conf any, prefixer EnvPrefixer) {
	p := Printer{
		prefixer: prefixer,
	}
	k := Knob{
		functor: p.loadElements,
	}

	err := k.walkStruct(conf, "")
	if err != nil {
		log.Warn().Err(err).Msg("error walking struct")
	}

	p.Print()
}

type ElementWithVal struct {
	Element
	Value any
}

func (p *Printer) loadElements(rv reflect.Value, element *Element, value string) error {
	p.Elements = append(
		p.Elements,
		ElementWithVal{
			Element: *element,
			Value:   rv.Interface(),
		},
	)

	return nil
}

func (p *Printer) Print() {
	// Configure colors per column for headers and row values:
	// Col 0: Key     (White)
	// Col 1: Value   (Green)
	// Col 2: Default (Yellow)
	// Col 3: Env     (Magenta)
	// Col 4: Help    (HiBlack/Muted)
	colorCfg := renderer.ColorizedConfig{
		Header: renderer.Tint{
			FG: renderer.Colors{color.FgHiWhite, color.Bold},
			Columns: []renderer.Tint{
				{FG: renderer.Colors{color.FgHiCyan, color.Bold}},  // Key
				{FG: renderer.Colors{color.FgGreen, color.Bold}},   // Value
				{FG: renderer.Colors{color.FgMagenta, color.Bold}}, // Env
				{FG: renderer.Colors{color.FgHiWhite, color.Bold}}, // Help
			},
		},
		Column: renderer.Tint{
			Columns: []renderer.Tint{
				{FG: renderer.Colors{color.FgHiCyan}},  // Key
				{FG: renderer.Colors{color.FgGreen}},   // Value
				{FG: renderer.Colors{color.FgMagenta}}, // Env
				{FG: renderer.Colors{color.FgHiWhite}}, // Help
			},
		},
		Border:    renderer.Tint{FG: renderer.Colors{color.FgWhite}},
		Separator: renderer.Tint{FG: renderer.Colors{color.FgWhite}},
	}

	table := tablewriter.NewTable(os.Stdout,
		tablewriter.WithRenderer(renderer.NewColorized(colorCfg)),
		tablewriter.WithConfig(tablewriter.Config{
			Row: tw.CellConfig{
				Formatting: tw.CellFormatting{AutoWrap: tw.WrapNormal},
				Alignment:  tw.CellAlignment{Global: tw.AlignLeft},
			},
		}),
	)

	// Headers are passed as plain text; renderer applies the colors
	table.Header([]string{"Key", "Value", "Env", "Help"})

	lastParent := ""
	for _, e := range p.Elements {
		parent, leaf := splitPath(e.Path)

		// Full-row blocked subheader banner
		if parent != lastParent {
			_ = table.Append([]string{
				sectionBg.Sprint(" " + parent),
				sectionBg.Sprint("======="),
				sectionBg.Sprint("======="),
				sectionBg.Sprint("======="),
			})
			lastParent = parent
		}

		key := "  " + leaf
		if e.Required {
			key += requiredMark.Sprint("*")
		}

		val, isSecret := formatVal(e)
		if isSecret {
			val = color.HiRedString(val)
		}

		_ = table.Append([]string{
			key,
			val,
			p.prefixer(e.Env),
			e.Help,
		})
	}

	_ = table.Render()
	fmt.Println("" + requiredMark.Sprint("*") + " indicates required key")
}

func splitPath(path string) (string, string) {
	parts := strings.SplitN(path, ".", 2)
	if len(parts) == 1 {
		return "(root)", parts[0]
	}
	return parts[0], parts[1]
}

func formatVal(e ElementWithVal) (string, bool) {
	if e.Secret {
		return "<Redacted>", true
	}
	v := fmt.Sprintf("%v", e.Value)
	if v == "" || v == "<nil>" {
		return "-", false
	}
	return v, false
}
