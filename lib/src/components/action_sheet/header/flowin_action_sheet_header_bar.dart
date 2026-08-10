import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// {@template flowin_action_sheet_header_bar}
/// The header's primary line: a [leading] mark beside a [trailing] control.
///
/// Named for what it is rather than where it sits: the supporting region below
/// it is a sibling, not a "bottom", and either could move without the names
/// going stale. [leading] and [trailing] follow the Material list-item
/// convention, where they denote the flanking slots of a row and say nothing
/// about which content lands in them.
///
/// Internal to the action sheet: public so it can live in its own file, but
/// deliberately absent from the package's export barrel.
/// {@endtemplate}
class FlowinActionSheetHeaderBar extends StatelessWidget {
  /// {@macro flowin_action_sheet_header_bar}
  const FlowinActionSheetHeaderBar({
    required this.leading,
    required this.trailing,
    super.key,
  });

  /// The mark that opens the line: the header icon, or the title when there is
  /// no icon to displace it.
  final Widget? leading;

  /// The control that closes the line, typically the close button.
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Asymmetric on purpose: [trailing] carries no inset of its own, so this
      // right gutter is the only thing holding it off the card edge. It is
      // narrower than the left so the control sits closer to that edge than
      // the text does.
      padding: const EdgeInsets.only(
        left: FlowinDesignSpace.space800,
        right: FlowinDesignSpace.space400,
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: leading,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
