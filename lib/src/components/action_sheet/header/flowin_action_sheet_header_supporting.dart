import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/components/action_sheet/header/flowin_action_sheet_header_bar.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// {@template flowin_action_sheet_header_supporting}
/// The header's supporting text: the stacked lines beneath the bar.
///
/// Holds the subtitle, plus the title when an icon has taken the bar's leading
/// slot. Carries no control, so unlike [FlowinActionSheetHeaderBar] its insets
/// are symmetric.
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
    // Full width so the block matches the bar above it; the column would
    // otherwise shrink to its longest line and the header would look ragged.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: FlowinDesignSpace.space800,
        right: FlowinDesignSpace.space800,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: FlowinDesignSpace.space50,
        children: children,
      ),
    );
  }
}
