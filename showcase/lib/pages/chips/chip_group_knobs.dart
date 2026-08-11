import 'package:flowin_showcase/components/flowin_showcase_dropdown.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/pages/chips/chip_group_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The inspector's controls for a [ChipGroupConfig].
class ChipGroupKnobs extends StatelessWidget {
  /// {@macro chip_group_knobs}
  const ChipGroupKnobs({
    required this.config,
    required this.onChanged,
    super.key,
  });

  /// The configuration the knobs reflect.
  final ChipGroupConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<ChipGroupConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        FlowinPlaygroundKnobGroup(
          title: 'Unselected variant',
          children: [
            FlowinShowcaseDropdown<FlowinChipVariant>(
              value: config.unselectedVariant,
              // Selected is what the group applies to the active chip, so
              // offering it here would mean every chip looks selected.
              values: const [
                FlowinChipVariant.unselected,
                FlowinChipVariant.unselectedDimmed,
              ],
              labelOf: (v) => v.name,
              onChanged: (v) =>
                  onChanged(config.copyWith(unselectedVariant: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'Layout',
          children: [
            FlowinPlaygroundSwitchKnob(
              label: 'Scrollable',
              value: config.isScrollable,
              onChanged: (v) => onChanged(config.copyWith(isScrollable: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'Many labels',
              value: config.manyLabels,
              onChanged: (v) => onChanged(config.copyWith(manyLabels: v)),
            ),
          ],
        ),
      ],
    );
  }
}
