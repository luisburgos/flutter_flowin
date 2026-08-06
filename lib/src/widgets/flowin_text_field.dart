import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template flowin_text_field}
/// A Flowin text field.
///
/// A *thin* composition over the framework's [TextFormField]. The fill, hint
/// style, content padding, and rounded outline border all come from the
/// theme's `inputDecorationTheme` — not hardcoded here. This wrapper exists
/// only to surface the call-site conveniences the legacy field exposed
/// ([onChanged], [hintText], [maxLines], [inputFormatters], [initialValue]),
/// which are per-instance concerns the theme cannot encode.
/// {@endtemplate}
class FlowinTextField extends StatelessWidget {
  /// {@macro flowin_text_field}
  const FlowinTextField({
    this.initialValue,
    this.onChanged,
    this.hintText,
    this.inputFormatters,
    this.maxLines = 1,
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

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
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      autofocus: autofocus,
      enabled: enabled,
      // Styling (fill, hint, padding, border) comes from inputDecorationTheme.
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
