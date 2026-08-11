import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
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
/// A slider rather than a dropdown, because these values are an *ordered
/// scale* and a dropdown presents its choices as an unordered set. The
/// ordering is the part worth showing: a reader wants to sweep the scale and
/// watch where a layout starts to break, which picking one item at a time
/// discourages.
///
/// Snapped to the scale's own steps rather than free pixels. A playground that
/// let a caller dial 17px would be demonstrating a value the design system
/// does not have.
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
    if (!relevantWhen.isRelevant) return const SizedBox.shrink();

    const steps = SpacingStep.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The token name and its resolved value together: the name alone does
        // not say how big md is, and the number alone does not say which step
        // a caller would write.
        Row(
          children: [
            Expanded(child: Text(label, style: context.textTheme.bodyLarge)),
            Text(
              '${value.name} — ${value.resolve(context).toInt()}px',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        // Raw Material, deliberately, like the other knobs: the package has no
        // slider, and a knob is scaffolding for driving a demo rather than
        // anything being demonstrated.
        //
        // Divisions are one fewer than the steps: they count the intervals
        // between positions, not the positions themselves, so passing the step
        // count would put a detent between every pair of real values.
        Slider(
          value: value.index.toDouble(),
          max: (steps.length - 1).toDouble(),
          divisions: steps.length - 1,
          label: value.name,
          onChanged: (v) => onChanged(steps[v.round()]),
        ),
      ],
    );
  }
}
