import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/components/showcase/showcase_section.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The baseline type scale, mapped onto Material's [TextTheme] roles, plus the
/// caption styles Material has no slot for.
class TypographyPage extends StatelessWidget {
  /// {@macro typography_page}
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.textTheme;

    return ShowcaseScaffold.paged(
      title: 'Typography',
      sections: [
        ShowcaseSection(
          chipLabel: 'Baseline',
          title: 'Baseline typography (Inter)',
          description:
              'Mapped onto Material TextTheme roles, so native '
              'widgets inherit them.',
          children: [
            Text('headlineSmall — 24/600', style: text.headlineSmall),
            Text('titleMedium — 16/600', style: text.titleMedium),
            Text('titleSmall — 14/600', style: text.titleSmall),
            Text('bodyLarge — 16/400', style: text.bodyLarge),
            Text('bodyMedium — 14/400', style: text.bodyMedium),
            Text('labelLarge — 16/600', style: text.labelLarge),
            Text('labelMedium — 14/600', style: text.labelMedium),
            Text('labelSmall — 12/600', style: text.labelSmall),
            Text('captionLarge — 12/500', style: text.captionLarge),
            Text('captionMedium — 10/400', style: text.captionMedium),
          ],
        ),
      ],
    );
  }
}
