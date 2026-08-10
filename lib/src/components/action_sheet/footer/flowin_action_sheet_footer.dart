import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// {@template flowin_action_sheet_footer}
/// The footer of a `FlowinActionSheet`: an optional left action and a required
/// right action, laid out as equal-width columns.
/// {@endtemplate}
class FlowinActionSheetFooter extends StatelessWidget {
  /// {@macro flowin_action_sheet_footer}
  const FlowinActionSheetFooter({required this.right, this.left, super.key});

  /// The optional left action.
  final Widget? left;

  /// The right action.
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: FlowinDesignSpace.space300,
      children: [
        if (left != null) Expanded(child: left!),
        Expanded(child: right),
      ],
    );
  }
}
