import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// The gallery needs every icon by name, so it imports the opt-in index library.
// Apps that reference icons directly (`SolarIconsBold.home`) should import
// `package:solar_icons_flutter/solar_icons_flutter.dart` instead, which lets
// Flutter tree-shake the fonts down to just the glyphs they use.
import 'package:solar_icons_flutter/solar_icons_index.dart';

void main() => runApp(const SolarGalleryApp());

class SolarGalleryApp extends StatefulWidget {
  const SolarGalleryApp({super.key});

  @override
  State<SolarGalleryApp> createState() => _SolarGalleryAppState();
}

class _SolarGalleryAppState extends State<SolarGalleryApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    ThemeData theme(Brightness brightness) => ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF5B5BD6),
            brightness: brightness,
          ),
          useMaterial3: true,
        );

    return MaterialApp(
      title: 'Solar Icons',
      debugShowCheckedModeBanner: false,
      theme: theme(Brightness.light),
      darkTheme: theme(Brightness.dark),
      themeMode: _themeMode,
      home: GalleryPage(
        onToggleTheme: () => setState(() {
          _themeMode =
              _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        }),
      ),
    );
  }
}

const double _controlsHeight = 126;

/// One row of the gallery: a Solar name plus whichever icon data the current
/// style provides for it.
class _Entry {
  const _Entry(this.name, this.icon, this.duotone);

  final String name;
  final IconData icon;
  final SolarDuotoneIconData? duotone;
}

List<_Entry> _entriesFor(SolarIconStyle style) {
  if (style.isDuotone) {
    final map = style == SolarIconStyle.boldDuotone
        ? solarBoldDuotoneIcons
        : solarLineDuotoneIcons;
    return <_Entry>[
      for (final e in map.entries) _Entry(e.key, e.value.primary, e.value),
    ];
  }
  final map = switch (style) {
    SolarIconStyle.linear => solarLinearIcons,
    SolarIconStyle.outline => solarOutlineIcons,
    SolarIconStyle.broken => solarBrokenIcons,
    _ => solarBoldIcons,
  };
  return <_Entry>[for (final e in map.entries) _Entry(e.key, e.value, null)];
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({required this.onToggleTheme, super.key});

  final VoidCallback onToggleTheme;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  SolarIconStyle _style = SolarIconStyle.boldDuotone;
  String _query = '';
  double _size = 32;

  // Recomputed only when the style or query changes. Dragging the size slider
  // rebuilds every frame, and re-filtering 1,300 icons each time would jank.
  late List<_Entry> _all = _entriesFor(_style);
  late List<_Entry> _visible = _all;

  void _setStyle(SolarIconStyle style) {
    if (style == _style) return;
    setState(() {
      _style = style;
      _all = _entriesFor(style);
      _visible = _filter(_all, _query);
    });
  }

  void _setQuery(String query) {
    if (query == _query) return;
    setState(() {
      _query = query;
      _visible = _filter(_all, query);
    });
  }

  static List<_Entry> _filter(List<_Entry> all, String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return all;
    return all.where((e) => e.name.contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = _visible;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: const Text('Solar Icons'),
            actions: <Widget>[
              IconButton(
                tooltip: isDark ? 'Light mode' : 'Dark mode',
                onPressed: widget.onToggleTheme,
                icon: Icon(isDark ? SolarIconsBold.sun : SolarIconsBold.moon),
              ),
              const SizedBox(width: 8),
            ],
            // The controls ride along as part of the app bar rather than as a
            // second pinned sliver, which would have to account for the app
            // bar's overlap itself.
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(_controlsHeight),
              child: _Controls(
                style: _style,
                size: _size,
                count: entries.length,
                onStyle: _setStyle,
                onQuery: _setQuery,
                onSize: (s) => setState(() => _size = s),
              ),
            ),
          ),
          if (entries.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _Empty(query: _query, style: _style),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: _size * 3.6,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.82,
                ),
                itemCount: entries.length,
                itemBuilder: (context, i) => _IconTile(
                  entry: entries[i],
                  style: _style,
                  size: _size,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.style,
    required this.size,
    required this.count,
    required this.onStyle,
    required this.onQuery,
    required this.onSize,
  });

  final SolarIconStyle style;
  final double size;
  final int count;
  final ValueChanged<SolarIconStyle> onStyle;
  final ValueChanged<String> onQuery;
  final ValueChanged<double> onSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: <Widget>[
                for (final s in SolarIconStyle.values) ...<Widget>[
                  ChoiceChip(
                    label: Text(s.label),
                    selected: s == style,
                    onSelected: (_) => onStyle(s),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      onChanged: onQuery,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Search $count icons…',
                        prefixIcon:
                            const Icon(SolarIconsLinear.magnifier, size: 20),
                        border: const OutlineInputBorder(),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(SolarIconsLinear.textCircle,
                    size: 18, color: theme.hintColor),
                SizedBox(
                  width: 120,
                  child: Slider(
                    value: size,
                    min: 16,
                    max: 64,
                    onChanged: onSize,
                  ),
                ),
                SizedBox(
                  width: 34,
                  child: Text('${size.round()}',
                      style: theme.textTheme.labelMedium),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
        ],
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile(
      {required this.entry, required this.style, required this.size});

  final _Entry entry;
  final SolarIconStyle style;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duotone = entry.duotone;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _showDetail(context, entry, style),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (duotone != null)
            SolarDuotoneIcon(duotone,
                size: size, color: theme.colorScheme.primary)
          else
            Icon(entry.icon, size: size, color: theme.colorScheme.primary),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              entry.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style:
                  theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
            ),
          ),
        ],
      ),
    );
  }
}

String _dartName(String solarName) {
  const overrides = <String, String>{'case': 'caseIcon', '4k': 'icon4k'};
  if (overrides.containsKey(solarName)) return overrides[solarName]!;
  final parts =
      solarName.split(RegExp(r'[^A-Za-z0-9]+')).where((p) => p.isNotEmpty);
  return parts.first.toLowerCase() +
      parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
}

String _snippetFor(_Entry entry, SolarIconStyle style) {
  final cls =
      'SolarIcons${style.name[0].toUpperCase()}${style.name.substring(1)}';
  final ref = '$cls.${_dartName(entry.name)}';
  return style.isDuotone ? 'SolarDuotoneIcon($ref)' : 'Icon($ref)';
}

void _showDetail(BuildContext context, _Entry entry, SolarIconStyle style) {
  final snippet = _snippetFor(entry, style);
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final theme = Theme.of(context);
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                for (final s in <double>[20, 32, 48, 72])
                  if (entry.duotone case final d?)
                    SolarDuotoneIcon(d,
                        size: s, color: theme.colorScheme.primary)
                  else
                    Icon(entry.icon, size: s, color: theme.colorScheme.primary),
              ],
            ),
            const SizedBox(height: 24),
            Text(entry.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium),
            Text(
              style.label,
              textAlign: TextAlign.center,
              style:
                  theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: snippet));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied  $snippet')),
                );
                Navigator.pop(context);
              },
              icon: const Icon(SolarIconsLinear.copy, size: 18),
              label: Text(snippet, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      );
    },
  );
}

class _Empty extends StatelessWidget {
  const _Empty({required this.query, required this.style});

  final String query;
  final SolarIconStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SolarDuotoneIcon(SolarIconsLineDuotone.magnifier,
              size: 56, color: theme.hintColor),
          const SizedBox(height: 12),
          Text('No ${style.label} icon matches “$query”',
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
        ],
      ),
    );
  }
}
