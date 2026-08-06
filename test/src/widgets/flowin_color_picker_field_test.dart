// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  const predefinedColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];

  group('FlowinColorPickerField', () {
    testWidgets('renders inside a FlowinInputField with its label', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinColorPickerField(
          label: 'My Color',
          predefinedColors: predefinedColors,
        ),
      );

      expect(find.byType(FlowinInputField), findsOneWidget);
      expect(find.text('My Color'), findsOneWidget);
    });

    testWidgets('renders the predefined swatches', (tester) async {
      await tester.pumpApp(
        FlowinColorPickerField(
          predefinedColors: predefinedColors,
        ),
      );

      // One gradient swatch plus one per predefined color.
      expect(
        find.byType(FlowinColorRadialButton),
        findsNWidgets(predefinedColors.length + 1),
      );
    });

    testWidgets('initialColor marks its swatch as selected', (tester) async {
      await tester.pumpApp(
        FlowinColorPickerField(
          initialColor: Colors.blue,
          predefinedColors: predefinedColors,
        ),
      );

      final blueSwatch = tester.widget<FlowinColorRadialButton>(
        find.byWidgetPredicate(
          (widget) =>
              widget is FlowinColorRadialButton &&
              widget.color == Colors.blue &&
              widget.outerCircleDecoration == null,
        ),
      );
      expect(blueSwatch.selected, isTrue);
    });

    testWidgets(
      'tapping a predefined swatch selects it and reports the color',
      (tester) async {
        Color? changed;
        await tester.pumpApp(
          FlowinColorPickerField(
            predefinedColors: predefinedColors,
            onColorChanged: (color) => changed = color,
          ),
        );

        final greenSwatch = find.byWidgetPredicate(
          (widget) =>
              widget is FlowinColorRadialButton &&
              widget.color == Colors.green &&
              widget.outerCircleDecoration == null,
        );

        await tester.tap(greenSwatch);
        await tester.pump();

        expect(changed, Colors.green);
        final selectedGreen = tester.widget<FlowinColorRadialButton>(
          greenSwatch,
        );
        expect(selectedGreen.selected, isTrue);
      },
    );

    testWidgets(
      'tapping the gradient swatch opens the custom color picker',
      (tester) async {
        // The third-party custom picker needs a tall surface to lay out.
        tester.view.physicalSize = const Size(1200, 2400);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpApp(
          FlowinColorPickerField(
            predefinedColors: predefinedColors,
          ),
        );

        final gradientSwatch = find.byWidgetPredicate(
          (widget) =>
              widget is FlowinColorRadialButton &&
              widget.outerCircleDecoration != null,
        );

        await tester.tap(gradientSwatch);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // The custom picker is presented as a modal bottom sheet.
        expect(find.byType(BottomSheet), findsOneWidget);
      },
    );

    testWidgets(
      're-seeds when the caller swaps in a different initial color',
      (tester) async {
        Widget host(Color initial) => FlowinColorPickerField(
          predefinedColors: predefinedColors,
          initialColor: initial,
        );

        await tester.pumpApp(host(predefinedColors[0]));
        expect(
          tester
              .widgetList<FlowinColorRadialButton>(
                find.byType(FlowinColorRadialButton),
              )
              .where((swatch) => swatch.selected)
              .single
              .color,
          predefinedColors[0],
        );

        // Switching to another entity being edited re-seeds the selection.
        await tester.pumpApp(host(predefinedColors[1]));
        expect(
          tester
              .widgetList<FlowinColorRadialButton>(
                find.byType(FlowinColorRadialButton),
              )
              .where((swatch) => swatch.selected)
              .single
              .color,
          predefinedColors[1],
        );
      },
    );

    testWidgets(
      'a rebuild with an equal-valued initial color does not re-seed, so a '
      'color the user is picking survives a storage round-trip',
      (tester) async {
        await tester.pumpApp(
          FlowinColorPickerField(
            predefinedColors: predefinedColors,
            initialColor: predefinedColors[0],
          ),
        );

        // User picks a different swatch.
        await tester.tap(find.byType(FlowinColorRadialButton).at(1));
        await tester.pump();

        // The parent rebuilds with the same initial color reconstructed from
        // storage — a new Color instance of the same canonical value.
        await tester.pumpApp(
          FlowinColorPickerField(
            predefinedColors: predefinedColors,
            initialColor: Color(predefinedColors[0].toARGB32()),
          ),
        );

        // The user's pick is not clobbered.
        expect(
          tester
              .widgetList<FlowinColorRadialButton>(
                find.byType(FlowinColorRadialButton),
              )
              .where((swatch) => swatch.selected)
              .single
              .color,
          predefinedColors[1],
        );
      },
    );
  });

  group('FlowinInlineColorPicker', () {
    testWidgets('tapping a predefined swatch reports that color', (
      tester,
    ) async {
      Color? predefinedTapped;
      await tester.pumpApp(
        FlowinInlineColorPicker(
          predefinedColors: predefinedColors,
          onCustomColorTap: () {},
          onPredefinedColorTap: (color) => predefinedTapped = color,
        ),
      );

      final greenSwatch = find.byWidgetPredicate(
        (widget) =>
            widget is FlowinColorRadialButton &&
            widget.color == Colors.green &&
            widget.outerCircleDecoration == null,
      );
      expect(greenSwatch, findsOneWidget);

      await tester.tap(greenSwatch);
      expect(predefinedTapped, Colors.green);
    });

    testWidgets('tapping the gradient swatch calls onCustomColorTap', (
      tester,
    ) async {
      var customTapped = false;
      await tester.pumpApp(
        FlowinInlineColorPicker(
          predefinedColors: predefinedColors,
          onCustomColorTap: () => customTapped = true,
          onPredefinedColorTap: (_) {},
        ),
      );

      // The gradient swatch is the one carrying an outerCircleDecoration.
      final gradientSwatch = find.byWidgetPredicate(
        (widget) =>
            widget is FlowinColorRadialButton &&
            widget.outerCircleDecoration != null,
      );
      expect(gradientSwatch, findsOneWidget);

      await tester.tap(gradientSwatch);
      expect(customTapped, isTrue);
    });

    group('swatch visibility (flowin_pm#15)', () {
      /// The radial buttons in render order: predefined first, gradient last.
      List<FlowinColorRadialButton> swatches(WidgetTester tester) => tester
          .widgetList<FlowinColorRadialButton>(
            find.byType(FlowinColorRadialButton),
          )
          .toList();

      testWidgets(
        'a selected swatch matching the surface still renders its ring, with '
        'no gap colour resolved for it',
        (tester) async {
          await tester.pumpApp(
            FlowinInlineColorPicker(
              // FlowinTheme.light's surface is near-white, so a white swatch
              // is the case that used to vanish: an opaque gap painted in the
              // surface colour was invisible against a white swatch.
              predefinedColors: const [Colors.white, Colors.red],
              selectedColor: Colors.white,
              onCustomColorTap: () {},
              onPredefinedColorTap: (_) {},
            ),
          );

          final white = swatches(tester).first;
          expect(white.selected, isTrue);

          // The gap is carved transparently by the swatch itself, so the ring
          // survives without the picker computing anything. The old mechanism
          // faked the gap by stacking an opaque circle over the swatch; with
          // the gap carved out there is nothing painted over it, so the swatch
          // renders through a single painter rather than a stack of circles.
          final decoratedBoxes = tester
              .widgetList<DecoratedBox>(
                find.descendant(
                  of: find.byWidget(white),
                  matching: find.byType(DecoratedBox),
                ),
              )
              .where((box) {
                final decoration = box.decoration;
                return decoration is BoxDecoration &&
                    decoration.gradient == null &&
                    decoration.color != null;
              });
          expect(
            decoratedBoxes,
            isEmpty,
            reason:
                'a selected swatch must not paint an opaque circle over '
                'itself to fake the gap — the gap reveals the background',
          );
        },
      );

      testWidgets(
        'selecting a predefined swatch leaves the gradient swatch unselected',
        (tester) async {
          await tester.pumpApp(
            FlowinInlineColorPicker(
              predefinedColors: const [Colors.white, Colors.red],
              selectedColor: Colors.white,
              onCustomColorTap: () {},
              onPredefinedColorTap: (_) {},
            ),
          );

          final gradient = swatches(tester).last;
          expect(gradient.outerCircleDecoration, isNotNull);
          expect(gradient.selected, isFalse);
        },
      );

      testWidgets('every swatch carries the separation shadow, unselected', (
        tester,
      ) async {
        await tester.pumpApp(
          FlowinInlineColorPicker(
            predefinedColors: const [Colors.white, Colors.red],
            onCustomColorTap: () {},
            onPredefinedColorTap: (_) {},
          ),
        );

        // The shadow is what keeps an unselected swatch visible against a
        // same-coloured surface, so no swatch needs a border of its own.
        final shadowed = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is ShapeDecoration &&
              (widget.decoration! as ShapeDecoration).shadows != null,
        );
        expect(shadowed, findsNWidgets(2));
      });
    });
  });

  group('flowinCustomColorSwatchKey', () {
    testWidgets('identifies the custom swatch, not a preset with its color', (
      tester,
    ) async {
      // The gradient swatch paints the *selected* color, so when a preset is
      // chosen the two are indistinguishable by color alone. Selecting red
      // here makes the red preset and the gradient swatch share a color.
      await tester.pumpApp(
        FlowinColorPickerField(
          initialColor: Colors.red,
          predefinedColors: predefinedColors,
        ),
      );

      final custom = find.byKey(flowinCustomColorSwatchKey);
      expect(custom, findsOneWidget);

      // It is the gradient swatch, and it is not selected: a preset is.
      final button = tester.widget<FlowinColorRadialButton>(custom);
      expect(button.selected, isFalse);

      // And it is exactly one of the rendered swatches, not all of them.
      expect(
        find.byType(FlowinColorRadialButton),
        findsNWidgets(predefinedColors.length + 1),
      );
    });
  });
}
