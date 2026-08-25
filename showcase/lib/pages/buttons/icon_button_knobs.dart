import 'package:flowin_showcase/pages/buttons/icon_button_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// The inspector's controls for an [IconButtonConfig].
class IconButtonKnobs extends StatelessWidget {
  /// {@macro icon_button_knobs}
  const IconButtonKnobs({
    required this.config,
    required this.onChanged,
    super.key,
  });

  /// The configuration the knobs reflect.
  final IconButtonConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<IconButtonConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        DropdownKnob<FlowinIconButtonVariant>(
          label: 'Variant',
          value: config.variant,
          values: FlowinIconButtonVariant.values,
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
