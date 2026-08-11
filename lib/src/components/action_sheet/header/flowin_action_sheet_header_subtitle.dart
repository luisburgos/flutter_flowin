import 'package:flutter/material.dart';

/// {@template flowin_action_sheet_header_subtitle}
/// The action sheet's subtitle, rendered at body rank in the variant color.
///
/// Always sits in the header's supporting block, directly beneath the title.
/// {@endtemplate}
class FlowinActionSheetHeaderSubtitle extends StatelessWidget {
  /// {@macro flowin_action_sheet_header_subtitle}
  const FlowinActionSheetHeaderSubtitle(this.subtitle, {super.key});

  /// The subtitle text.
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      subtitle,
      style: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
