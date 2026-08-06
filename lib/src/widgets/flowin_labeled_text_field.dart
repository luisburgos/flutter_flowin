import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:flutter_flowin/src/widgets/flowin_input_field.dart';
import 'package:flutter_flowin/src/widgets/flowin_text_field.dart';

/// {@template flowin_labeled_text_field}
/// A convenience composition: a [label] **stacked above** a [FlowinTextField].
///
/// This is an opt-in shorthand for the common labeled-input pattern. The label
/// renders on its own line above the field. Field behavior (value, hint,
/// formatters, enabled state, change callback) is forwarded to the composed
/// [FlowinTextField] unchanged — this widget adds presentation only.
///
/// Note: v1 intentionally uses a stacked (label-above) layout rather than the
/// legacy bundled-label *sidebar*.
/// {@endtemplate}
class FlowinLabeledTextField extends StatelessWidget {
  /// {@macro flowin_labeled_text_field}
  const FlowinLabeledTextField({
    this.label,
    this.initialValue,
    this.onChanged,
    this.hintText,
    this.inputFormatters,
    this.maxLines = 1,
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

  /// The label shown above the field. When null, no label row is rendered.
  final String? label;

  /// The initial value of the field.
  final String? initialValue;

  /// Called whenever the value changes.
  final ValueChanged<String>? onChanged;

  /// Placeholder text shown when the field is empty.
  final String? hintText;

  /// Formatters applied to the input.
  final List<TextInputFormatter>? inputFormatters;

  /// The maximum number of lines. Defaults to a single line.
  final int maxLines;

  /// Whether the field should be focused on first build.
  final bool autofocus;

  /// Whether the field is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // The stacked label, its gap and its text style all live in
    // FlowinInputField; this only fills the child slot. `surface: false`
    // because FlowinTextField already draws the field border and fill from
    // inputDecorationTheme.
    return FlowinInputField(
      label: label,
      surface: false,
      child: FlowinTextField(
        initialValue: initialValue,
        onChanged: onChanged,
        hintText: hintText,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        autofocus: autofocus,
        enabled: enabled,
      ),
    );
  }
}
