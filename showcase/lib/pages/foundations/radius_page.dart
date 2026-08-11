import 'package:flowin_showcase/pages/showcase_scaffold.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The corner-radius scale, each step drawn on a card.
class RadiusPage extends StatelessWidget {
  /// {@macro radius_page}
  const RadiusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.textTheme;

    return ShowcaseScaffold(
      title: 'Radius',
      children: [
        ShowcaseSection(
          title: 'Radius scale',
          leadingGap: false,
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
      ],
    );
  }
}
