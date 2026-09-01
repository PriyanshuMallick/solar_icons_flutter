// GENERATED FILE - DO NOT EDIT.
//
// Regenerate with: python3 tool/generate.py

/// Name-keyed maps of every Solar icon, for looking icons up dynamically —
/// from a CMS field, a config file, or a searchable icon picker.
///
/// This library is deliberately **not** exported by `solar_icons_flutter.dart`.
/// A map that mentions every icon defeats icon tree shaking, so importing it
/// pins the full font for each style whose map you touch (roughly 400-600 KB
/// per style). Import it only if you genuinely need lookup by name.
///
/// ```dart
/// import 'package:solar_icons_flutter/solar_icons_index.dart';
///
/// Icon(solarBoldIcons['home-smile']!);
/// Icon(solarIconByName('home-smile', SolarIconStyle.linear)!);
/// ```
library;

import 'package:flutter/widgets.dart';

import 'solar_icons_flutter.dart';
import 'src/index/solar_icons_bold_duotone_index.dart';
import 'src/index/solar_icons_line_duotone_index.dart';
import 'src/index/solar_icons_linear_index.dart';
import 'src/index/solar_icons_outline_index.dart';
import 'src/index/solar_icons_broken_index.dart';
import 'src/index/solar_icons_bold_index.dart';

export 'solar_icons_flutter.dart';
export 'src/index/solar_icons_bold_duotone_index.dart';
export 'src/index/solar_icons_line_duotone_index.dart';
export 'src/index/solar_icons_linear_index.dart';
export 'src/index/solar_icons_outline_index.dart';
export 'src/index/solar_icons_broken_index.dart';
export 'src/index/solar_icons_bold_index.dart';

/// Looks up [name] in [style] and returns its full-opacity [IconData].
///
/// For duotone styles this is the primary layer only; use
/// [solarDuotoneIconByName] to get both layers. Returns null if [style] has no
/// icon called [name] — Solar does not draw every icon in every style.
IconData? solarIconByName(String name, SolarIconStyle style) => switch (style) {
      SolarIconStyle.linear => solarLinearIcons[name],
      SolarIconStyle.outline => solarOutlineIcons[name],
      SolarIconStyle.broken => solarBrokenIcons[name],
      SolarIconStyle.bold => solarBoldIcons[name],
      SolarIconStyle.boldDuotone => solarBoldDuotoneIcons[name]?.primary,
      SolarIconStyle.lineDuotone => solarLineDuotoneIcons[name]?.primary,
    };

/// Looks up [name] in a duotone [style].
///
/// Returns null if [style] is not a duotone style, or has no icon called [name].
SolarDuotoneIconData? solarDuotoneIconByName(String name, SolarIconStyle style) =>
    switch (style) {
      SolarIconStyle.boldDuotone => solarBoldDuotoneIcons[name],
      SolarIconStyle.lineDuotone => solarLineDuotoneIcons[name],
      _ => null,
    };
