import 'package:flowin_showcase/components/flowin_spacing_knob.dart';
import 'package:flowin_showcase/pages/chips/chip_group_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

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
    final hasWrappedRows = KnobRelevance.when(
      isRelevant: !config.isScrollable,
      reason:
          'a scrollable row is a single line, so there are no wrapped rows '
          'to space or align',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        DropdownKnob<FlowinChipVariant>(
          label: 'Unselected variant',
          value: config.unselectedVariant,
          // Selected is what the group applies to the active chip, so
          // offering it here would mean every chip looks selected.
          values: const [
            FlowinChipVariant.unselected,
            FlowinChipVariant.unselectedDimmed,
          ],
          labelOf: (v) => v.name,
          onChanged: (v) => onChanged(config.copyWith(unselectedVariant: v)),
        ),
        KnobGroup(
          title: 'Layout',
          children: [
            SwitchKnob(
              label: 'Scrollable',
              value: config.isScrollable,
              onChanged: (v) => onChanged(config.copyWith(isScrollable: v)),
            ),
            SwitchKnob(
              label: 'Many labels',
              value: config.manyLabels,
              onChanged: (v) => onChanged(config.copyWith(manyLabels: v)),
            ),
          ],
        ),
        KnobGroup(
          title: 'Spacing',
          children: [
            FlowinSpacingKnob(
              label: 'Padding',
              value: config.padding,
              onChanged: (v) => onChanged(config.copyWith(padding: v)),
            ),
            FlowinSpacingKnob(
              label: 'Chip spacing',
              value: config.chipSpacing,
              onChanged: (v) => onChanged(config.copyWith(chipSpacing: v)),
            ),
            FlowinSpacingKnob(
              label: 'Run spacing',
              value: config.runSpacing,
              relevantWhen: hasWrappedRows,
              onChanged: (v) => onChanged(config.copyWith(runSpacing: v)),
            ),
          ],
        ),
        DropdownKnob<WrapAlignment>(
          label: 'Wrap alignment',
          relevantWhen: hasWrappedRows,
          value: config.wrapAlignment,
          values: WrapAlignment.values,
          labelOf: (v) => v.name,
          onChanged: (v) => onChanged(config.copyWith(wrapAlignment: v)),
        ),
      ],
    );
  }
}
