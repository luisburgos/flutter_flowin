import 'package:flowin_showcase/components/flowin_spacing_knob.dart';
import 'package:flowin_showcase/pages/chips/chip_pager_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// The inspector's controls for a [ChipPagerConfig].
class ChipPagerKnobs extends StatelessWidget {
  /// {@macro chip_pager_knobs}
  const ChipPagerKnobs({
    required this.config,
    required this.onChanged,
    super.key,
  });

  /// The configuration the knobs reflect.
  final ChipPagerConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<ChipPagerConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        KnobGroup(
          title: 'Chips',
          children: [
            DropdownKnob<FlowinChipVariant>(
              label: 'Unselected variant',
              value: config.unselectedVariant,
              // Selected is what the pager applies to the active chip, so
              // offering it here would mean every chip looks selected.
              values: const [
                FlowinChipVariant.unselected,
                FlowinChipVariant.unselectedDimmed,
              ],
              labelOf: (v) => v.name,
              onChanged: (v) =>
                  onChanged(config.copyWith(unselectedVariant: v)),
            ),
            FlowinSpacingKnob(
              label: 'Row padding',
              value: config.chipsPadding,
              onChanged: (v) => onChanged(config.copyWith(chipsPadding: v)),
            ),
          ],
        ),
        KnobGroup(
          title: 'Layout',
          children: [
            SwitchKnob(
              label: 'Scrollable chips',
              value: config.isScrollable,
              onChanged: (v) => onChanged(config.copyWith(isScrollable: v)),
            ),
            SwitchKnob(
              label: 'Divider',
              value: config.showDivider,
              onChanged: (v) => onChanged(config.copyWith(showDivider: v)),
            ),
          ],
        ),
        KnobGroup(
          title: 'Behaviour',
          children: [
            SwitchKnob(
              label: 'Keep page state alive',
              value: config.keepPagesAlive,
              onChanged: (v) => onChanged(config.copyWith(keepPagesAlive: v)),
            ),
          ],
        ),
      ],
    );
  }
}
