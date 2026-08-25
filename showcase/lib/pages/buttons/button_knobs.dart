import 'package:flowin_showcase/pages/buttons/button_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// The inspector's controls for a [ButtonConfig].
class ButtonKnobs extends StatelessWidget {
  /// {@macro button_knobs}
  const ButtonKnobs({required this.config, required this.onChanged, super.key});

  /// The configuration the knobs reflect.
  final ButtonConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<ButtonConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        DropdownKnob<FlowinButtonVariant>(
          label: 'Variant',
          value: config.variant,
          values: FlowinButtonVariant.values,
          labelOf: (v) => v.name,
          onChanged: (v) => onChanged(config.copyWith(variant: v)),
        ),
        DropdownKnob<FlowinButtonSize>(
          label: 'Size',
          value: config.size,
          values: FlowinButtonSize.values,
          labelOf: (v) => v.name,
          onChanged: (v) => onChanged(config.copyWith(size: v)),
        ),
        KnobGroup(
          title: 'State',
          children: [
            SwitchKnob(
              label: 'Show icon',
              value: config.hasIcon,
              onChanged: (v) => onChanged(config.copyWith(hasIcon: v)),
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
