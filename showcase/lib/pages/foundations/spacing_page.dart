import 'package:flowin_showcase/pages/showcase_scaffold.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The semantic spacing steps, each drawn at its real width.
class SpacingPage extends StatelessWidget {
  /// {@macro spacing_page}
  const SpacingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final text = context.textTheme;

    return ShowcaseScaffold(
      title: 'Spacing',
      children: [
        ShowcaseSection(
          title: 'Spacing scale',
          leadingGap: false,
          description: 'Semantic steps read from context.spacing.',
          children: [
            for (final entry in [
              ('xxs', context.spacing.xxs),
              ('xs', context.spacing.xs),
              ('sm', context.spacing.sm),
              ('md', context.spacing.md),
              ('lg', context.spacing.lg),
              ('xl', context.spacing.xl),
              ('xxl', context.spacing.xxl),
            ])
              Padding(
                padding: EdgeInsets.only(bottom: context.spacing.xxs),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      child: Text(entry.$1, style: text.labelSmall),
                    ),
                    Container(
                      width: entry.$2,
                      height: 16,
                      color: scheme.primary,
                    ),
                    SizedBox(width: context.spacing.xs),
                    Text(
                      '${entry.$2.toInt()}px',
                      style: text.captionLarge.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
