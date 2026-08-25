import 'package:flowin_showcase/pages/fields/swatch_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

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

    final ownsItsSelection = KnobRelevance.when(
      isRelevant: isPrimitive,
      reason:
          'the picker field owns its selection and always pins a '
          'gradient swatch',
    );
    final exposesNoSize = KnobRelevance.when(
      isRelevant: isPrimitive,
      reason: 'the picker field exposes no swatch size',
    );
    final ringExists = KnobRelevance.when(
      isRelevant: isPrimitive && config.selected,
      reason:
          'an unselected swatch is a full disc — there is no ring or gap to '
          'size',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        DropdownKnob<SwatchSubject>(
          label: 'Subject',
          value: config.subject,
          values: SwatchSubject.values,
          labelOf: _subjectLabel,
          onChanged: (v) => onChanged(config.copyWith(subject: v)),
        ),
        KnobGroup(
          title: 'State',
          relevantWhen: ownsItsSelection,
          children: [
            SwitchKnob(
              label: 'Selected',
              value: config.selected,
              onChanged: (v) => onChanged(config.copyWith(selected: v)),
            ),
            SwitchKnob(
              label: 'Show gradient swatch',
              value: config.showGradient,
              onChanged: (v) => onChanged(config.copyWith(showGradient: v)),
            ),
          ],
        ),
        KnobGroup(
          title: 'Size',
          relevantWhen: exposesNoSize,
          children: [
            // A slider, not a switch: the ring and gap are fixed token widths
            // that do not scale with the swatch, so sweeping the diameter is
            // how a reader watches the selection ring go from dominant to
            // hairline. Two hardcoded sizes showed only the endpoints.
            StepKnob<SwatchSize>(
              label: 'Diameter',
              value: config.size,
              values: SwatchSize.values,
              labelOf: (v) => '${v.name} — ${v.value.toInt()}px',
              onChanged: (v) => onChanged(config.copyWith(size: v)),
            ),
          ],
        ),
        // The ring's anatomy. These are fixed token widths that do not scale
        // with the swatch — which is why the diameter slider reads differently
        // at every step, and why sweeping these is the other half of that
        // demonstration.
        KnobGroup(
          title: 'Selection ring',
          relevantWhen: ringExists,
          children: [
            StepKnob<BorderStep>(
              label: 'Ring width',
              value: config.ringWidth,
              values: BorderStep.values,
              labelOf: (v) => '${v.name} — ${v.value.toInt()}px',
              onChanged: (v) => onChanged(config.copyWith(ringWidth: v)),
            ),
            StepKnob<BorderStep>(
              label: 'Gap width',
              value: config.gapWidth,
              values: BorderStep.values,
              labelOf: (v) => '${v.name} — ${v.value.toInt()}px',
              onChanged: (v) => onChanged(config.copyWith(gapWidth: v)),
            ),
          ],
        ),
      ],
    );
  }
}
