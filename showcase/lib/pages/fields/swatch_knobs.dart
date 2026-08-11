import 'package:flowin_showcase/components/flowin_showcase_dropdown.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/pages/fields/swatch_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Display text for each subject choice.
String _subjectLabel(SwatchSubject subject) => switch (subject) {
  SwatchSubject.swatches => 'Swatches',
  SwatchSubject.pickerField => 'Picker field',
};

/// The inspector's controls for a [SwatchConfig].
class SwatchKnobs extends StatelessWidget {
  /// {@macro swatch_knobs}
  const SwatchKnobs({required this.config, required this.onChanged, super.key});

  /// The configuration the knobs reflect.
  final SwatchConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<SwatchConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    // The picker field owns its selection, always pins a gradient swatch, and
    // exposes no swatch size, so every knob below would drive nothing while it
    // is the subject. Hidden rather than disabled: a knob that is present but
    // inert reads as a bug in the component.
    final isPrimitive = config.subject == SwatchSubject.swatches;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        FlowinPlaygroundKnobGroup(
          title: 'Subject',
          children: [
            FlowinShowcaseDropdown<SwatchSubject>(
              value: config.subject,
              values: SwatchSubject.values,
              labelOf: _subjectLabel,
              onChanged: (v) => onChanged(config.copyWith(subject: v)),
            ),
          ],
        ),
        if (isPrimitive)
          FlowinPlaygroundKnobGroup(
            title: 'State',
            children: [
              FlowinPlaygroundSwitchKnob(
                label: 'Selected',
                value: config.selected,
                onChanged: (v) => onChanged(config.copyWith(selected: v)),
              ),
              FlowinPlaygroundSwitchKnob(
                label: 'Show gradient swatch',
                value: config.showGradient,
                onChanged: (v) => onChanged(config.copyWith(showGradient: v)),
              ),
            ],
          ),
        if (isPrimitive)
          FlowinPlaygroundKnobGroup(
            title: 'Size',
            children: [
              FlowinPlaygroundSwitchKnob(
                label: 'Large',
                value: config.large,
                onChanged: (v) => onChanged(config.copyWith(large: v)),
              ),
            ],
          ),
      ],
    );
  }
}
