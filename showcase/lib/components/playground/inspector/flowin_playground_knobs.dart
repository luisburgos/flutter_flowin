import 'package:flutter_flowin/flutter_flowin.dart';

/// A titled group of knobs.
///
/// The heading separates one axis of configuration from another — the switches
/// that toggle a component's parts from the dropdowns that fill its slots —
/// so a long inspector stays scannable.
class FlowinPlaygroundKnobGroup extends StatelessWidget {
  /// {@macro flowin_playground_knob_group}
  const FlowinPlaygroundKnobGroup({
    required this.title,
    required this.children,
    super.key,
  });

  /// The group's heading, rendered in caps.
  final String title;

  /// The knobs in this group.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
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
class FlowinPlaygroundSwitchKnob extends StatelessWidget {
  /// {@macro flowin_playground_switch_knob}
  const FlowinPlaygroundSwitchKnob({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// The knob's label.
  final String label;

  /// Whether the knob is on.
  final bool value;

  /// Called with the new state.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
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

/// A labelled dropdown for a knob with a fixed set of choices.
class FlowinPlaygroundChoiceKnob<T> extends StatelessWidget {
  /// {@macro flowin_playground_choice_knob}
  const FlowinPlaygroundChoiceKnob({
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
    super.key,
  });

  /// The knob's label.
  final String label;

  /// The selected choice.
  final T value;

  /// Every choice, in the order they should appear.
  final List<T> values;

  /// Renders a choice's display text.
  final String Function(T) labelOf;

  /// Called with the picked choice.
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: FlowinDesignSpace.space200,
      children: [
        Text(label, style: context.textTheme.bodyLarge),
        // `isExpanded` so the button takes the space left rather than sizing
        // to its widest item, which is what pushes it past a narrow inspector.
        Expanded(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            borderRadius: BorderRadius.circular(FlowinDesignRadius.radius300),
            items: [
              for (final v in values)
                DropdownMenuItem<T>(value: v, child: Text(labelOf(v))),
            ],
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ],
    );
  }
}
