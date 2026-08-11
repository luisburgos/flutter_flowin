import 'package:flutter_flowin/flutter_flowin.dart';

/// Why a knob or group is not shown for the current configuration.
///
/// A knob is scoped out when the configuration has made it drive nothing: a
/// swatch size on a subject that exposes none, a foreground preference on a
/// fill that is never resolved against. Such a knob is **hidden rather than
/// disabled**, because a control that is present but inert reads as a bug in
/// the component being demonstrated rather than as a fact about it.
///
/// The reason is carried in code rather than left to a comment beside an `if`,
/// so a reader can tell a deliberate scoping from an accidental one, and so
/// the rule is stated once instead of restated at each site.
@immutable
class FlowinKnobRelevance {
  /// Scopes a knob to configurations where it drives something.
  ///
  /// [reason] completes "hidden because…" and describes the *component's*
  /// constraint, not the widget tree — "the picker field exposes no swatch
  /// size", not "the size knob is hidden".
  const FlowinKnobRelevance.when({
    required this.isRelevant,
    required this.reason,
  });

  /// A knob that always drives something.
  const FlowinKnobRelevance.always() : isRelevant = true, reason = '';

  /// Whether the knob drives anything in the current configuration.
  final bool isRelevant;

  /// Why it does not, when it does not.
  final String reason;
}

/// A titled group of knobs.
///
/// The heading separates one axis of configuration from another — the switches
/// that toggle a component's parts from the dropdowns that fill its slots —
/// so a long inspector stays scannable.
///
/// Pass [relevantWhen] when the whole group stops applying to some
/// configurations; the group then renders nothing rather than a set of inert
/// controls. See [FlowinKnobRelevance] for why hidden and not disabled.
class FlowinPlaygroundKnobGroup extends StatelessWidget {
  /// {@macro flowin_playground_knob_group}
  const FlowinPlaygroundKnobGroup({
    required this.title,
    required this.children,
    this.relevantWhen = const FlowinKnobRelevance.always(),
    super.key,
  });

  /// The group's heading, rendered in caps.
  final String title;

  /// The knobs in this group.
  final List<Widget> children;

  /// When this group applies at all.
  final FlowinKnobRelevance relevantWhen;

  @override
  Widget build(BuildContext context) {
    if (!relevantWhen.isRelevant) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        ...children,
      ],
    );
  }
}

/// A labelled switch for a boolean knob.
///
/// Raw Material, deliberately: the package has no switch, and a knob is
/// scaffolding for driving a demo rather than anything being demonstrated.
///
/// Pass [relevantWhen] when this one knob stops applying while the rest of its
/// group still does. See [FlowinKnobRelevance] for why hidden and not
/// disabled.
class FlowinPlaygroundSwitchKnob extends StatelessWidget {
  /// {@macro flowin_playground_switch_knob}
  const FlowinPlaygroundSwitchKnob({
    required this.label,
    required this.value,
    required this.onChanged,
    this.relevantWhen = const FlowinKnobRelevance.always(),
    super.key,
  });

  /// The knob's label.
  final String label;

  /// Whether the knob is on.
  final bool value;

  /// Called with the new state.
  final ValueChanged<bool> onChanged;

  /// When this knob applies at all.
  final FlowinKnobRelevance relevantWhen;

  @override
  Widget build(BuildContext context) {
    if (!relevantWhen.isRelevant) return const SizedBox.shrink();

    return Row(
      spacing: FlowinDesignSpace.space200,
      children: [
        Switch(value: value, onChanged: onChanged),
        // Takes the width left rather than its natural size: the inspector is
        // narrow, and a label long enough to exceed it would otherwise
        // overflow the row instead of wrapping.
        Expanded(child: Text(label, style: context.textTheme.bodyLarge)),
      ],
    );
  }
}
