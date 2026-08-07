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
  group('FlowinItemButton', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: () {}, label: 'Settings'),
      );
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders a child over a label', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: () {}, child: Text('Custom')),
      );
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        FlowinItemButton(onPressed: () => tapped = true, label: 'Go'),
      );
      await tester.tap(find.byType(FlowinItemButton));
      expect(tapped, isTrue);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: null, label: 'Disabled'),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('default variant is tonal (FilledButton)', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: () {}, label: 'Row'),
      );
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('tonal named constructor renders a FilledButton', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinItemButton.tonal(onPressed: () {}, label: 'Tonal'),
      );
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('Tonal'), findsOneWidget);
    });

    testWidgets('variants map to the right native widget', (tester) async {
      Future<void> expectVariant(
        FlowinItemButton button,
        Type nativeType,
      ) async {
        await tester.pumpApp(button);
        expect(find.byType(nativeType), findsOneWidget);
      }

      await expectVariant(
        FlowinItemButton.filled(onPressed: () {}, label: 'F'),
        FilledButton,
      );
      await expectVariant(
        FlowinItemButton.outline(onPressed: () {}, label: 'O'),
        OutlinedButton,
      );
      await expectVariant(
        FlowinItemButton.text(onPressed: () {}, label: 'T'),
        TextButton,
      );
      await expectVariant(
        FlowinItemButton.destructive(onPressed: () {}, label: 'D'),
        FilledButton,
      );
    });

    testWidgets('stretches to full width', (tester) async {
      await tester.pumpApp(
        SizedBox(
          width: 400,
          child: FlowinItemButton(onPressed: () {}, label: 'Wide'),
        ),
      );
      final size = tester.getSize(find.byType(FilledButton));
      expect(size.width, 400);
    });

    testWidgets('aligns content to the leading (left) edge', (tester) async {
      await tester.pumpApp(
        SizedBox(
          width: 400,
          child: FlowinItemButton(onPressed: () {}, label: 'Lead'),
        ),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.style?.alignment, Alignment.centerLeft);
    });

    testWidgets('uses uniform 16 padding', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: () {}, label: 'Pad'),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(
        button.style?.padding?.resolve({}),
        const EdgeInsets.all(FlowinDesignSpace.space400),
      );
    });

    testWidgets('renders a leading icon before the label', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(
          onPressed: () {},
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      );
      expect(find.byIcon(Icons.settings), findsOneWidget);
      final iconX = tester.getCenter(find.byIcon(Icons.settings)).dx;
      final labelX = tester.getCenter(find.text('Settings')).dx;
      expect(iconX, lessThan(labelX));
    });

    testWidgets(
      'variant colours come from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        // This row pins its own shape, padding and sizing — deliberately, a
        // full-width row reads as a surface, not a pill. The risk that creates
        // is drift: once a widget owns part of its ButtonStyle, colour is easy
        // to slip in beside it. Override the fill and label roles alone and
        // assert both reach the rendered row, proving the colours are still
        // the theme's even though the geometry is not.
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

        // Pumped unchanged: the default (tonal) variant, no widget arguments
        // touched, so only the theme can account for what renders.
        await tester.pumpApp(
          FlowinItemButton(onPressed: () {}, label: 'Row'),
          theme: theme,
        );

        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(FilledButton),
            matching: find.byType(Material),
          ),
        );
        expect(material.color, customBackground);
        expect(_renderedStyleOf(tester, 'Row').color, customForeground);
      },
    );
  });
}
