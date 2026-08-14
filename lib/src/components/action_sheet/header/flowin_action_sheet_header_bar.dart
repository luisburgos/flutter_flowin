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

  /// The bar's height.
  ///
  /// Fixed rather than measured from its children. [trailing] is an icon
  /// button, and Material wraps one in a tap target inflated by
  /// `VisualDensity` — larger than the control drawn inside it, and
  /// platform-dependent. Measuring the row let that invisible box set the
  /// header's shape: the bar grew taller than the control, the leading mark
  /// trailed slack that pushed the supporting text away, and the whole header
  /// changed size when the button was hidden.
  ///
  /// One control tall, since the bar holds a single line or mark. The button
  /// keeps its own tap target; it simply no longer dictates the layout.
  static final double height = FlowinDesignControlSize.xs.value;

  @override
  Widget build(BuildContext context) {
    // OverflowBox lets [trailing] lay out at its natural size — an icon
    // button's tap target is taller than the control it draws — while the bar
    // reports only [height]. Sizing the row to the button instead let that
    // invisible box dictate the header's shape.
    return SizedBox(
      height: height,
      child: OverflowBox(
        maxHeight: double.infinity,
        child: Padding(
          // [trailing] carries no inset, so this gutter is the only thing
          // holding it off the card edge. Narrower than the left: the control
          // is meant to sit closer to the edge than the text.
          padding: const EdgeInsets.only(
            left: FlowinDesignSpace.space800,
            right: FlowinDesignSpace.space400,
          ),
          child: Row(
            children: [
              // Centred so the leading mark reads level with [trailing],
              // whose glyph sits in the middle of its own box.
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: leading,
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
