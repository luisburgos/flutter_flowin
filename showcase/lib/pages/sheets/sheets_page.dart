import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/sheets/sheet_playground.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// An interactive playground for every action sheet configuration.
class SheetsPage extends StatelessWidget {
  /// {@macro sheets_page}
  const SheetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // A self-laid-out body: the playground's panes run edge to edge and own
    // their own scrolling, so the bar draws the hairline that separates them.
    return const ShowcaseScaffold(
      title: 'Action sheets',
      dividedAppBar: true,
      body: SheetPlayground(),
    );
  }
}
