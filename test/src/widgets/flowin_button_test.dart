// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FlowinButton', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpApp(FlowinButton(onPressed: () {}, label: 'Tap me'));
      expect(find.text('Tap me'), findsOneWidget);
    });

    testWidgets('renders a child over a label', (tester) async {
      await tester.pumpApp(
        FlowinButton(onPressed: () {}, child: Text('Child')),
      );
      expect(find.text('Child'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        FlowinButton(onPressed: () => tapped = true, label: 'Tap'),
      );
      await tester.tap(find.byType(FlowinButton));
      expect(tapped, isTrue);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpApp(FlowinButton(onPressed: null, label: 'Disabled'));
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    group('variant maps to the right native widget', () {
      testWidgets('filled -> FilledButton', (tester) async {
        await tester.pumpApp(FlowinButton.filled(onPressed: () {}, label: 'x'));
        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.byType(OutlinedButton), findsNothing);
      });

      testWidgets('tonal -> FilledButton', (tester) async {
        await tester.pumpApp(FlowinButton.tonal(onPressed: () {}, label: 'x'));
        expect(find.byType(FilledButton), findsOneWidget);
      });

      testWidgets('outline -> OutlinedButton', (tester) async {
        await tester.pumpApp(
          FlowinButton.outline(onPressed: () {}, label: 'x'),
        );
        expect(find.byType(OutlinedButton), findsOneWidget);
      });

      testWidgets('text -> TextButton', (tester) async {
        await tester.pumpApp(FlowinButton.text(onPressed: () {}, label: 'x'));
        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('destructive -> FilledButton', (tester) async {
        await tester.pumpApp(
          FlowinButton.destructive(onPressed: () {}, label: 'x'),
        );
        expect(find.byType(FilledButton), findsOneWidget);
      });
    });

    testWidgets('renders an icon when provided', (tester) async {
      await tester.pumpApp(
        FlowinButton.filled(
          onPressed: () {},
          icon: Icon(Icons.add),
          label: 'Add',
        ),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    for (final size in FlowinButtonSize.values) {
      testWidgets('renders at size ${size.name}', (tester) async {
        await tester.pumpApp(
          FlowinButton(onPressed: () {}, size: size, label: size.name),
        );
        expect(find.text(size.name), findsOneWidget);
      });
    }

    testWidgets(
      'corner radius comes from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        // Override the filled-button shape in the theme; the button must
        // reflect it, proving FlowinButton does not hardcode its shape.
        const customRadius = 4.0;
        final theme = FlowinTheme.light.copyWith(
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(customRadius),
              ),
            ),
          ),
        );

        await tester.pumpApp(
          FlowinButton.filled(onPressed: () {}, label: 'Themed'),
          theme: theme,
        );

        // The widget itself carries no shape — it comes from the theme. Read
        // the resolved shape from the Material that FilledButton renders.
        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(FilledButton),
            matching: find.byType(Material),
          ),
        );
        expect(
          material.shape,
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(customRadius),
          ),
        );
      },
    );
  });

  group('FlowinButton per-size label text style (#11)', () {
    Future<TextStyle?> resolvedTextStyle(
      WidgetTester tester,
      FlowinButtonSize size,
    ) async {
      await tester.pumpApp(
        FlowinButton.filled(onPressed: () {}, label: 'X', size: size),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      return button.style?.textStyle?.resolve({});
    }

    testWidgets('xs uses labelSmall', (tester) async {
      final style = await resolvedTextStyle(tester, FlowinButtonSize.xs);
      final expected = FlowinTheme.light.textTheme.labelSmall;
      expect(style?.fontSize, expected?.fontSize);
    });

    testWidgets('sm uses labelMedium', (tester) async {
      final style = await resolvedTextStyle(tester, FlowinButtonSize.sm);
      final expected = FlowinTheme.light.textTheme.labelMedium;
      expect(style?.fontSize, expected?.fontSize);
    });

    testWidgets('md uses labelLarge', (tester) async {
      final style = await resolvedTextStyle(tester, FlowinButtonSize.md);
      final expected = FlowinTheme.light.textTheme.labelLarge;
      expect(style?.fontSize, expected?.fontSize);
    });
  });

  group('FlowinButton per-size outer padding (#10)', () {
    Future<EdgeInsetsGeometry?> outerPaddingOf(
      WidgetTester tester,
      FlowinButtonSize size,
    ) async {
      await tester.pumpApp(
        FlowinButton.filled(onPressed: () {}, label: 'X', size: size),
      );
      final padding = find.ancestor(
        of: find.byType(FilledButton),
        matching: find.byType(Padding),
      );
      if (padding.evaluate().isEmpty) return null;
      return tester.widget<Padding>(padding.first).padding;
    }

    testWidgets('xs wraps the button in 8px vertical outer padding', (
      tester,
    ) async {
      final padding = await outerPaddingOf(tester, FlowinButtonSize.xs);
      expect(
        padding,
        const EdgeInsets.symmetric(vertical: FlowinDesignSpace.space200),
      );
    });

    testWidgets('sm wraps the button in 4px vertical outer padding', (
      tester,
    ) async {
      final padding = await outerPaddingOf(tester, FlowinButtonSize.sm);
      expect(
        padding,
        const EdgeInsets.symmetric(vertical: FlowinDesignSpace.space100),
      );
    });

    testWidgets('md adds no outer padding wrapper', (tester) async {
      await tester.pumpApp(
        FlowinButton.filled(
          onPressed: () {},
          label: 'X',
          size: FlowinButtonSize.md,
        ),
      );
      // No Padding ancestor introduced by FlowinButton for md (zero outer).
      final ownPadding = find.ancestor(
        of: find.byType(FilledButton),
        matching: find.byType(Padding),
      );
      // Material/FilledButton may add internal Padding descendants, but
      // FlowinButton itself adds none as an ancestor wrapper for md.
      final flowinAncestor = find.ancestor(
        of: find.byType(FilledButton),
        matching: find.byType(FlowinButton),
      );
      // The FlowinButton is the direct semantic ancestor; assert no Padding
      // sits between FlowinButton and FilledButton for md.
      final paddingBetween = find.descendant(
        of: flowinAncestor,
        matching: ownPadding,
      );
      expect(paddingBetween, findsNothing);
    });
  });
}
