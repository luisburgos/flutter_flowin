import 'package:flowin_showcase/pages/fields/text_field_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// The inspector's controls for a [TextFieldConfig].
class TextFieldKnobs extends StatelessWidget {
  /// {@macro text_field_knobs}
  const TextFieldKnobs({
    required this.config,
    required this.onChanged,
    super.key,
  });

  /// The configuration the knobs reflect.
  final TextFieldConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<TextFieldConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        KnobGroup(
          title: 'Label',
          children: [
            SwitchKnob(
              label: 'Show label',
              value: config.hasLabel,
              onChanged: (v) => onChanged(config.copyWith(hasLabel: v)),
            ),
          ],
        ),
        KnobGroup(
          title: 'Content',
          children: [
            SwitchKnob(
              label: 'Initial value',
              value: config.hasInitialValue,
              onChanged: (v) => onChanged(config.copyWith(hasInitialValue: v)),
            ),
            SwitchKnob(
              label: 'Hint text',
              value: config.hasHint,
              onChanged: (v) => onChanged(config.copyWith(hasHint: v)),
            ),
            SwitchKnob(
              label: 'Multiline',
              value: config.multiline,
              onChanged: (v) => onChanged(config.copyWith(multiline: v)),
            ),
          ],
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
