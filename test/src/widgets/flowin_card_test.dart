// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

/// Returns the [Container] that forms the [FlowinCard] surface — the one
/// whose decoration is a [ShapeDecoration].
Container _cardContainer(WidgetTester tester) {
  final containers = tester.widgetList<Container>(find.byType(Container));
  return containers.firstWhere(
    (container) => container.decoration is ShapeDecoration,
  );
}

void main() {
  group('FlowinCard', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpApp(FlowinCard(child: Text('Body')));
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets(
      'background color defaults from the theme cardTheme color '
      '(theme-only styling)',
      (tester) async {
        await tester.pumpApp(FlowinCard(child: Text('Body')));

        final decoration =
            _cardContainer(tester).decoration! as ShapeDecoration;
        expect(decoration.color, FlowinTheme.light.cardTheme.color);
      },
    );

    testWidgets('explicit backgroundColor overrides the theme default', (
      tester,
    ) async {
      const customBackground = Color(0xFF112233);
      await tester.pumpApp(
        FlowinCard(
          backgroundColor: customBackground,
          child: Text('Body'),
        ),
      );

      final decoration = _cardContainer(tester).decoration! as ShapeDecoration;
      expect(decoration.color, customBackground);
    });

    testWidgets('clipChild wraps the child in a ClipSmoothRect', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinCard(clipChild: true, child: Text('Body')),
      );

      expect(find.byType(ClipSmoothRect), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets(
      'background color falls back to colorScheme.secondaryContainer '
      'when both backgroundColor and cardTheme.color are null',
      (tester) async {
        const fallback = Color(0xFFAABBCC);
        final themeWithoutCardColor = ThemeData(
          colorScheme: const ColorScheme.light(
            secondaryContainer: fallback,
          ),
        );

        await tester.pumpApp(
          FlowinCard(child: Text('Body')),
          theme: themeWithoutCardColor,
        );

        // The theme leaves cardTheme.color null, so the card must fall back
        // to colorScheme.secondaryContainer.
        expect(themeWithoutCardColor.cardTheme.color, isNull);

        final decoration =
            _cardContainer(tester).decoration! as ShapeDecoration;
        expect(decoration.color, fallback);
      },
    );

    /// The text colour the card's child actually inherits.
    Color contentColor(WidgetTester tester) =>
        DefaultTextStyle.of(tester.element(find.text('x'))).style.color!;

    // A fill can come from data, so the theme's ambient text colour is not
    // chosen for it. Inherited, dark-grey body text on a black card is 1.18:1
    // against the 4.5:1 minimum.
    //
    // One case per testWidgets rather than a loop inside one: re-pumping
    // within a single test body reads a partly-stale tree (flowin_pm#19).
    const fills = <String, Color>{
      'navy': Color(0xFF1A237E),
      'black': Color(0xFF000000),
      'red': Color(0xFFE53935),
      'white': Color(0xFFFFFFFF),
    };

    for (final (brightness, dark) in flowinThemes) {
      for (final entry in fills.entries) {
        testWidgets('content stays readable on ${entry.key}, $brightness', (
          tester,
        ) async {
          await tester.pumpApp(
            FlowinCard(backgroundColor: entry.value, child: const Text('x')),
            theme: flowinThemeFor(dark: dark),
          );
          expectLegible(contentColor(tester), entry.value);
        });
      }
    }

    testWidgets('a transparent fill keeps the inherited colour', (
      tester,
    ) async {
      // The card cannot see what is behind it, and a transparent colour
      // reports zero luminance — resolving against it would return white as
      // though the fill were black.
      await tester.pumpApp(
        FlowinCard(
          backgroundColor: Colors.transparent,
          child: const Text('x'),
        ),
      );
      expect(
        contentColor(tester),
        FlowinTheme.light.textTheme.bodyMedium!.color,
      );
    });

    testWidgets('resolveForeground: false keeps the inherited colour', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinCard(
          backgroundColor: const Color(0xFF000000),
          resolveForeground: false,
          child: const Text('x'),
        ),
      );
      expect(
        contentColor(tester),
        FlowinTheme.light.textTheme.bodyMedium!.color,
      );
    });

    testWidgets('a legible foregroundColor is honoured', (tester) async {
      const cream = Color(0xFFFFF8E1);
      await tester.pumpApp(
        FlowinCard(
          backgroundColor: const Color(0xFF1A237E),
          foregroundColor: cream,
          child: const Text('x'),
        ),
      );
      expect(contentColor(tester), cream);
    });

    testWidgets('an illegible foregroundColor is overridden, not obeyed', (
      tester,
    ) async {
      // The preference loses to readability: cream on white is ~1.4:1, so the
      // resolver falls back rather than rendering the caller's exact colour.
      const cream = Color(0xFFFFF8E1);
      const fill = Color(0xFFFFFFFF);
      await tester.pumpApp(
        FlowinCard(
          backgroundColor: fill,
          foregroundColor: cream,
          child: const Text('x'),
        ),
      );
      expect(contentColor(tester), isNot(cream));
      expect(
        flowinContrastRatio(contentColor(tester), fill),
        greaterThanOrEqualTo(ContrastCompliance.normalText.minRatio),
      );
    });
  });

  group('FlowinCardBorderRadius', () {
    test('default constructor sets each corner independently', () {
      // Non-const so the constructor runs at runtime and registers coverage
      // (a const instance is canonicalized at compile time).
      final radius = FlowinCardBorderRadius(
        topLeft: 1,
        topRight: 2,
        bottomLeft: 3,
        bottomRight: 4,
      );
      expect(radius.topLeft, 1);
      expect(radius.topRight, 2);
      expect(radius.bottomLeft, 3);
      expect(radius.bottomRight, 4);
    });

    test('all sets every corner equal', () {
      const radius = FlowinCardBorderRadius.all(8);
      expect(radius.topLeft, 8);
      expect(radius.topRight, 8);
      expect(radius.bottomLeft, 8);
      expect(radius.bottomRight, 8);
    });

    test('medium is radius400 on every corner', () {
      const radius = FlowinCardBorderRadius.medium();
      expect(radius.topLeft, FlowinDesignRadius.radius400);
      expect(radius.topRight, FlowinDesignRadius.radius400);
      expect(radius.bottomLeft, FlowinDesignRadius.radius400);
      expect(radius.bottomRight, FlowinDesignRadius.radius400);
    });

    test('toSmoothBorderRadius returns a SmoothBorderRadius', () {
      const radius = FlowinCardBorderRadius.medium();
      expect(radius.toSmoothBorderRadius(), isA<SmoothBorderRadius>());
    });
  });
}
