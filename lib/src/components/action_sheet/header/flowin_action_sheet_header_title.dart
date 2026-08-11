import 'package:flutter/material.dart';

/// {@template flowin_action_sheet_header_title}
/// The action sheet's title, rendered at headline rank.
///
/// The rank travels with the title, not with the region hosting it, so the
/// title reads the same in the bar or displaced into the supporting block.
/// {@endtemplate}
class FlowinActionSheetHeaderTitle extends StatelessWidget {
  /// {@macro flowin_action_sheet_header_title}
  const FlowinActionSheetHeaderTitle(this.title, {super.key});

  /// The title text.
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(title, style: textTheme.headlineSmall);
  }
}
