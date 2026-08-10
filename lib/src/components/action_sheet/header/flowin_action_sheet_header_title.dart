import 'package:flutter/material.dart';

/// {@template flowin_action_sheet_header_title}
/// The action sheet's title, rendered at headline rank.
///
/// The rank travels with the title rather than with the region hosting it: the
/// title reads the same whether it sits in the header bar or has been displaced
/// into the supporting block by an icon.
///
/// Internal to the action sheet: public so it can live in its own file, but
/// deliberately absent from the package's export barrel.
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
