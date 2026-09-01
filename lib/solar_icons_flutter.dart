/// The complete [Solar Icon Set](https://solar-icons.vercel.app) for Flutter.
///
/// Each of the six Solar styles is a separate icon font and a separate class of
/// `const IconData`, so `flutter build --tree-shake-icons` (on by default for
/// release builds) strips every glyph the app does not reference.
///
/// ```dart
/// Icon(SolarIconsBold.home);
/// Icon(SolarIconsLinear.home, size: 32, color: Colors.indigo);
/// SolarDuotoneIcon(SolarIconsBoldDuotone.home);
/// ```
library;

export 'src/solar_duotone_icon.dart';
export 'src/solar_duotone_icon_data.dart';
export 'src/solar_icon_style.dart';
export 'src/solar_icons_bold.dart';
export 'src/solar_icons_bold_duotone.dart';
export 'src/solar_icons_broken.dart';
export 'src/solar_icons_line_duotone.dart';
export 'src/solar_icons_linear.dart';
export 'src/solar_icons_outline.dart';
