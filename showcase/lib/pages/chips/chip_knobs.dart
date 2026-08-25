import 'package:flowin_showcase/pages/chips/chip_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// The inspector's controls for a [ChipConfig].
class ChipKnobs extends StatelessWidget {
  /// {@macro chip_knobs}
  const ChipKnobs({required this.config, required this.onChanged, super.key});

  /// The configuration the knobs reflect.
  final ChipConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<ChipConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        DropdownKnob<FlowinChipVariant>(
          label: 'Variant',
          value: config.variant,
          values: FlowinChipVariant.values,
          labelOf: (v) => v.name,
          onChanged: (v) => onChanged(config.copyWith(variant: v)),
        ),
        KnobGroup(
          title: 'State',
          children: [
            SwitchKnob(
              label: 'Show leading',
              value: config.hasLeading,
              onChanged: (v) => onChanged(config.copyWith(hasLeading: v)),
            ),
            SwitchKnob(
              label: 'Enabled',
              value: config.enabled,
              onChanged: (v) => onChanged(config.copyWith(enabled: v)),
            ),
          ],
        ),
      ],
    );
  }
}
