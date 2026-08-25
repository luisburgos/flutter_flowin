import 'package:flowin_showcase/pages/buttons/item_button_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// The inspector's controls for an [ItemButtonConfig].
class ItemButtonKnobs extends StatelessWidget {
  /// {@macro item_button_knobs}
  const ItemButtonKnobs({
    required this.config,
    required this.onChanged,
    super.key,
  });

  /// The configuration the knobs reflect.
  final ItemButtonConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<ItemButtonConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        DropdownKnob<FlowinItemButtonVariant>(
          label: 'Variant',
          value: config.variant,
          values: FlowinItemButtonVariant.values,
          labelOf: (v) => v.name,
          onChanged: (v) => onChanged(config.copyWith(variant: v)),
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
