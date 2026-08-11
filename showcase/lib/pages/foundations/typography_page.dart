import 'package:flowin_showcase/pages/showcase_scaffold.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The two type families: the baseline mapped onto Material's roles, and the
/// brand styles reachable through TextTheme extensions.
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
        ShowcaseSection(
          chipLabel: 'Brand',
          title: 'Brand typography (Supreme)',
          description: 'Expressive styles reachable via TextTheme extensions.',
          children: [
            Text(
              'Display LG',
              style: text.brandDisplayLG.copyWith(fontSize: 48),
            ),
            Text('Headline large', style: text.brandHeadlineLarge),
            Text('Headline small', style: text.brandHeadlineSmall),
            Text('Title medium', style: text.brandTitleMedium),
            Text('Body large', style: text.brandBodyLarge),
          ],
        ),
      ],
    );
  }
}
