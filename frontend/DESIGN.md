---
name: Modern Obsidian
colors:
  surface: '#151312'
  surface-dim: '#151312'
  surface-bright: '#3c3837'
  surface-container-lowest: '#100e0d'
  surface-container-low: '#1d1b1a'
  surface-container: '#221f1e'
  surface-container-high: '#2c2928'
  surface-container-highest: '#373433'
  on-surface: '#e8e1df'
  on-surface-variant: '#d8c3ad'
  inverse-surface: '#e8e1df'
  inverse-on-surface: '#33302e'
  outline: '#a08e7a'
  outline-variant: '#534434'
  surface-tint: '#ffb95f'
  primary: '#ffc174'
  on-primary: '#472a00'
  primary-container: '#f59e0b'
  on-primary-container: '#613b00'
  inverse-primary: '#855300'
  secondary: '#ffb693'
  on-secondary: '#561f00'
  secondary-container: '#76330d'
  on-secondary-container: '#fc9e6f'
  tertiary: '#d3cac9'
  on-tertiary: '#342f2e'
  tertiary-container: '#b7afad'
  on-tertiary-container: '#474241'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffddb8'
  primary-fixed-dim: '#ffb95f'
  on-primary-fixed: '#2a1700'
  on-primary-fixed-variant: '#653e00'
  secondary-fixed: '#ffdbcc'
  secondary-fixed-dim: '#ffb693'
  on-secondary-fixed: '#351000'
  on-secondary-fixed-variant: '#76330d'
  tertiary-fixed: '#e9e1df'
  tertiary-fixed-dim: '#cdc5c3'
  on-tertiary-fixed: '#1e1b1a'
  on-tertiary-fixed-variant: '#4b4644'
  background: '#151312'
  on-background: '#e8e1df'
  surface-variant: '#373433'
typography:
  headline-xl:
    fontFamily: Sora
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Sora
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Sora
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  gutter: 24px
  margin: 32px
  container-max: 1280px
---

## Brand & Style

The brand personality is sophisticated, resilient, and technical, evoking the quiet intensity of a desert landscape at midnight. This design system targets a professional audience that values precision and high-end aesthetics without the clutter of traditional skeumorphism.

The design style is **Modern Minimalist** with a focus on tonal depth rather than physical simulation. By removing shadows entirely, we rely on color contrast and structural geometry to define the hierarchy. The atmosphere is immersive and calm, utilizing a "dark mode first" approach that reduces eye strain while highlighting key interactive elements through warm, high-energy accents.

## Colors

The palette is anchored in a deep, obsidian neutral base to provide a void-like canvas for content. The primary color is a vibrant, sun-baked amber, used sparingly to draw attention to critical actions and status indicators.

- **Primary:** Burnt Amber for high-priority calls to action.
- **Secondary:** Deep Clay for subtle accents and secondary interactive states.
- **Surface Tiers:** Backgrounds are layered using varying shades of charcoal and stone to create a sense of depth without the use of drop shadows.

## Typography

This design system utilizes a dual-font strategy to balance character with utility.

**Sora** is employed for headlines to provide a geometric, modern tech feel. Its wide stance and unique apertures give the UI a distinctive, premium voice. **Inter** is used for all body copy and UI labels, ensuring maximum legibility across all densities.

Scale transitions are handled by reducing headline sizes on mobile to maintain a comfortable reading rhythm while preserving the bold, editorial hierarchy characteristic of the system.

## Layout & Spacing

The layout philosophy follows a **Fluid Grid** model based on an 8px rhythmic unit. The system uses a 12-column grid for desktop environments, transitioning to a 4-column grid for mobile devices.

Margins and gutters are generous to ensure the "shadowless" components have enough room to breathe and maintain visual distinction. Elements should align strictly to the 8px grid to ensure mathematical harmony, particularly when nesting components within cards.

## Elevation & Depth

In this design system, depth is achieved through **Tonal Layering** rather than shadows. Surfaces are stacked using color luminosity:
- **Level 0 (Base):** The darkest neutral (#0C0A09), used for the primary background.
- **Level 1 (Cards/Navigation):** A slightly lighter tone (#1C1917) to lift content containers.
- **Level 2 (Modals/Popovers):** The highest tonal step (#292524) for temporary or high-focus elements.

Thin, low-contrast borders (1px) in a muted stone color may be used to reinforce boundaries where tonal contrast is subtle.

## Shapes

The shape language is defined by a pronounced, approachable roundness that softens the technical nature of the dark theme. By utilizing a base radius of 0.5rem (8px), the system moves away from a sharp "pro" look toward a more contemporary, organic feel.

- **Standard Elements:** (Buttons, Inputs) use the base 0.5rem radius.
- **Large Containers:** (Cards, Modals) utilize `rounded-lg` (1rem) or `rounded-xl` (1.5rem) to create a soft, protective frame for content.

## Components

### Buttons
Buttons are solid, high-contrast blocks. The primary action uses the Burnt Amber background with dark text. There are no shadows; hover states are indicated by a subtle increase in color luminosity or a 2px inset border.

### Input Fields
Inputs use the Level 1 surface color with a 1px stroke. The 0.5rem corner radius ensures consistency with the buttons. On focus, the border color shifts to the primary amber, and the stroke weight increases to 2px.

### Cards
Cards are the primary content vehicle. They must use the `rounded-lg` (1rem) or `rounded-xl` (1.5rem) corner radius. To maintain the shadowless aesthetic, cards are distinguished from the background solely through their lighter tonal value.

### Navigation Elements
Navigation bars and sidebars should follow the Level 1 tonal tier. Active links are indicated by a vertical pill-shaped indicator or a high-contrast text color shift, mirroring the roundedness of the overall system.