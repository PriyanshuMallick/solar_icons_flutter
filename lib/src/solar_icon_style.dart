/// The six drawing styles the Solar Icon Set ships in.
///
/// Each style is backed by its own font and its own `SolarIcons*` class. This
/// enum is a convenience for UI that lets a user pick a style; it deliberately
/// does not map names to icons, because a name-to-icon map would defeat icon
/// tree shaking.
enum SolarIconStyle {
  /// Thin, evenly weighted strokes. The default Solar look.
  linear('SolarIconsLinear', 'Linear'),

  /// Stroked shapes with filled accents.
  outline('SolarIconsOutline', 'Outline'),

  /// Solid filled shapes.
  bold('SolarIconsBold', 'Bold'),

  /// Linear strokes with deliberate gaps.
  broken('SolarIconsBroken', 'Broken'),

  /// Linear strokes over a translucent stroked layer.
  lineDuotone('SolarIconsLineDuotone', 'Line Duotone'),

  /// Solid shapes over a translucent filled layer.
  boldDuotone('SolarIconsBoldDuotone', 'Bold Duotone');

  const SolarIconStyle(this.fontFamily, this.label);

  /// The font family that backs this style.
  final String fontFamily;

  /// A human-readable name, e.g. `'Bold Duotone'`.
  final String label;

  /// Whether icons in this style are drawn as two layers and are best rendered
  /// with a [SolarDuotoneIcon](../solar_duotone_icon/SolarDuotoneIcon-class.html).
  bool get isDuotone => this == lineDuotone || this == boldDuotone;
}
