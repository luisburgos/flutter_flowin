import 'package:flowin_showcase/components/showcase/showcase_row.dart';
import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/components/showcase/showcase_section.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Demonstrates cards, surfaces, dividers and the semantic color tokens.
class CardsPage extends StatelessWidget {
  /// {@macro cards_page}
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final tokens = context.flowinTokens;

    return ShowcaseScaffold.paged(
      title: 'Cards & surfaces',
      sections: [
        ShowcaseSection(
          chipLabel: 'Radii',
          title: 'FlowinCard — radii',
          description: 'Squircle corners via figma_squircle, smoothing 0.6.',
          children: [
            ShowcaseRow(
              label: 'medium (radius400, the default)',
              child: FlowinCard(
                padding: EdgeInsets.all(context.spacing.md),
                child: const Text('Default card'),
              ),
            ),
            ShowcaseRow(
              label: 'all(radius1000) — the sheet radius',
              child: FlowinCard(
                borderRadius: const FlowinCardBorderRadius.all(
                  FlowinDesignRadius.radius1000,
                ),
                padding: EdgeInsets.all(context.spacing.md),
                child: const Text('Heavily rounded'),
              ),
            ),
            ShowcaseRow(
              label: 'asymmetric corners',
              child: FlowinCard(
                borderRadius: const FlowinCardBorderRadius(
                  topLeft: FlowinDesignRadius.radius800,
                  topRight: FlowinDesignRadius.radius100,
                  bottomLeft: FlowinDesignRadius.radius100,
                  bottomRight: FlowinDesignRadius.radius800,
                ),
                padding: EdgeInsets.all(context.spacing.md),
                child: const Text('Mixed radii'),
              ),
            ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Surfaces',
          title: 'FlowinCard — surface treatments',
          children: [
            ShowcaseRow(
              label: 'bordered, transparent background',
              child: FlowinCard(
                backgroundColor: Colors.transparent,
                borderSide: BorderSide(
                  color: context.colorScheme.outlineVariant,
                ),
                padding: EdgeInsets.all(context.spacing.md),
                child: const Text('Outlined surface'),
              ),
            ),
            ShowcaseRow(
              label: 'elevated (tokens.shadow)',
              child: FlowinCard(
                backgroundColor: context.colorScheme.surface,
                shadows: [tokens.shadow],
                padding: EdgeInsets.all(context.spacing.md),
                child: const Text('Raised surface'),
              ),
            ),
            ShowcaseRow(
              label: 'fixed size + clipped child',
              child: FlowinCard(
                size: const Size(double.infinity, 88),
                clipChild: true,
                child: ColoredBox(
                  color: context.colorScheme.primary,
                  child: Center(
                    child: Text(
                      'Clipped to the squircle',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const ShowcaseSection(
          chipLabel: 'Contrast',
          title: 'Content on a caller-supplied fill',
          description:
              'A fill can come from data — a team colour, a user accent — '
              'which the theme cannot see. A card resolves its content colour '
              'against its own fill so that content stays readable.',
          children: [_ForegroundOnFillDemo()],
        ),
        ShowcaseSection(
          chipLabel: 'Semantic',
          title: 'Semantic colors',
          description:
              'success / warning / info live on FlowinTokens, not on '
              "Material's ColorScheme.",
          children: [
            for (final entry in [
              ('Success', semantic.success, semantic.onSuccess),
              ('Warning', semantic.warning, semantic.onWarning),
              ('Info', semantic.info, semantic.onInfo),
            ])
              Padding(
                padding: EdgeInsets.only(bottom: context.spacing.xs),
                child: FlowinCard(
                  backgroundColor: entry.$2,
                  padding: EdgeInsets.all(context.spacing.sm),
                  child: Row(
                    spacing: FlowinDesignSpace.space200,
                    children: [
                      FDIcons.done.toIcon(
                        size: FlowinDesignIconSize.sm,
                        color: entry.$3,
                      ),
                      Text(
                        '${entry.$1} message',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: entry.$3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Dividers',
          title: 'Dividers',
          description:
              'Flowin ships no divider widget — the native Divider is '
              'styled by dividerTheme.',
          children: [
            const Divider(),
            SizedBox(height: context.spacing.xs),
            const SizedBox(
              height: 48,
              child: Row(
                children: [
                  Expanded(child: Center(child: Text('Left'))),
                  VerticalDivider(),
                  Expanded(child: Center(child: Text('Right'))),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Demonstrates that a card keeps its content readable on a caller-supplied
/// fill.
///
/// A fill can come from data — a team colour, a user accent — which the theme
/// cannot see, so the ambient text colour it would otherwise supply was chosen
/// for a different surface. Each pair below is the same fill and the same
/// text, opted out on the left and resolved on the right.
class _ForegroundOnFillDemo extends StatelessWidget {
  const _ForegroundOnFillDemo();

  /// Fills a user might realistically pick, including the two extremes.
  static const _fills = <(String, Color)>[
    ('navy', Color(0xFF1A237E)),
    ('black', Color(0xFF000000)),
    ('red', Color(0xFFE53935)),
    ('white', Color(0xFFFFFFFF)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Left column opts out and inherits the theme colour; right is the '
          'default. Toggle the theme — the two columns fail on opposite '
          'fills, which is why no inherited colour can serve them all.',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: context.spacing.md),
        for (final (name, fill) in _fills)
          Padding(
            padding: EdgeInsets.only(bottom: context.spacing.sm),
            child: Row(
              spacing: context.spacing.sm,
              children: [
                for (final resolve in [false, true])
                  Expanded(
                    child: FlowinCard(
                      backgroundColor: fill,
                      resolveForeground: resolve,
                      // A fill matching the page has no edge of its own, so
                      // the white specimen would otherwise read as floating
                      // text rather than as a card.
                      borderSide: BorderSide(
                        color: context.colorScheme.outlineVariant,
                      ),
                      padding: EdgeInsets.all(context.spacing.md),
                      child: Row(
                        spacing: context.spacing.xs,
                        children: [
                          FDIcons.done.toIcon(size: FlowinDesignIconSize.sm),
                          Expanded(
                            child: Text(
                              resolve ? '$name resolved' : '$name inherited',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        SizedBox(height: context.spacing.sm),
        Text(
          'foregroundColor is a preference, not an override',
          style: context.textTheme.labelLarge,
        ),
        Text(
          'The same cream is asked for on both. It is kept on navy, where it '
          'is legible, and dropped on white, where it would be ~1.4:1.',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: context.spacing.sm),
        Row(
          spacing: context.spacing.sm,
          children: [
            for (final (name, fill) in const [
              ('navy — kept', Color(0xFF1A237E)),
              ('white — dropped', Color(0xFFFFFFFF)),
            ])
              Expanded(
                child: FlowinCard(
                  backgroundColor: fill,
                  foregroundColor: const Color(0xFFFFF8E1),
                  borderSide: BorderSide(
                    color: context.colorScheme.outlineVariant,
                  ),
                  padding: EdgeInsets.all(context.spacing.md),
                  child: Text(name),
                ),
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
      ],
    );
  }
}
