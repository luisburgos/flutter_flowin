import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/components/showcase/showcase_section.dart';
import 'package:flowin_showcase/pages/foundations/widgets/color_swatch_card.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Flowin palette mapped onto Material's ColorScheme roles.
class ColorsPage extends StatelessWidget {
  /// {@macro colors_page}
  const ColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return ShowcaseScaffold.stacked(
      title: 'Colors',
      children: [
        ShowcaseSection(
          title: 'Color roles',
          leadingGap: false,
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
                  ColorSwatchCard(
                    label: entry.$1,
                    background: entry.$2,
                    foreground: entry.$3,
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
