import 'package:flowin_showcase/pages/sheets/sheet_playground.dart';
import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// An interactive playground for every action sheet configuration.
class SheetsPage extends StatelessWidget {
  /// {@macro sheets_page}
  const SheetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Not ShowcaseScaffold: it wraps its children in a padded ListView, and
    // the playground's panes run edge to edge and own their own scrolling.
    // The app bar is built the same way so the page still matches the others.
    return Scaffold(
      appBar: FlowinAppBar(
        height: kFlowinAppBarHeight + context.spacing.xxs,
        leading: FlowinIconButton.text(
          icon: FDIcons.back.toIcon(),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: const ThemeModeToggle(),
        // The panes below run edge to edge with no padding to separate them
        // from the bar, so the bar draws its own hairline. Same treatment
        // FlowinTabsAppBar uses, and the same token.
        footer: Padding(
          padding: EdgeInsetsGeometry.only(top: context.spacing.xxs),
          child: const Divider(
            height: FlowinDesignBorders.regular,
            thickness: FlowinDesignBorders.regular,
          ),
        ),
        child: Text('Action sheets', style: context.textTheme.titleMedium),
      ),
      body: const SheetPlayground(),
    );
  }
}
