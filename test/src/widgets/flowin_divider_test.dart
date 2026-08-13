import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

/// The [BorderSide] the Divider actually renders its line with.
///
/// A Divider paints its line as the bottom border of an inner box, so the
/// resolved colour and thickness live on that decoration. Reading
/// `DividerTheme.of(context)` back instead would pass even if the Divider
/// stopped consuming the theme.
BorderSide _renderedLineSide(WidgetTester tester) {
  final decorated = tester.widget<DecoratedBox>(
    find.descendant(
      of: find.byType(Divider),
      matching: find.byType(DecoratedBox),
    ),
  );
  return ((decorated.decoration as BoxDecoration).border! as Border).bottom;
}

void main() {
  // Flowin ships no custom divider: the native Divider is styled by the theme's
  // dividerTheme. These tests assert that the theme drives its appearance.
  group('Divider (theme-driven)', () {
    testWidgets('color and thickness come from the dividerTheme', (
      tester,
    ) async {
      await tester.pumpApp(const Divider());
      final scheme = FlowinTheme.light.colorScheme;
      // Read off the rendered line rather than the DividerThemeData, so this
      // still fails if the Divider stops consuming the theme.
      final side = _renderedLineSide(tester);
      expect(side.color, scheme.outlineVariant);
      expect(side.width, FlowinDesignBorders.regular);
    });

    testWidgets('reserved extent comes from the dividerTheme', (tester) async {
      await tester.pumpApp(const Divider());
      // The divider reserves vertical space beyond the hairline it paints.
      // Measured on the rendered box, so dropping `space` from the theme
      // shows up here rather than passing on a theme read-back.
      expect(
        tester.getSize(find.byType(Divider)).height,
        FlowinDesignSpace.space50,
      );
    });

    testWidgets(
      'overriding the dividerTheme changes the divider (theme-only styling)',
      (tester) async {
        const customColor = Color(0xFF445566);
        const customThickness = 4.0;
        // copyWith rather than a fresh DividerThemeData: constructing one from
        // scratch leaves `space` null, so the assertions below would still
        // hold if the theme stopped setting it at all.
        final theme = FlowinTheme.light.copyWith(
          dividerTheme: FlowinTheme.light.dividerTheme.copyWith(
            color: customColor,
            thickness: customThickness,
          ),
        );

        await tester.pumpApp(const Divider(), theme: theme);

        // Asserted on what the Divider paints and occupies, not on the
        // DividerThemeData it read back.
        expect(
          tester.renderObject(find.byType(Divider)),
          paints..path(color: customColor),
        );
        expect(_renderedLineSide(tester).width, customThickness);
        // The reserved extent survives the override, which it would not if
        // the theme's dividerTheme were rebuilt from scratch instead of
        // copied.
        expect(
          tester.getSize(find.byType(Divider)).height,
          FlowinDesignSpace.space50,
        );
      },
    );

    testWidgets(
      'overriding the reserved extent changes the divider '
      '(theme-only styling)',
      (tester) async {
        // `space` is the binding most easily lost, because a divider with the
        // right colour and thickness still looks correct in isolation while
        // every surrounding layout silently tightens.
        const customSpace = 40.0;
        final theme = FlowinTheme.light.copyWith(
          dividerTheme: FlowinTheme.light.dividerTheme.copyWith(
            space: customSpace,
          ),
        );

        await tester.pumpApp(const Divider(), theme: theme);

        expect(tester.getSize(find.byType(Divider)).height, customSpace);
      },
    );
  });
}
