import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/components/action_sheet/header/flowin_action_sheet_header_bar.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// {@template flowin_action_sheet_header_supporting}
/// The header's supporting text: the stacked lines beneath the bar.
///
/// Holds the subtitle, plus the title when an icon has taken the bar's leading
/// slot. Non-interactive, so unlike [FlowinActionSheetHeaderBar] its insets are
/// symmetric.
///
/// Internal to the action sheet: public so it can live in its own file, but
/// deliberately absent from the package's export barrel.
/// {@endtemplate}
class FlowinActionSheetHeaderSupporting extends StatelessWidget {
  /// {@macro flowin_action_sheet_header_supporting}
  const FlowinActionSheetHeaderSupporting({
    required this.children,
    super.key,
  });

  /// The stacked lines, in reading order.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: FlowinDesignSpace.space800,
        right: FlowinDesignSpace.space800,
        top: FlowinDesignSpace.space200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FlowinDesignSpace.space200,
        children: children,
      ),
    );
  }
}
