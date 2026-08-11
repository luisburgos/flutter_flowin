import 'package:flutter_flowin/flutter_flowin.dart';

/// Which child fills a [FlowinInputField]'s slot in the preview.
///
/// The field takes an arbitrary child, so the demo has to pick a few concrete
/// ones. These three are the shapes that actually appear in callers: a value
/// read back with a glyph, an interactive control, and plain prose.
enum InputFieldChild {
  /// An icon beside a value — the read-back shape.
  iconAndValue,

  /// A chip group, standing in for any interactive control.
  chipGroup,

  /// Plain text, the minimum a slot can hold.
  text,
}

/// The state of the [FlowinInputField] preview.
///
/// Value equality is what lets the playground tell a preset from a custom
/// configuration, so it is a requirement of the type rather than a
/// convenience.
@immutable
class InputFieldConfig {
  /// {@macro input_field_config}
  const InputFieldConfig({
    this.child = InputFieldChild.iconAndValue,
    this.hasLabel = true,
    this.surface = true,
  });

  /// What sits in the field's child slot.
  final InputFieldChild child;

  /// Whether a label is stacked above the surface.
  ///
  /// A null `label` is what drops the label row, so the knob toggles whether
  /// a label is passed at all rather than passing an empty string.
  final bool hasLabel;

  /// Whether the child is wrapped in the bordered field surface.
  final bool surface;

  /// A copy with the given fields replaced.
  InputFieldConfig copyWith({
    InputFieldChild? child,
    bool? hasLabel,
    bool? surface,
  }) => InputFieldConfig(
    child: child ?? this.child,
    hasLabel: hasLabel ?? this.hasLabel,
    surface: surface ?? this.surface,
  );

  @override
  bool operator ==(Object other) =>
      other is InputFieldConfig &&
      other.child == child &&
      other.hasLabel == hasLabel &&
      other.surface == surface;

  @override
  int get hashCode => Object.hash(child, hasLabel, surface);
}
