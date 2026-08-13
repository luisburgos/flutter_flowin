import 'package:equatable/equatable.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The state of the text-field preview.
///
/// Covers both [FlowinTextField] and [FlowinLabeledTextField]: the latter is
/// the former with a stacked label, forwarding every other parameter
/// unchanged, so [hasLabel] is the axis that picks between the two classes
/// rather than a styling option.
///
/// Value equality is what lets the playground tell a preset from a custom
/// configuration, so it is a requirement of the type rather than a
/// convenience.
class TextFieldConfig extends Equatable {
  /// {@macro text_field_config}
  const TextFieldConfig({
    this.hasLabel = true,
    this.hasInitialValue = true,
    this.hasHint = false,
    this.multiline = false,
    this.enabled = true,
  });

  /// Whether a label is stacked above the field.
  ///
  /// True builds a [FlowinLabeledTextField]; false builds the bare
  /// [FlowinTextField].
  final bool hasLabel;

  /// Whether the field starts with a value in it.
  final bool hasInitialValue;

  /// Whether a placeholder is shown.
  ///
  /// Only visible while the field is empty, so it reads as inert alongside
  /// [hasInitialValue].
  final bool hasHint;

  /// Whether the field grows to several lines.
  final bool multiline;

  /// Whether the field accepts input.
  final bool enabled;

  /// A copy with the given fields replaced.
  TextFieldConfig copyWith({
    bool? hasLabel,
    bool? hasInitialValue,
    bool? hasHint,
    bool? multiline,
    bool? enabled,
  }) => TextFieldConfig(
    hasLabel: hasLabel ?? this.hasLabel,
    hasInitialValue: hasInitialValue ?? this.hasInitialValue,
    hasHint: hasHint ?? this.hasHint,
    multiline: multiline ?? this.multiline,
    enabled: enabled ?? this.enabled,
  );

  @override
  List<Object?> get props => [
    hasLabel,
    hasInitialValue,
    hasHint,
    multiline,
    enabled,
  ];
}
