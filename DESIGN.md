# Design System

## Concept

Calories are energy. The interface is built on that idea: progress isn't a flat bar, it's **light**. The hero of every screen is a glowing ring that behaves like it gives off its own light — dimmer when you're behind, brighter as you close in on a goal. Dark background, glass surfaces, and restrained motion all exist to make that light read as premium rather than gimmicky.

Mood: quiet, dark, a little luxurious. Not neon, not playful, not clinical.

This document is the source of truth for color, type, spacing, and component behavior. If something isn't covered here, extend the existing pattern rather than inventing a new one.

## Color

| Token                         | Value                                                                                 | Use                                                                                              |
| ----------------------------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| `bg.base`                     | `#0B0A10`                                                                             | App background. Near-black with a faint violet undertone — not pure blue-black.                  |
| `surface.glass`               | fill `rgba(255,255,255,0.06)` over blurred `bg.base`, border `rgba(255,255,255,0.10)` | Cards, sheets, nav. See Glass recipe below.                                                      |
| `text.primary`                | `#F4F2F7`                                                                             | Headlines, hero numbers, primary body text.                                                      |
| `text.secondary`              | `#96909F`                                                                             | Captions, labels, placeholder text.                                                              |
| `energy.start` / `energy.end` | `#FF8F5E` → `#FFD36E`                                                                 | Calorie ring, primary buttons — anything meant to feel "charged." Always a gradient, never flat. |
| `macro.protein`               | `#FF6F91`                                                                             | Protein ring/label.                                                                              |
| `macro.carbs`                 | `#FFC24D`                                                                             | Carb ring/label.                                                                                 |
| `macro.fat`                   | `#8C9EFF`                                                                             | Fat ring/label.                                                                                  |

The three macro hues are functional, not decorative — they're how a user tells the rings apart at a glance. Keep them consistent everywhere a macro shows up: rings, chart lines, list tags.

## Typography

Two families, two jobs, both via `google_fonts`.

- **Space Grotesk** — display. Hero calorie number, screen titles, ring center labels. Weights 500/700.
- **Manrope** — body/UI. List items, buttons, nav labels, captions. Weights 400/600.

| Style       | Size/weight                          | Face          |
| ----------- | ------------------------------------ | ------------- |
| Hero number | 56sp / 700                           | Space Grotesk |
| H1          | 28sp / 700                           | Space Grotesk |
| H2          | 20sp / 600                           | Manrope       |
| Body        | 15sp / 400                           | Manrope       |
| Caption     | 12sp / 500, uppercase, +0.5 tracking | Manrope       |

## Spacing & radius

- Spacing scale: 8 / 12 / 16 / 24 / 32 (4dp base grid).
- Radius: cards 28dp · buttons/pills fully rounded · inputs 16dp.
- Card padding: 20–24dp.

## Glass recipe

`BackdropFilter` with `ImageFilter.blur(sigmaX: 20, sigmaY: 20)`, clipped to an `RRect` at the card's radius, filled with `surface.glass`, 1px border at `rgba(255,255,255,0.10)`. Optional: a 1px top-edge highlight (white 12% → transparent) to sell the "catching light" look.

Glass is for elevated surfaces only — cards, bottom nav, sheets. Never blur the full screen background; it's expensive and reads cheap when overused.

## Motion

- Ring fill: 0 → current value over ~900ms, `Curves.easeOutCubic`, on load or value change.
- Goal-met pulse: glow scales 100%→115%→100% once over ~600ms when a daily target is hit. One-time, not looping.
- Respect `MediaQuery.of(context).disableAnimations` — skip the pulse and fill instantly when reduced motion is on.
- Nothing else animates by default. No bounce on every tap, no transition flourishes beyond a simple fade. The ring is the app's one spend on motion.

## Components

- **Hero ring (calories)** — ~240dp diameter, 14dp stroke, `energy` gradient sweep, round cap, soft glow behind it (blurred shadow, `energy.start` at ~30% opacity, blur radius ~40). Center: calorie number, Space Grotesk 56sp, "kcal left" caption in `text.secondary` beneath.
- **Macro rings** — three rings, 72dp diameter, 8dp stroke, one per macro token, inside a glass card below the hero ring. Label + gram count under each.
- **Glass card** — standard container for grouped content: macro row, meal list section, weekly chart.
- **Bottom nav** — floating glass pill, not edge-to-edge, max 4 icons. Active icon gets a small glow dot in the `energy` gradient.
- **Buttons** — primary: `energy` gradient fill, fully rounded, dark text (`bg.base`). Secondary: glass outline, `text.primary` label.
- **Search/input fields** — glass fill, 16dp radius, leading icon, `text.secondary` placeholder.
- **Empty/error states** — direct and specific, in the interface's own voice: "No meals logged yet. Add your first one." Not apologetic, not vague.

## Screens

1. **Home/Dashboard** — hero calorie ring in the top third. Macro-ring glass card beneath. "Today's meals" list below that (glass rows). Floating add button, bottom-right, `energy` gradient fill.
2. **Log Meal / Add Food** — glass search field at top, results/recent foods as glass list rows, `energy`-gradient confirm button.
3. **Food Detail / Portion entry** — glass card with food name, macro breakdown (small rings or bars in macro tokens), quantity stepper as a glass pill, gradient confirm button.
4. **Progress/History** — weekly chart in a glass card, series colored with the energy/macro palette, glass segmented control for the time range.
5. **Settings/Profile** — glass list rows, Manrope caption-style section headers, same dark background throughout.

Apply these tokens and component rules to whatever screens exist beyond this list — the system is what matters, not this exact inventory.

## Flutter implementation notes

- Fonts via `google_fonts`: `GoogleFonts.spaceGrotesk(...)`, `GoogleFonts.manrope(...)`, wired into `ThemeData.textTheme`.
- Define a `ThemeExtension` (e.g. `AppColors`) holding every token above so screens pull from one source instead of hardcoding hex values per widget.
- Build rings with a custom `CustomPainter`, not a generic percent-indicator package — you need control over the gradient sweep and glow. Track circle: white at 8% opacity. Progress arc: `SweepGradient` with the relevant gradient/color, `strokeCap: StrokeCap.round`. Glow: blurred shadow behind the arc (`MaskFilter.blur` or a `BoxShadow` on a wrapping container).
- Animate ring values with `TweenAnimationBuilder<double>` or an `AnimationController` + `CurvedAnimation(curve: Curves.easeOutCubic)`.
- Check `MediaQuery.of(context).disableAnimations` before running the goal-met pulse.

## Anti-patterns

- Flutter's default Material 3 seed-color purple/indigo. It's the clearest tell that an app wasn't designed on purpose.
- A single flat neon accent on near-black instead of the gradient + four-hue system — that's the generic "AI dark mode" look this system is built to avoid.
- Blurring the whole screen instead of just elevated surfaces.
- Motion beyond what's specified here — one signature moment (the ring) beats animation on every tap.
- Skipping a contrast check. `text.primary` and `text.secondary` both need to clear WCAG AA (4.5:1) against `bg.base` and against `surface.glass`. Glass surfaces are the easiest place for this to quietly fail.
