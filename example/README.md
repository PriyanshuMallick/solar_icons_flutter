# Solar Icons gallery

A browsable gallery of all 7,759 Solar icons, and the example app for
[`solar_icons_flutter`](../).

```bash
flutter run
```

- Switch between the six Solar styles
- Search by Solar name
- Scale icons from 16 to 64
- Light and dark mode
- Tap any icon to copy its Dart snippet

The gallery imports `package:solar_icons_flutter/solar_icons_index.dart` because it needs
every icon by name. Real apps should import
`package:solar_icons_flutter/solar_icons_flutter.dart` and reference icons directly
(`SolarIconsBold.home`), which lets Flutter tree-shake the fonts.
