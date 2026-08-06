// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

const _svg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <rect width="24" height="24" />
</svg>''';

/// Returns the single [SvgPicture] rendered by the [FDSvgIcon].
SvgPicture _svgPicture(WidgetTester tester) {
  return tester.widget<SvgPicture>(find.byType(SvgPicture));
}

void main() {
  group('FDSvgIcons', () {
    test('can be constructed', () {
      expect(FDSvgIcons(), isA<FDSvgIcons>());
    });
  });

  group('FDSvgIcon', () {
    testWidgets('renders an SvgPicture for the given icon string', (
      tester,
    ) async {
      await tester.pumpApp(FDSvgIcon(_svg));

      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('applies a srcIn color filter when color is provided', (
      tester,
    ) async {
      const color = Color(0xFF112233);
      await tester.pumpApp(FDSvgIcon(_svg, color: color));

      final picture = _svgPicture(tester);
      expect(
        picture.colorFilter,
        ColorFilter.mode(color, BlendMode.srcIn),
      );
    });

    testWidgets('applies no color filter when color is null', (tester) async {
      await tester.pumpApp(FDSvgIcon(_svg));

      expect(_svgPicture(tester).colorFilter, isNull);
    });

    testWidgets('uses size for both width and height', (tester) async {
      await tester.pumpApp(FDSvgIcon(_svg, size: 48));

      final picture = _svgPicture(tester);
      expect(picture.width, 48);
      expect(picture.height, 48);
    });

    testWidgets('defaults size to 24', (tester) async {
      await tester.pumpApp(FDSvgIcon(_svg));

      final picture = _svgPicture(tester);
      expect(picture.width, 24);
      expect(picture.height, 24);
    });

    testWidgets('forwards the alignment to the SvgPicture', (tester) async {
      await tester.pumpApp(
        FDSvgIcon(_svg, alignment: Alignment.topLeft),
      );

      expect(_svgPicture(tester).alignment, Alignment.topLeft);
    });

    testWidgets('defaults alignment to center', (tester) async {
      await tester.pumpApp(FDSvgIcon(_svg));

      expect(_svgPicture(tester).alignment, Alignment.center);
    });
  });
}
