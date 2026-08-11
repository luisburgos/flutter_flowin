import 'package:flowin_showcase/pages/sheets/sheet_body.dart';
import 'package:flowin_showcase/pages/sheets/sheet_config.dart';
import 'package:flowin_showcase/pages/sheets/sheet_footer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// A [FlowinActionSheet] built from a [SheetConfig].
///
/// The two presentations want opposite things from `margin` and `onClose`, so
/// they are named constructors rather than parameters. Leaving them free is
/// what previously let the modal inherit the inline preview's zeroed margin
/// and no-op close, which made it render flush to the window and gave it a
/// close button that did nothing.
class SheetPreview extends StatelessWidget {
  /// The sheet as it appears on the playground's stage.
  ///
  /// The stage already insets it, so the margin is zeroed; the close button is
  /// inert so it stays visible without the preview being dismissable.
  const SheetPreview.inline(this.config, {super.key})
    : margin = EdgeInsets.zero,
      onClose = _noop,
      onAction = _noop;

  /// The sheet as presented over a scrim.
  ///
  /// Keeps the widget's own screen-edge margin, and leaves `onClose` null so
  /// the sheet's default pop runs instead of being overridden.
  const SheetPreview.modal(this.config, {required this.onAction, super.key})
    : margin = null,
      onClose = null;

  /// The configuration to render.
  final SheetConfig config;

  /// The card's outer margin, or null for the widget's own default.
  final EdgeInsets? margin;

  /// Called when the close button is tapped, or null for the default pop.
  final VoidCallback? onClose;

  /// Called from the footer's actions.
  final VoidCallback onAction;

  static void _noop() {}

  @override
  Widget build(BuildContext context) {
    return FlowinActionSheet(
      title: 'Descriptive title',
      subtitle: config.hasSubtitle
          ? 'Write something in here that gives clear directions.'
          : null,
      headerIcon: config.hasIcon
          ? FDIcons.board.toIcon(size: FlowinDesignIconSize.xl)
          : null,
      displayClose: config.hasClose,
      onClose: onClose,
      margin: margin,
      body: buildSheetBody(config.body),
      footer: buildSheetFooter(config.footer, onAction),
    );
  }
}
