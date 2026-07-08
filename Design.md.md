---
version: alpha
name: Green the Web
description: A nature-forward, high-contrast editorial system with warm accents and a clean, approachable UX tone.
colors:
  primary: "#0B3D33"
  primary-foreground: "#FFFFFF"
  secondary: "#1F7A62"
  tertiary: "#FCCC62"
  neutral: "#F5F5F2"
  surface: "#FFFFFF"
  surface-strong: "#111111"
  on-surface: "#222222"
  muted: "#E5E7EB"
  subtle: "#D7DDD9"
  accent: "#00B3A4"
  error: "#D64545"
typography:
  headline-display:
    fontFamily: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Ubuntu, Cantarell, "Helvetica Neue", sans-serif
    fontSize: 38px
    fontWeight: 700
    lineHeight: 1.3
    letterSpacing: 0px
  headline-lg:
    fontFamily: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Ubuntu, Cantarell, "Helvetica Neue", sans-serif
    fontSize: 27px
    fontWeight: 700
    lineHeight: 1.3
    letterSpacing: 0px
  headline-md:
    fontFamily: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Ubuntu, Cantarell, "Helvetica Neue", sans-serif
    fontSize: 21px
    fontWeight: 700
    lineHeight: 1.4
    letterSpacing: 0px
  headline-sm:
    fontFamily: Arial, Helvetica, sans-serif
    fontSize: 18px
    fontWeight: 600
    lineHeight: 1.22
    letterSpacing: 0px
  body-lg:
    fontFamily: Arial, Helvetica, sans-serif
    fontSize: 18px
    fontWeight: 400
    lineHeight: 1.6
    letterSpacing: 0px
  body-md:
    fontFamily: Arial, Helvetica, sans-serif
    fontSize: 16px
    fontWeight: 400
    lineHeight: 1.6
    letterSpacing: 0px
  body-sm:
    fontFamily: Arial, Helvetica, sans-serif
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.5
    letterSpacing: 0px
  label-lg:
    fontFamily: Arial, Helvetica, sans-serif
    fontSize: 16px
    fontWeight: 400
    lineHeight: 1.2
    letterSpacing: 0px
  label-md:
    fontFamily: Arial, Helvetica, sans-serif
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.2
    letterSpacing: 0px
  label-sm:
    fontFamily: Arial, Helvetica, sans-serif
    fontSize: 12px
    fontWeight: 400
    lineHeight: 1.2
    letterSpacing: 0px
rounded:
  none: 0px
  sm: 4px
  md: 5px
  lg: 8px
  xl: 12px
  full: 9999px
spacing:
  xs: 6px
  sm: 16px
  md: 28px
  lg: 48px
  xl: 112px
components:
  button-primary:
    backgroundColor: "{colors.tertiary}"
    textColor: "{colors.on-surface}"
    typography: "{typography.label-lg}"
    rounded: "{rounded.md}"
    padding: "10px 30px"
    height: "38px"
  button-secondary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.surface}"
    typography: "{typography.label-lg}"
    rounded: "{rounded.md}"
    padding: "10px 30px"
    height: "38px"
  button-link:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.secondary}"
    typography: "{typography.label-lg}"
    rounded: "{rounded.none}"
    padding: "0px"
  card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface}"
    rounded: "{rounded.lg}"
    padding: "16px"
  input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface}"
    rounded: "{rounded.md}"
    padding: "10px 12px"
  chip:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.surface}"
    rounded: "{rounded.full}"
    padding: "6px 12px"
---

# Green the Web

## Overview
Green the Web feels eco-conscious, optimistic, and practical rather than overly decorative. The page combines a deep forest backdrop with bright, friendly accent color to communicate sustainability, clarity, and trust. It is tailored to a design-savvy audience that values UX/UI education, but the tone remains approachable and editorial instead of academic. The overall composition is spacious and calm, with strong contrast and a clear call to action.

