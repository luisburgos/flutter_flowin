import 'package:flowin_showcase/components/flowin_showcase_dropdown.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/pages/buttons/icon_button_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

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
        FlowinPlaygroundKnobGroup(
          title: 'Variant',
          children: [
            FlowinShowcaseDropdown<FlowinIconButtonVariant>(
              value: config.variant,
              values: FlowinIconButtonVariant.values,
              labelOf: (v) => v.name,
              onChanged: (v) => onChanged(config.copyWith(variant: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'Size',
          children: [
            FlowinShowcaseDropdown<FlowinButtonSize>(
              value: config.size,
              values: FlowinButtonSize.values,
              labelOf: (v) => v.name,
              onChanged: (v) => onChanged(config.copyWith(size: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'State',
          children: [
            FlowinPlaygroundSwitchKnob(
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
