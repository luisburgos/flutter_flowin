// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

/// The draw calls the swatch's painter issues, as a comparable fingerprint.
///
/// Widget-count assertions cannot see inside a [CustomPaint], so they would
/// pass whatever the painter drew. Capturing the actual canvas calls records
/// the real geometry, which is what distinguishes a ring (a path with a hole)
/// from a plain disc.
List<String> _swatchImage(WidgetTester tester) {
  final paint = tester.widget<CustomPaint>(
    find
        .descendant(
          of: find.byType(FlowinColorRadialButton),
          matching: find.byType(CustomPaint),
        )
        .last,
  );
  final canvas = _RecordingCanvas();
  paint.painter!.paint(canvas, const Size.square(28));
  return canvas.calls;
}

/// Records the drawing calls made against it.
class _RecordingCanvas implements Canvas {
  final calls = <String>[];

  @override
  void drawCircle(Offset c, double radius, Paint paint) =>
      calls.add('circle r=$radius');

  @override
  void drawPath(Path path, Paint paint) =>
      calls.add('path fill=${path.fillType} bounds=${path.getBounds()}');

  @override
  void noSuchMethod(Invocation invocation) {}
}

void main() {
  group('FlowinColorRadialButton', () {
    testWidgets('renders an InkWell', (tester) async {
      await tester.pumpApp(FlowinColorRadialButton(color: Colors.blue));
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        FlowinColorRadialButton(
          color: Colors.blue,
          onTap: () => tapped = true,
        ),
      );
      await tester.tap(find.byType(FlowinColorRadialButton));
      expect(tapped, isTrue);
    });

    testWidgets('renders in the unselected state', (tester) async {
      await tester.pumpApp(
        FlowinColorRadialButton(color: Colors.blue),
      );
      expect(find.byType(FlowinColorRadialButton), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('renders in the selected state', (tester) async {
      await tester.pumpApp(
        FlowinColorRadialButton(color: Colors.blue, selected: true),
      );
      expect(find.byType(FlowinColorRadialButton), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('selected paints a ring where unselected paints a disc', (
      tester,
    ) async {
      await tester.pumpApp(FlowinColorRadialButton(color: Colors.blue));
      final unselected = _swatchImage(tester);

      await tester.pumpApp(
        FlowinColorRadialButton(color: Colors.blue, selected: true),
      );
      final selected = _swatchImage(tester);

      // The two states must actually render differently. Comparing the paint
      // output rather than counting widgets keeps this honest whatever
      // mechanism carves the gap.
      expect(selected, isNot(unselected));
    });

    testWidgets('the selection gap is transparent, not painted over', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinColorRadialButton(color: Colors.blue, selected: true),
      );

      // The old mechanism stacked an opaque circle over the swatch to fake the
      // gap. Nothing may paint over the swatch now: the gap is carved out, so
      // whatever sits behind the swatch shows through it.
      final opaqueCircles = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .where((box) {
            final decoration = box.decoration;
            return decoration is BoxDecoration &&
                decoration.gradient == null &&
                decoration.color != null;
          });
      expect(opaqueCircles, isEmpty);
    });

    testWidgets('a selected gradient swatch carves its gap too', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinColorRadialButton.gradient(
          color: Colors.transparent,
          selected: true,
        ),
      );

      // The gradient has to be painted by a decoration, so its gap is carved
      // by clipping rather than by the painter. The clip must be a holed path,
      // not a plain circle, or the gap would be filled by the sweep.
      final clip = tester.widget<ClipPath>(
        find.descendant(
          of: find.byType(FlowinColorRadialButton),
          matching: find.byType(ClipPath),
        ),
      );
      final path = clip.clipper!.getClip(const Size.square(28));
      expect(path.fillType, PathFillType.evenOdd);

      // A point inside the gap annulus must fall OUTSIDE the clip, so the
      // background shows through there.
      const gapPoint = Offset(14, 14 - 10); // r=10 sits between 9 and 11
      expect(path.contains(gapPoint), isFalse);
      // The ring and the inner disc are both painted.
      expect(path.contains(const Offset(14, 14 - 13)), isTrue);
      expect(path.contains(const Offset(14, 14)), isTrue);
    });

    testWidgets('an unselected gradient swatch clips to a plain circle', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinColorRadialButton.gradient(color: Colors.transparent),
      );

      final clip = tester.widget<ClipPath>(
        find.descendant(
          of: find.byType(FlowinColorRadialButton),
          matching: find.byType(ClipPath),
        ),
      );
      final path = clip.clipper!.getClip(const Size.square(28));

      // No gap when unselected: the whole disc is filled.
      expect(path.contains(const Offset(14, 14)), isTrue);
      expect(path.contains(const Offset(14, 14 - 10)), isTrue);

      // The plain-circle clip never varies, so it never needs reclipping.
      expect(clip.clipper!.shouldReclip(clip.clipper!), isFalse);
    });

    testWidgets('the gradient clip is rebuilt when the geometry changes', (
      tester,
    ) async {
      CustomClipper<Path> clipperFor(WidgetTester tester) => tester
          .widget<ClipPath>(
            find.descendant(
              of: find.byType(FlowinColorRadialButton),
              matching: find.byType(ClipPath),
            ),
          )
          .clipper!;

      await tester.pumpApp(
        FlowinColorRadialButton.gradient(
          color: Colors.transparent,
          selected: true,
        ),
      );
      final first = clipperFor(tester);

      await tester.pumpApp(
        FlowinColorRadialButton.gradient(
          color: Colors.transparent,
          selected: true,
          size: 40,
        ),
      );
      expect(clipperFor(tester).shouldReclip(first), isTrue);
      expect(clipperFor(tester).shouldReclip(clipperFor(tester)), isFalse);
    });

    testWidgets('gradient constructor renders a gradient decoration', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinColorRadialButton.gradient(color: Colors.transparent),
      );

      expect(find.byType(FlowinColorRadialButton), findsOneWidget);

      final hasGradient = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .any((box) {
            final decoration = box.decoration;
            return decoration is BoxDecoration && decoration.gradient != null;
          });
      expect(hasGradient, isTrue);
    });

    testWidgets('default constructor has no gradient decoration', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinColorRadialButton(color: Colors.blue),
      );

      final hasGradient = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .any((box) {
            final decoration = box.decoration;
            return decoration is BoxDecoration && decoration.gradient != null;
          });
      expect(hasGradient, isFalse);
    });

    testWidgets(
      'asserts when size is too small for the border and gap widths',
      (tester) async {
        await tester.pumpApp(
          FlowinColorRadialButton(color: Colors.blue, size: 1),
        );

        final exception = tester.takeException();
        expect(exception, isA<AssertionError>());
        expect(
          (exception as AssertionError).message,
          contains('Invalid size'),
        );
      },
    );

    testWidgets(
      'no tap overlay is painted over the swatch while pressed',
      (tester) async {
        // The contract demands this proof and warns that a structural test
        // cannot supply it: the overlay is painted by the material layer, so
        // it appears in no widget and in no painter call. Without this test
        // the three transparent-overlay lines in the widget are unguarded —
        // deleting them breaks nothing else in the suite.
        //
        // The highlight is drawn as a rect into the swatch's OWN Material
        // (not the app's), and it fades in: sample it late enough to have
        // risen above zero. Suppressed it stays fully transparent; left to
        // the platform it reaches a visible grey.
        await tester.pumpApp(
          FlowinColorRadialButton(color: Colors.blue, onTap: () {}),
        );

        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(FlowinColorRadialButton)),
        );
        // Hold the press — the highlight exists only while the pointer is
        // down — and let the fade run most of its course.
        await tester.pump(const Duration(milliseconds: 500));

        final overlays = <Color>[];
        try {
          expect(
            tester.renderObject(
              find.descendant(
                of: find.byType(FlowinColorRadialButton),
                matching: find.byType(Material),
              ),
            ),
            paints..something((symbol, args) {
              if (symbol == #drawRect) {
                overlays.addAll(args.whereType<Paint>().map((p) => p.color));
              }
              return false;
            }),
          );
        } on TestFailure {
          // `something` returning false always throws; the tally is the point.
        }

        expect(
          overlays,
          isNotEmpty,
          reason: 'the press painted no overlay layer at all — no InkWell?',
        );
        // Two rects are drawn: an opaque black one that fills the clipped
        // ink area in every state, and the highlight itself. Only the
        // highlight carries a tint, so the tell is the COLOUR rather than the
        // alpha — suppressed it is pure black, left to the platform it is the
        // theme's grey (0.7373) fading in.
        for (final overlay in overlays) {
          expect(
            overlay.r == 0 && overlay.g == 0 && overlay.b == 0,
            isTrue,
            reason:
                'a tinted tap overlay was painted over the swatch: '
                '$overlay',
          );
        }

        await gesture.up();
        await tester.pumpAndSettle();
      },
    );
  });
}
