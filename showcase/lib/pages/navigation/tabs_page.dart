import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/navigation/tabs_config.dart';
import 'package:flowin_showcase/pages/navigation/tabs_knobs.dart';
import 'package:flowin_showcase/pages/navigation/tabs_preview.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The width the bar is previewed at.
///
/// Narrow enough that the two layouts actually differ: at full stage width
/// eight tabs still fit on one line, so the scrollable knob looks inert and a
/// long label never has to ellipsize.
const _tabsMaxWidth = 420.0;

/// One preset per layout decision a caller is actually making.
const _presets = <FlowinPlaygroundPreset<TabsConfig>>[
  FlowinPlaygroundPreset(
    label: 'Fixed',
    summary: 'A handful of peers, each given an equal share of the width.',
    config: TabsConfig(),
  ),
  FlowinPlaygroundPreset(
    label: 'Scrollable',
    summary: 'More sections than fit, each keeping its natural width.',
    config: TabsConfig(count: TabCount.many, isScrollable: true),
  ),
  FlowinPlaygroundPreset(
    label: 'Labels only',
    summary: 'When the labels are clear enough that glyphs add nothing.',
    config: TabsConfig(hasIcons: false),
  ),
  FlowinPlaygroundPreset(
    label: 'Crowded',
    summary: 'A long label on a fixed bar, where it has to ellipsize.',
    config: TabsConfig(longLabel: true, hasIcons: false),
  ),
];

/// A playground for [FlowinTabs] as page content.
///
/// Unlike the app bars, this one is not chrome: it is a bar a caller places in
/// a body, so a preview stage shows it the way a real caller would see it.
class TabsPage extends StatefulWidget {
  /// {@macro tabs_page}
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  TabsConfig _config = const TabsConfig();

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Tabs',
      dividedAppBar: true,
      body: FlowinPlayground<TabsConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        previewMaxWidth: _tabsMaxWidth,
        // Surface, not the default tint: the bar sits in a card whose themed
        // fill is the tint's own colour, so the card would vanish and the bar
        // would read as floating on the stage.
        previewBackground: context.colorScheme.surface,
        previewBuilder: (context, config) => TabsDemo(config: config),
        knobsBuilder: (context, config, onChanged) =>
            TabsKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
