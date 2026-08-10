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
/// Composed of two regions. [FlowinActionSheetHeaderBar] carries the primary
/// line — a leading mark beside the close control — and
/// [FlowinActionSheetHeaderSupporting] carries the stacked text beneath it.
///
/// The header owns the rule that decides which region holds the title, because
/// both regions it affects are its own children. See [build].
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

    // The bar's leading slot carries the icon when there is one, and the title
    // otherwise. Whatever the bar did not take drops into the supporting
    // block, so the title stays adjacent to its subtitle either way.
    //
    // Gated on "is there anything to show" rather than on `hasIcon`: an
    // icon-less sheet still has a subtitle to render, and gating on the icon
    // would drop it.
    final supporting = <Widget>[if (hasIcon) titleWidget, ?subtitleWidget];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
