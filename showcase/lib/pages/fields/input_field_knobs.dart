import 'package:flowin_showcase/pages/fields/input_field_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

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
        DropdownKnob<InputFieldChild>(
          label: 'Child',
          value: config.child,
          values: InputFieldChild.values,
          labelOf: _childLabel,
          onChanged: (v) => onChanged(config.copyWith(child: v)),
        ),
        KnobGroup(
          title: 'Chrome',
          children: [
            SwitchKnob(
              label: 'Show label',
              value: config.hasLabel,
              onChanged: (v) => onChanged(config.copyWith(hasLabel: v)),
            ),
            SwitchKnob(
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
