import 'package:flowin_showcase/pages/showcase_scaffold.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Demonstrates the design tokens underneath every component.
class FoundationsPage extends StatelessWidget {
  /// {@macro foundations_page}
  const FoundationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final text = context.textTheme;

    return ShowcaseScaffold.paged(
      title: 'Foundations',
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
        ShowcaseSection(
          chipLabel: 'Color',
          title: 'Color roles',
          description: 'The Flowin palette mapped onto Material ColorScheme.',
          children: [
            Wrap(
              spacing: FlowinDesignSpace.space200,
              runSpacing: FlowinDesignSpace.space200,
              children: [
                for (final entry in [
                  ('primary', scheme.primary, scheme.onPrimary),
                  (
                    'secondary',
                    scheme.secondaryContainer,
                    scheme.onSecondaryContainer,
                  ),
                  ('surface', scheme.surface, scheme.onSurface),
                  ('error', scheme.errorContainer, scheme.onErrorContainer),
                ])
                  _Swatch(
                    label: entry.$1,
                    background: entry.$2,
                    foreground: entry.$3,
                  ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Spacing',
          title: 'Spacing scale',
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
        ShowcaseSection(
          chipLabel: 'Radius',
          title: 'Radius scale',
          children: [
            Wrap(
              spacing: FlowinDesignSpace.space200,
              runSpacing: FlowinDesignSpace.space200,
              children: [
                for (final entry in [
                  ('100', FlowinDesignRadius.radius100),
                  ('300', FlowinDesignRadius.radius300),
                  ('400', FlowinDesignRadius.radius400),
                  ('800', FlowinDesignRadius.radius800),
                  ('1000', FlowinDesignRadius.radius1000),
                ])
                  FlowinCard(
                    borderRadius: FlowinCardBorderRadius.all(entry.$2),
                    size: const Size(72, 56),
                    child: Center(
                      child: Text(entry.$1, style: text.labelSmall),
                    ),
                  ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Divider',
          title: 'Dividers',
          description:
              'There is no Flowin divider component: the native Divider and '
              'VerticalDivider are styled entirely by the theme dividerTheme.',
          children: [
            const Text('Above the divider'),
            const Divider(),
            const Text('Below the divider'),
            SizedBox(height: context.spacing.md),
            SizedBox(
              height: 40,
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
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Icon sizes',
          title: 'Icon sizes',
          children: [
            Row(
              spacing: FlowinDesignSpace.space300,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final size in FlowinDesignIconSize.values)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FDIcons.setNeutral.toIcon(size: size),
                      SizedBox(height: context.spacing.xxs),
                      Text(size.name, style: text.captionMedium),
                    ],
                  ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Icon set',
          title: 'Semantic icon set',
          description: 'FDIcons maps product concepts onto Lucide glyphs.',
          children: [
            Wrap(
              spacing: FlowinDesignSpace.space400,
              runSpacing: FlowinDesignSpace.space300,
              children: [
                for (final icon in FDIcons.values)
                  SizedBox(
                    width: 68,
                    child: Column(
                      children: [
                        icon.toIcon(size: FlowinDesignIconSize.md),
                        SizedBox(height: context.spacing.xxs),
                        Text(
                          icon.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.captionMedium.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return FlowinCard(
      backgroundColor: background,
      size: const Size(104, 64),
      child: Center(
        child: Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(color: foreground),
        ),
      ),
    );
  }
}
