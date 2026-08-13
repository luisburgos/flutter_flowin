import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// A dropdown for picking one of a fixed set of choices.
///
/// Raw Material underneath: the package has no dropdown, and this is showcase
/// scaffolding for driving demos rather than anything being demonstrated, so
/// it does not warrant inventing one.
///
/// Carries no label. Callers that need one put it above the dropdown — a
/// leading label competes with the selected value for a narrow pane's width,
/// and the value is the part worth reading.
///
/// Pass [relevantWhen] when the choice stops applying while the rest of its
/// group still does — a height to pin when the content is deciding it. Where
/// the whole group drops out instead, scope the group rather than each knob
/// inside it. See [FlowinKnobRelevance] for why hidden and not disabled.
class FlowinShowcaseDropdown<T> extends StatelessWidget {
  /// {@macro flowin_showcase_dropdown}
  const FlowinShowcaseDropdown({
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
    this.relevantWhen = const FlowinKnobRelevance.always(),
    super.key,
  });

  /// When this knob applies at all.
  final FlowinKnobRelevance relevantWhen;

  /// The selected choice.
  final T value;

  /// Every choice, in the order they should appear.
  final List<T> values;

  /// Renders a choice's display text.
  final String Function(T) labelOf;

  /// Called with the picked choice.
  ///
  /// Never called with null: the button's own nullable callback is guarded
  /// here so callers do not each repeat the check.
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    if (!relevantWhen.isRelevant) return const SizedBox.shrink();

    return DropdownButton<T>(
      value: value,
      // Takes the width it is given rather than sizing to its widest item,
      // which is what pushes it past a narrow pane.
      isExpanded: true,
      borderRadius: BorderRadius.circular(FlowinDesignRadius.radius300),
      items: [
        for (final v in values)
          DropdownMenuItem<T>(value: v, child: Text(labelOf(v))),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
