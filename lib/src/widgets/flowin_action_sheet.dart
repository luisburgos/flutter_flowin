import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';
import 'package:flutter_flowin/src/widgets/flowin_button.dart'
    show FlowinButtonSize;
import 'package:flutter_flowin/src/widgets/flowin_card.dart';
import 'package:flutter_flowin/src/widgets/flowin_icon_button.dart';

/// Pops the current Flowin action sheet (a modal bottom sheet).
extension PopFlowinActionSheet on BuildContext {
  /// Dismisses the action sheet presented over this context.
  ///
  /// Pass [result] to hand a value back to whoever is awaiting
  /// [showFlowinActionSheet]. A confirmation sheet typically pops `true` from
  /// its confirm action and nothing at all from cancel, so the awaiting caller
  /// reads `null` for a dismissal:
  ///
  /// ```dart
  /// final confirmed = await showFlowinActionSheet<bool>(
  ///       context: context,
  ///       builder: (sheetContext) => ConfirmSheet(
  ///         onCancel: () => sheetContext.popFlowinActionSheet(),
  ///         onConfirm: () => sheetContext.popFlowinActionSheet(true),
  ///       ),
  ///     ) ??
  ///     false;
  /// ```
  void popFlowinActionSheet<T extends Object?>([T? result]) =>
      Navigator.of(this).pop(result);
}

/// Presents [builder] as a Flowin modal bottom sheet.
///
/// The sheet surface and corner radius come from the theme's `bottomSheetTheme`
/// for the modal scrim; the [FlowinActionSheet] inside supplies its own smooth
/// card surface.
///
/// [backgroundColor], [constraints], and [clipBehavior] are overridable; when
/// omitted they fall back to the Flowin defaults (a transparent scrim surface,
/// full-width constraints, and no clipping).
///
/// The sheet is lifted clear of the software keyboard, so a sheet containing a
/// text field keeps its footer actions reachable. **A sheet taller than the
/// space the keyboard leaves will overflow**: the lift moves the card, it does
/// not shrink it. A sheet with a body that can grow — a long form, a list —
/// should make that body scrollable itself.
Future<T?> showFlowinActionSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  Color? barrierColor,
  Color? backgroundColor,
  BoxConstraints? constraints,
  Clip? clipBehavior,
  double maxWidth = 480,
}) {
  // On viewports wider than [maxWidth] the sheet is clamped so it does not
  // stretch edge to edge on tablets and desktop; at or below that width it
  // fills the available space (fd_action_sheet_utils.dart). Unlike
  // production, explicit caller [constraints] are forwarded untouched rather
  // than having their maxWidth clobbered by the clamp.
  final screenWidth = MediaQuery.of(context).size.width;
  final effectiveConstraints =
      constraints ??
      (screenWidth > maxWidth
          ? BoxConstraints(maxWidth: maxWidth)
          : const BoxConstraints(minWidth: double.infinity));

  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: backgroundColor ?? Colors.transparent,
    isScrollControlled: isScrollControlled,
    barrierColor: barrierColor,
    constraints: effectiveConstraints,
    clipBehavior: clipBehavior ?? Clip.none,
    // Lift the sheet clear of the software keyboard.
    //
    // `showModalBottomSheet` sizes its child against the full screen height
    // and never reads `viewInsets`, so a sheet containing a text field sits
    // *behind* the keyboard the field just opened — the footer actions are
    // the first thing to go. Flutter leaves this to the caller deliberately,
    // since only the caller knows whether to lift, scroll, or resize.
    //
    // Padding the bottom by the inset shifts the whole card up by exactly the
    // covered height. It is read inside the builder so the sheet tracks the
    // keyboard as it animates in and out, rather than sampling the inset once
    // at present time.
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: builder(sheetContext),
    ),
  );
}

/// {@template flowin_action_sheet}
/// A bottom action sheet with a header (title, optional subtitle/icon, optional
/// close button), an optional body, and an optional footer, on a smooth card
/// surface.
///
/// Present it with [showFlowinActionSheet].
/// {@endtemplate}
class FlowinActionSheet extends StatelessWidget {
  /// {@macro flowin_action_sheet}
  const FlowinActionSheet({
    required this.title,
    this.subtitle,
    this.headerIcon,
    this.body,
    this.footer,
    this.displayClose = true,
    this.onClose,
    this.margin,
    this.bodyPadding,
    super.key,
  });

  /// The sheet title.
  final String title;

  /// An optional subtitle, rendered beneath the title.
  final String? subtitle;

  /// An optional header icon.
  final Widget? headerIcon;

  /// Optional body content.
  final Widget? body;

  /// Optional footer content (typically actions).
  final Widget? footer;

  /// Whether to show the close button.
  final bool displayClose;

  /// Called when the close button is tapped. Defaults to popping the sheet.
  final VoidCallback? onClose;

  /// Outer margin around the card.
  final EdgeInsets? margin;

  /// Padding around the body.
  final EdgeInsets? bodyPadding;

  @override
  Widget build(BuildContext context) {
    return FlowinCard(
      margin:
          margin ??
          const EdgeInsets.only(
            top: FlowinDesignSpace.space800,
            bottom: FlowinDesignSpace.space600,
            left: FlowinDesignSpace.space400,
            right: FlowinDesignSpace.space400,
          ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      borderRadius: const FlowinCardBorderRadius.all(
        FlowinDesignRadius.radius1000,
      ),
      padding: const EdgeInsets.only(bottom: FlowinDesignSpace.space600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: FlowinDesignSpace.space400,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: FlowinDesignSpace.space600,
              left: FlowinDesignSpace.space600,
              right: FlowinDesignSpace.space600,
            ),
            child: FlowinActionSheetHeader(
              title: title,
              subtitle: subtitle,
              icon: headerIcon,
              displayClose: displayClose,
              onClose: onClose ?? () => context.popFlowinActionSheet(),
            ),
          ),
          if (body != null)
            Padding(
              padding:
                  bodyPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: FlowinDesignSpace.space600,
                  ),
              child: body,
            ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FlowinDesignSpace.space600,
              ),
              child: footer,
            ),
        ],
      ),
    );
  }
}

/// {@template flowin_action_sheet_header}
/// The header of a [FlowinActionSheet]: a title (or icon), an optional
/// subtitle, and an optional close button.
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final hasIcon = icon != null;

    final titleWidget = Text(title, style: textTheme.headlineSmall);
    final subtitleWidget = subtitle != null
        ? Text(
            subtitle!,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
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

    // The top row carries the icon when there is one, and the title otherwise.
    // Whatever the row did not take drops into the block below it, so the
    // title stays adjacent to its subtitle either way.
    //
    // The block used to be gated on `hasIcon`, which silently dropped the
    // subtitle of an icon-less sheet — the subtitle was only ever rendered as
    // a sibling of the demoted title. Gating on "is there anything to show"
    // instead keeps the title/subtitle pairing intact in both arrangements.
    final belowRow = <Widget>[if (hasIcon) titleWidget, ?subtitleWidget];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FlowinDesignSpace.space200,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: hasIcon ? icon : titleWidget,
                ),
              ),
            ),
            close,
          ],
        ),
        if (belowRow.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              left: FlowinDesignSpace.space200,
              right: FlowinDesignSpace.space200,
              top: FlowinDesignSpace.space200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FlowinDesignSpace.space200,
              children: belowRow,
            ),
          ),
      ],
    );
  }
}

/// {@template flowin_action_sheet_footer}
/// The footer of a [FlowinActionSheet]: an optional left action and a required
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
