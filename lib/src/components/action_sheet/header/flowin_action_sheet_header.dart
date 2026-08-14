import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/components/action_sheet/header/flowin_action_sheet_header_bar.dart';
import 'package:flutter_flowin/src/components/action_sheet/header/flowin_action_sheet_header_subtitle.dart';
import 'package:flutter_flowin/src/components/action_sheet/header/flowin_action_sheet_header_supporting.dart';
import 'package:flutter_flowin/src/components/action_sheet/header/flowin_action_sheet_header_title.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';
import 'package:flutter_flowin/src/widgets/flowin_button.dart'
    show FlowinButtonSize;
import 'package:flutter_flowin/src/widgets/flowin_icon_button.dart';

/// {@template flowin_action_sheet_header}
/// The header of a `FlowinActionSheet`: a title (or icon), an optional
/// subtitle, and an optional close button.
///
/// Two regions: [FlowinActionSheetHeaderBar] for the primary line and
/// [FlowinActionSheetHeaderSupporting] for the text beneath it. The header owns
/// which region holds the title, since both are its own children.
/// {@endtemplate}
class FlowinActionSheetHeader extends StatelessWidget {
  /// {@macro flowin_action_sheet_header}
  const FlowinActionSheetHeader({
    required this.title,
    this.subtitle,
    this.icon,
    this.displayClose = true,
    this.onClose,
    super.key,
  });

  /// The header title.
  final String title;

  /// An optional subtitle, rendered beneath the title with or without an
  /// [icon].
  final String? subtitle;

  /// An optional leading icon.
  final Widget? icon;

  /// Whether to show the close button.
  final bool displayClose;

  /// Called when the close button is tapped.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final hasIcon = icon != null;

    final titleWidget = FlowinActionSheetHeaderTitle(title);
    final subtitleWidget = subtitle != null
        ? FlowinActionSheetHeaderSubtitle(subtitle!)
        : null;

    final close = displayClose
        ? FlowinIconButton.tonal(
            icon: FDIcons.x.toIcon(size: FlowinDesignIconSize.sm),
            // xs (32×32) to match the legacy reference, not the defaulted
            // sm (40×40).
            size: FlowinButtonSize.xs,
            onPressed: () => onClose?.call(),
          )
        : const SizedBox.shrink();

    // An icon takes the bar's one leading slot and displaces the title down
    // here, keeping it adjacent to its subtitle either way. Gated on "anything
    // to show" rather than on `hasIcon`, or an icon-less sheet would lose its
    // subtitle.
    final supporting = <Widget>[if (hasIcon) titleWidget, ?subtitleWidget];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // The gap below the bar, which is not the whole gap the eye sees.
      //
      // With an icon, the title has moved into the supporting block, so this
      // separates the icon from that block and the title-to-subtitle distance
      // is the block's own spacing — space50.
      //
      // Without one the title is still in the bar, which is a fixed height and
      // taller than a line of text, so the title trails half that difference
      // as slack. The rendered title-to-subtitle gap is that slack plus this
      // value, currently 10 against the 2 an icon gives.
      //
      // Left as it is: closing the difference means either shortening the bar,
      // which tightens the header's top inset, or subtracting the slack here,
      // which couples this widget to the bar's internal geometry. Neither is
      // worth it for 8px, but the numbers are asserted so the difference stays
      // where it was put rather than drifting.
      spacing: hasIcon ? FlowinDesignSpace.space200 : FlowinDesignSpace.space50,
      children: [
        FlowinActionSheetHeaderBar(
          leading: hasIcon ? icon : titleWidget,
          trailing: close,
        ),
        if (supporting.isNotEmpty)
          FlowinActionSheetHeaderSupporting(children: supporting),
      ],
    );
  }
}
