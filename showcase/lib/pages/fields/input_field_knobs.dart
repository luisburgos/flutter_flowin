import 'package:flowin_showcase/components/flowin_showcase_dropdown.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/pages/fields/input_field_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Display text for each child choice.
String _childLabel(InputFieldChild child) => switch (child) {
  InputFieldChild.iconAndValue => 'Icon and value',
  InputFieldChild.chipGroup => 'Chip group',
  InputFieldChild.text => 'Text',
};

/// The inspector's controls for an [InputFieldConfig].
class InputFieldKnobs extends StatelessWidget {
  /// {@macro input_field_knobs}
  const InputFieldKnobs({
    required this.config,
    required this.onChanged,
    super.key,
  });

  /// The configuration the knobs reflect.
  final InputFieldConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<InputFieldConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        FlowinPlaygroundKnobGroup(
          title: 'Child',
          children: [
            FlowinShowcaseDropdown<InputFieldChild>(
              value: config.child,
              values: InputFieldChild.values,
              labelOf: _childLabel,
              onChanged: (v) => onChanged(config.copyWith(child: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'Chrome',
          children: [
            FlowinPlaygroundSwitchKnob(
              label: 'Show label',
              value: config.hasLabel,
              onChanged: (v) => onChanged(config.copyWith(hasLabel: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'Bordered surface',
              value: config.surface,
              onChanged: (v) => onChanged(config.copyWith(surface: v)),
            ),
          ],
        ),
      ],
    );
  }
}
