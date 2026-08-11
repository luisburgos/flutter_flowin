import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// {@template flowin_action_sheet_header_bar}
/// The header's primary line: a [leading] mark beside a [trailing] control.
///
/// [leading] and [trailing] name the flanking slots of the row, not what lands
/// in them, so the same bar serves an icon or a title.
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
    // Measures the row so [leading] can bottom-align against the tallest child
    // rather than shrink-wrapping its own text. Remove it and the alignment
    // below silently stops doing anything.
    return IntrinsicHeight(
      child: Padding(
        // [trailing] carries no inset, so this gutter is the only thing holding
        // it off the card edge. Narrower than the left: the control is meant to
        // sit closer to the edge than the text.
        padding: const EdgeInsets.only(
          left: FlowinDesignSpace.space800,
          right: FlowinDesignSpace.space400,
        ),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: leading,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
