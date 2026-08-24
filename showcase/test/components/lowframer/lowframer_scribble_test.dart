import 'package:flowin_showcase/components/lowframer/lowframer_scribble.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LowframerScribble', () {
    testWidgets('lays out at its given size and paints a stroke', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: LowframerScribble(
              color: Colors.black,
              width: 60,
              height: 10,
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(LowframerScribble));
      expect(size, const Size(60, 10));
      expect(
        find.descendant(
          of: find.byType(LowframerScribble),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('repaints when a knob changes and not when identical', (
      tester,
    ) async {
      CustomPainter painterOf() => tester
          .widget<CustomPaint>(
            find.descendant(
              of: find.byType(LowframerScribble),
              matching: find.byType(CustomPaint),
            ),
          )
          .painter!;

      Widget build(double wavelength) => MaterialApp(
        home: Center(
          child: LowframerScribble(
            color: Colors.black,
            wavelength: wavelength,
          ),
        ),
      );

      await tester.pumpWidget(build(10));
      final first = painterOf();
      expect(first.shouldRepaint(first), isFalse);

      await tester.pumpWidget(build(4));
      final second = painterOf();
      expect(second.shouldRepaint(first), isTrue);
    });
  });
}
