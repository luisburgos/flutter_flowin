import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/chips/chip_config.dart';
import 'package:flowin_showcase/pages/chips/chip_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// One preset per variant: the axis a reader picks along first.
const _presets = <FlowinPlaygroundPreset<ChipConfig>>[
  FlowinPlaygroundPreset(
    label: 'Unselected',
    summary: 'The resting state of a filter.',
    config: ChipConfig(),
  ),
  FlowinPlaygroundPreset(
    label: 'Selected',
    summary: 'The active filter in a group.',
    config: ChipConfig(variant: FlowinChipVariant.selected),
  ),
  FlowinPlaygroundPreset(
    label: 'Dimmed',
    summary: 'Unselected but de-emphasised, when a group is inactive.',
    config: ChipConfig(variant: FlowinChipVariant.unselectedDimmed),
  ),
];

/// A playground for [FlowinChip] across every variant and state.
class ChipsPage extends StatefulWidget {
  /// {@macro chips_page}
  const ChipsPage({super.key});

  @override
  State<ChipsPage> createState() => _ChipsPageState();
}

class _ChipsPageState extends State<ChipsPage> {
  ChipConfig _config = const ChipConfig();

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Chips',
      dividedAppBar: true,
      body: FlowinPlayground<ChipConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        // Surface, not the default tint: an unselected chip is a neutral the
        // tint would swallow, the same collision the button pages hit.
        previewBackground: context.colorScheme.surface,
        previewBuilder: (context, config) => FlowinChip(
          variant: config.variant,
          leading: config.hasLeading
              ? FDIcons.done.toIcon(size: FlowinDesignIconSize.sm)
              : null,
          label: const Text('Active'),
          onSelected: config.enabled ? (_) {} : null,
        ),
        knobsBuilder: (context, config, onChanged) =>
            ChipKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
