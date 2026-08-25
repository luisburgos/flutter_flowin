import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

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
/// A thin wrapper over playgrounder's [ScaleKnob]. The Flowin spacing scale is
/// domain data — [SpacingStep] resolving against the theme — so this builds the
/// scale's [ScaleStep] list here, where the theme is in scope, and hands it to
/// the design-system-agnostic knob. That keeps the "a demo cannot quote a stale
/// pixel" property while the knob mechanics live in playgrounder.
class FlowinSpacingKnob extends StatelessWidget {
  /// Creates a spacing knob.
  const FlowinSpacingKnob({
    required this.label,
    required this.value,
    required this.onChanged,
    this.relevantWhen = const KnobRelevance.always(),
    super.key,
  });

  /// The knob's label.
  final String label;

  /// The selected step.
  final SpacingStep value;

  /// Called with the picked step.
  final ValueChanged<SpacingStep> onChanged;

  /// When this knob applies at all.
  final KnobRelevance relevantWhen;

  @override
  Widget build(BuildContext context) {
    // Resolve each step against the theme, so the readout quotes live pixels.
    final steps = [
      for (final step in SpacingStep.values)
        ScaleStep(step.name, step.resolve(context)),
    ];
    final selected = steps[value.index];

    return ScaleKnob(
      label: label,
      value: selected,
      values: steps,
      relevantWhen: relevantWhen,
      // Map the picked ScaleStep back to its SpacingStep by position: the two
      // lists are index-aligned because steps is built from SpacingStep.values.
      onChanged: (picked) =>
          onChanged(SpacingStep.values[steps.indexOf(picked)]),
    );
  }
}
