## 1.0.0

Initial release.

- All 7,759 Solar icons across the six Solar styles — Linear, Outline, Bold, Broken,
  Line Duotone and Bold Duotone — as `const IconData` backed by one TrueType font per
  style. No dependencies.
- `SolarDuotoneIcon` renders duotone icons as their two layers; `SolarDuotoneIconData`
  exposes each layer as a plain `IconData`.
- `SolarIconStyle` enumerates the six styles for style pickers.
- Opt-in `package:solar_icons_flutter/solar_icons_index.dart` maps every Solar name to
  its icon for dynamic lookup.
- Works with `--tree-shake-icons`: a style you draw from is subset to the glyphs you use.
- `tool/generate.py` regenerates the fonts and bindings from `@iconify-json/solar@1.2.10`.
