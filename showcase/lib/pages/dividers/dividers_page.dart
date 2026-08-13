import 'package:flowin_showcase/components/showcase/showcase_row.dart';
import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/components/showcase/showcase_section.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The height the vertical rule is demonstrated at.
///
/// A [VerticalDivider] fills its parent, so it needs a bounded one to show at
/// all.
const _verticalDividerHeight = 40.0;

/// The rules that separate content, and where their styling comes from.
///
/// Static rather than a playground, and deliberately so: there is no Flowin
/// divider to configure. Both rules are the framework's own, styled entirely
/// by the theme's `dividerTheme`, so what is worth showing is that the slot
/// exists and what it produces — not a set of axes a caller picks along.
class DividersPage extends StatelessWidget {
  /// {@macro dividers_page}
  const DividersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold.stacked(
      title: 'Dividers',
      children: [
        ShowcaseSection(
          title: 'Themed by the slot, not by a wrapper',
          leadingGap: false,
          description:
              'There is no Flowin divider component. The native Divider and '
              'VerticalDivider read their colour, thickness and insets from '
              'the theme dividerTheme, so they arrive correct wherever they '
              'are used and need no wrapper to look right.',
          children: [
            const ShowcaseRow(
              label: 'Divider — separating stacked content',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Above the divider'),
                  Divider(),
                  Text('Below the divider'),
                ],
              ),
            ),
            ShowcaseRow(
              label: 'VerticalDivider — separating side-by-side content',
              child: SizedBox(
                height: _verticalDividerHeight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: context.spacing.md,
                  children: const [
                    Text('Left'),
                    VerticalDivider(),
                    Text('Right'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
