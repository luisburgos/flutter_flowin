import 'package:flowin_showcase/components/flowin_showcase_dropdown.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_step_knob.dart';
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
            // A slider, not a switch: the ring and gap are fixed token widths
            // that do not scale with the swatch, so sweeping the diameter is
            // how a reader watches the selection ring go from dominant to
            // hairline. Two hardcoded sizes showed only the endpoints.
            FlowinPlaygroundStepKnob<SwatchSize>(
              label: 'Diameter',
              value: config.size,
              values: SwatchSize.values,
              labelOf: (v) => '${v.name} — ${v.value.toInt()}px',
              onChanged: (v) => onChanged(config.copyWith(size: v)),
            ),
          ],
        ),
      ],
    );
  }
}
