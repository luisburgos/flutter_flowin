import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/chips/chip_group_config.dart';
import 'package:flowin_showcase/pages/chips/chip_group_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The width a chip row is previewed at.
///
/// Narrow enough that the scrollable and wrapped layouts actually differ: at
/// full stage width every label fits on one line and the knob looks inert.
const _groupMaxWidth = 380.0;

const _fewLabels = ['All', 'Active', 'Paused'];
const _many = ['All', 'Active', 'Paused', 'Archived', 'Draft', 'Shared'];

/// The two layouts, which is what a reader is choosing between.
const _presets = <FlowinPlaygroundPreset<ChipGroupConfig>>[
  FlowinPlaygroundPreset(
    label: 'Scrollable',
    summary: 'One line that scrolls — a filter bar above a list.',
    config: ChipGroupConfig(),
  ),
  FlowinPlaygroundPreset(
    label: 'Wrapped',
    summary: 'Every chip stays visible, on as many lines as it takes.',
    config: ChipGroupConfig(isScrollable: false),
  ),
  FlowinPlaygroundPreset(
    label: 'Dimmed',
    summary: 'Unselected chips de-emphasised against the active one.',
    config: ChipGroupConfig(
      unselectedVariant: FlowinChipVariant.unselectedDimmed,
    ),
  ),
];

/// A playground for [FlowinChipGroup]: a row of chips with one selected.
class ChipGroupsPage extends StatefulWidget {
  /// {@macro chip_groups_page}
  const ChipGroupsPage({super.key});

  @override
  State<ChipGroupsPage> createState() => _ChipGroupsPageState();
}

class _ChipGroupsPageState extends State<ChipGroupsPage> {
  ChipGroupConfig _config = const ChipGroupConfig();

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Chip groups',
      dividedAppBar: true,
      body: FlowinPlayground<ChipGroupConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        previewMaxWidth: _groupMaxWidth,
        previewBackground: context.colorScheme.surface,
        previewBuilder: (context, config) => FlowinChipGroup(
          // Keyed on the layout so the group rebuilds its controller rather
          // than carrying a selection across a structural change.
          key: ValueKey('${config.isScrollable}-${config.manyLabels}'),
          labels: config.manyLabels ? _many : _fewLabels,
          initialSelectedIndex: 1,
          isScrollable: config.isScrollable,
          unselectedVariant: config.unselectedVariant,
          padding: EdgeInsets.zero,
          onSelected: (_) {},
        ),
        knobsBuilder: (context, config, onChanged) =>
            ChipGroupKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
