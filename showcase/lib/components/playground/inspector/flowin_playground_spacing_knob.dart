import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_step_knob.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// A step of the Flowin spacing scale, as a knob picks it.
///
/// The scale lives on [FlowinSpacing] as named fields rather than as an enum,
/// so there is nothing there to iterate or order. This names the positions so
/// a knob can step along them, and resolves each against the theme rather than
/// hardcoding pixels — a demo that quotes 16 would go stale the moment the
/// scale moved.
enum SpacingStep {
  /// No space at all.
  none,

  /// The tightest step above zero.
  xxs,

  /// A tight step, for dense rows.
  xs,

  /// A step between tight and default.
  sm,

  /// The default step most surfaces use.
  md,

  /// A roomy step.
  lg,

  /// A generous step.
  xl,

  /// The widest step on the scale.
  xxl;

  /// This step's value in the current theme.
  double resolve(BuildContext context) {
    final spacing = context.spacing;
    return switch (this) {
      SpacingStep.none => spacing.none,
      SpacingStep.xxs => spacing.xxs,
      SpacingStep.xs => spacing.xs,
      SpacingStep.sm => spacing.sm,
      SpacingStep.md => spacing.md,
      SpacingStep.lg => spacing.lg,
      SpacingStep.xl => spacing.xl,
      SpacingStep.xxl => spacing.xxl,
    };
  }

  /// This step as an [EdgeInsets] on every side.
  EdgeInsets all(BuildContext context) => EdgeInsets.all(resolve(context));
}

/// A knob that steps along the Flowin spacing scale.
///
/// A thin wrapper over [FlowinPlaygroundStepKnob]: the slider mechanics are
/// the same for any ordered scale, and only the readout is spacing-specific.
/// The steps resolve against the theme rather than quoting constants, so a
/// demo cannot go stale if the scale moves.
class FlowinPlaygroundSpacingKnob extends StatelessWidget {
  /// {@macro flowin_playground_spacing_knob}
  const FlowinPlaygroundSpacingKnob({
    required this.label,
    required this.value,
    required this.onChanged,
    this.relevantWhen = const FlowinKnobRelevance.always(),
    super.key,
  });

  /// The knob's label.
  final String label;

  /// The selected step.
  final SpacingStep value;

  /// Called with the picked step.
  final ValueChanged<SpacingStep> onChanged;

  /// When this knob applies at all.
  final FlowinKnobRelevance relevantWhen;

  @override
  Widget build(BuildContext context) {
    return FlowinPlaygroundStepKnob<SpacingStep>(
      label: label,
      value: value,
      values: SpacingStep.values,
      // Resolved here rather than in the generic knob: only a spacing step
      // knows it has a themed value to look up.
      labelOf: (step) => '${step.name} — ${step.resolve(context).toInt()}px',
      relevantWhen: relevantWhen,
      onChanged: onChanged,
    );
  }
}
