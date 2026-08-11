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
    final isPrimitive = config.subject == SwatchSubject.swatches;

    final ownsItsSelection = FlowinKnobRelevance.when(
      isRelevant: isPrimitive,
      reason:
          'the picker field owns its selection and always pins a '
          'gradient swatch',
    );
    final exposesNoSize = FlowinKnobRelevance.when(
      isRelevant: isPrimitive,
      reason: 'the picker field exposes no swatch size',
    );

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
        FlowinPlaygroundKnobGroup(
          title: 'State',
          relevantWhen: ownsItsSelection,
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
        FlowinPlaygroundKnobGroup(
          title: 'Size',
          relevantWhen: exposesNoSize,
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
