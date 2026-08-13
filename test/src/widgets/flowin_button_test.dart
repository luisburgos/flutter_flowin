// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

/// The style the framework actually paints [text] with.
///
/// Reading the style off the [Text] widget would only echo what the widget was
/// handed; the span inside [RichText] is the merged, post-theme result, which
/// is the only thing that proves a theme value survived to the screen.
TextStyle _renderedStyleOf(WidgetTester tester, String text) {
  final richText = tester.widget<RichText>(
    find.descendant(of: find.text(text), matching: find.byType(RichText)),
  );
  return richText.text.style!;
}

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

    testWidgets(
      'base label text style comes from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        // The contract names the base text style a global binding. At `md` the
        // per-size style IS the theme base (labelLarge), so overriding the
        // role must move the rendered label — if a future refactor inlines a
        // literal size into the widget, this fails.
        //
        // The role, not filledButtonTheme.textStyle, is what the button
        // actually reads: FlowinButton always supplies its own per-size
        // textStyle, and a widget-level ButtonStyle outranks the component
        // theme. See the `filledButtonTheme.textStyle is shadowed` test below.
        const customFontSize = 37.0;
        final theme = FlowinTheme.light.copyWith(
          textTheme: FlowinTheme.light.textTheme.copyWith(
            labelLarge: FlowinTheme.light.textTheme.labelLarge?.copyWith(
              fontSize: customFontSize,
            ),
          ),
        );

        await tester.pumpApp(
          FlowinButton.filled(
            onPressed: () {},
            label: 'Themed',
            size: FlowinButtonSize.md,
          ),
          theme: theme,
        );

        // Assert the RENDERED text, not the style object handed to the button:
        // only the painted span proves the value survived the merge.
        expect(_renderedStyleOf(tester, 'Themed').fontSize, customFontSize);
      },
    );

    testWidgets(
      'filledButtonTheme.textStyle is shadowed by the per-size style '
      '(documents the binding)',
      (tester) async {
        // Guards a real asymmetry rather than a behaviour we want. Because
        // FlowinButton always sets textStyle on its own ButtonStyle, and a
        // widget style outranks the component theme, the `textStyle` slot on
        // filledButtonTheme never reaches the label — not even at `md`, where
        // the two values agree. Consumers must retheme `textTheme.labelLarge`.
        //
        // If this ever starts failing, the widget stopped setting its own
        // textStyle and the component-theme slot became live: delete this test
        // and assert the override wins instead.
        final theme = FlowinTheme.light.copyWith(
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              textStyle: const TextStyle(fontSize: 37),
            ),
          ),
        );

        await tester.pumpApp(
          FlowinButton.filled(
            onPressed: () {},
            label: 'Shadowed',
            size: FlowinButtonSize.md,
          ),
          theme: theme,
        );

        expect(
          _renderedStyleOf(tester, 'Shadowed').fontSize,
          FlowinTheme.light.textTheme.labelLarge?.fontSize,
        );
      },
    );

    testWidgets(
      'per-variant colour roles come from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        // The contract names the per-variant colour roles a global binding.
        // Override the filled variant's fill and label roles and assert both
        // reach the rendered output, proving FlowinButton layers only size on
        // top of the theme and hardcodes no colour of its own.
        const customBackground = Color(0xFF123456);
        const customForeground = Color(0xFF654321);
        final theme = FlowinTheme.light.copyWith(
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: customBackground,
              foregroundColor: customForeground,
            ),
          ),
        );

        await tester.pumpApp(
          FlowinButton.filled(onPressed: () {}, label: 'Coloured'),
          theme: theme,
        );

        // The fill is painted by the Material the FilledButton renders.
        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(FilledButton),
            matching: find.byType(Material),
          ),
        );
        expect(material.color, customBackground);
        expect(_renderedStyleOf(tester, 'Coloured').color, customForeground);
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