## Colors
- **Primary (#0B3D33):** A deep forest green used for the hero background and the overall brand atmosphere. It creates a premium, nature-first foundation and keeps the interface grounded.
- **Primary foreground (#FFFFFF):** Crisp white used on the dark green surfaces for navigation, headlines, and illustrative linework. It preserves readability and sharp contrast.
- **Secondary (#1F7A62):** A muted teal-green used for subtle interactive text and secondary brand moments. It feels related to the primary color without competing with the accent.
- **Tertiary (#FCCC62):** A warm golden yellow used for the primary call-to-action button. It adds optimism, draws attention quickly, and contrasts strongly with the dark hero background.
- **Neutral (#F5F5F2):** A soft off-white for light sections and page breathing room. It keeps the design from feeling stark while supporting a clean editorial layout.
- **Surface (#FFFFFF):** Pure white used for cards, content areas, and utility surfaces. It helps content blocks remain crisp and easy to scan.
- **On-surface (#222222):** The main body text color, a deep charcoal that is softer than pure black. It supports long-form readability and a friendly tone.
- **Muted (#E5E7EB):** A light gray border and divider tone used for subtle separation, especially in cards. It supports structure without introducing heavy chrome.
- **Subtle (#D7DDD9):** A soft gray-green neutral for low-emphasis boundaries and understated UI details. It fits the environmental palette without becoming decorative.
- **Accent (#00B3A4):** A fresh aqua accent that can be used for highlights, status, or utility chips. It adds a modern digital energy to the organic color story.
- **Error (#D64545):** A clear red reserved for validation and destructive states. It should stay rare so the palette remains calm and brand-led.

## Typography
The system uses a system sans stack led by `-apple-system`, paired with Arial for body and label styles. Headlines are bold, compact, and highly legible, with no visible letter-spacing tricks; the typographic voice is confident, modern, and direct. `headline-display`, `headline-lg`, and `headline-md` are used for hero and section hierarchy, while `body-md` and `body-lg` support article-like explanations and feature descriptions. Labels stay simple and functional, reflecting the site’s pragmatic, educational tone rather than a trendy editorial style.

## Layout
The layout favors a fixed-max-width editorial grid with generous outer whitespace, especially in the hero and feature sections. Spacing is airy and predictable, using a rhythm that steps through 6px, 16px, 28px, 48px, and 112px for detail, grouping, section breaks, and large-page breathing room. Content blocks are aligned into clear columns, with the hero splitting copy and imagery side-by-side and the lower section using three evenly balanced feature cards. Buttons and cards use comfortable internal padding so the design feels relaxed rather than crowded.

## Elevation & Depth
Depth is intentionally restrained. The interface relies on color contrast, borders, and whitespace instead of heavy shadows or layered elevation. White cards and utility surfaces sit cleanly on the page with thin neutral borders, while the hero achieves hierarchy through a dark full-bleed background and strong tonal contrast. This flat treatment keeps the brand feeling efficient, modern, and environmentally mindful.

## Shapes
The shape language is soft and practical, with small radii rather than playful curves. Interactive controls use the `rounded.md` 5px corner treatment, and content cards use slightly more rounding at 8px for a calm, approachable feel. The result is architectural and tidy, with just enough softness to avoid harshness.

## Components
Buttons are the most expressive component in the system. `button-primary` uses the warm yellow tertiary color with dark text, making it the main conversion action on dark or light backgrounds. `button-secondary` is a dark filled button with white text for stronger contextual contrast, while `button-link` is minimal, text-only, and underlined for lightweight navigation. Buttons should keep their compact 38px height and generous horizontal padding so they read as friendly, not bulky.

Cards use a white background, subtle border, and modest 8px radius. They should contain generous padding and rely on internal hierarchy rather than shadows to separate content. Inputs should match the card language: white surface, 5px radius, and restrained border treatment so form elements remain consistent with the overall calm aesthetic. Chips and small utility pills should use the accent aqua or another restrained brand tint, with full rounding for a modern status-tag feel.

Navigation items are text-led and understated, with no heavy button framing. Links should remain clean and minimal, with color changes and underline treatment only when needed. Any icons, illustrations, or line art should feel lightweight and integrated, supporting the organic sustainability theme rather than competing with the content.

## Do's and Don'ts
- Do keep the design high-contrast and easy to read, especially on the dark hero background.
- Do use the yellow tertiary color sparingly for primary actions and attention moments.
- Do maintain generous whitespace and clear column structure to preserve the editorial feel.
- Do keep borders subtle and shadows minimal; rely on layout and color contrast first.
- Don't introduce heavy gradients, glossy effects, or deep drop shadows.
- Don't over-round controls; the system should feel tidy and measured, not pill-heavy.
- Don't use multiple competing accent colors in the same component group.
- Don't make body copy too small or too light; the site depends on clarity and accessibility.