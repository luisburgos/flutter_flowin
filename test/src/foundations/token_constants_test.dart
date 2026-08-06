// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlowinDesignBorders', () {
    test('can be constructed', () {
      expect(FlowinDesignBorders(), isA<FlowinDesignBorders>());
    });

    test('exposes the border-width scale', () {
      expect(FlowinDesignBorders.regular, 1);
      expect(FlowinDesignBorders.bold, 2);
      expect(FlowinDesignBorders.extraBold, 3);
    });
  });

  group('FlowinDesignColors', () {
    test('can be constructed', () {
      expect(FlowinDesignColors(), isA<FlowinDesignColors>());
    });

    test('exposes the base palette', () {
      expect(FlowinDesignColors.white, Colors.white);
      expect(FlowinDesignColors.black, Colors.black);
    });

    test('exposes the neutral ramp', () {
      expect(FlowinDesignColors.neutral800, const Color(0xFF181818));
      expect(FlowinDesignColors.neutral700, const Color(0xFF313131));
      expect(FlowinDesignColors.neutral600, const Color(0xFF494949));
      expect(FlowinDesignColors.neutral500, const Color(0xFF7A7A7A));
      expect(FlowinDesignColors.neutral400, const Color(0xFFABABAB));
      expect(FlowinDesignColors.neutral300, const Color(0xFFDBDBDB));
      expect(FlowinDesignColors.neutral200, const Color(0xFFF3F3F3));
      expect(FlowinDesignColors.neutral100, const Color(0xFFF9F9F9));
    });

    test('exposes the error ramp', () {
      expect(FlowinDesignColors.error800, const Color(0xFF55161F));
      expect(FlowinDesignColors.error700, const Color(0xFF821D1B));
      expect(FlowinDesignColors.error600, const Color(0xFFAC1F1D));
      expect(FlowinDesignColors.error500, const Color(0xFFEC221F));
      expect(FlowinDesignColors.error400, const Color(0xFFF15957));
      expect(FlowinDesignColors.error300, const Color(0xFFF5918F));
      expect(FlowinDesignColors.error200, const Color(0xFFFDE9E9));
      expect(FlowinDesignColors.error100, const Color(0xFFFEF7F7));
    });

    test('exposes the warning ramp', () {
      expect(FlowinDesignColors.warning800, const Color(0xFFBD6F10));
      expect(FlowinDesignColors.warning700, const Color(0xFFEDA043));
      expect(FlowinDesignColors.warning600, const Color(0xFFEDB143));
      expect(FlowinDesignColors.warning500, const Color(0xFFEABF24));
      expect(FlowinDesignColors.warning400, const Color(0xFFF1D672));
      expect(FlowinDesignColors.warning300, const Color(0xFFF6E3A1));
      expect(FlowinDesignColors.warning200, const Color(0xFFFBF1D0));
      expect(FlowinDesignColors.warning100, const Color(0xFFFDF8E7));
    });

    test('exposes the success ramp', () {
      expect(FlowinDesignColors.success800, const Color(0xFF213B15));
      expect(FlowinDesignColors.success700, const Color(0xFF2B5D12));
      expect(FlowinDesignColors.success600, const Color(0xFF34800E));
      expect(FlowinDesignColors.success500, const Color(0xFF3DA20B));
      expect(FlowinDesignColors.success400, const Color(0xFF6EB948));
      expect(FlowinDesignColors.success300, const Color(0xFF9ED185));
      expect(FlowinDesignColors.success200, const Color(0xFFCEE8C2));
      expect(FlowinDesignColors.success100, const Color(0xFFE7F3E1));
    });

    test('exposes the primary ramp', () {
      expect(FlowinDesignColors.primary800, const Color(0xFF181818));
      expect(FlowinDesignColors.primary700, const Color(0xFF313131));
      expect(FlowinDesignColors.primary600, const Color(0xFF494949));
      expect(FlowinDesignColors.primary500, const Color(0xFF7A7A7A));
      expect(FlowinDesignColors.primary400, const Color(0xFFB6B6B6));
      expect(FlowinDesignColors.primary300, const Color(0xFFDBDBDB));
      expect(FlowinDesignColors.primary200, const Color(0xFFF3F3F3));
      expect(FlowinDesignColors.primary100, const Color(0xFFF9F9F9));
    });

    test('exposes the secondary ramp', () {
      expect(FlowinDesignColors.secondary800, const Color(0xFF181818));
      expect(FlowinDesignColors.secondary700, const Color(0xFF313131));
      expect(FlowinDesignColors.secondary600, const Color(0xFF494949));
      expect(FlowinDesignColors.secondary500, const Color(0xFF7A7A7A));
      expect(FlowinDesignColors.secondary400, const Color(0xFFB6B6B6));
      expect(FlowinDesignColors.secondary300, const Color(0xFFDBDBDB));
      expect(FlowinDesignColors.secondary200, const Color(0xFFF3F3F3));
      expect(FlowinDesignColors.secondary100, const Color(0xFFF9F9F9));
    });

    test('exposes the tertiary ramp', () {
      expect(FlowinDesignColors.tertiary800, const Color(0xFF181818));
      expect(FlowinDesignColors.tertiary700, const Color(0xFF313131));
      expect(FlowinDesignColors.tertiary600, const Color(0xFF494949));
      expect(FlowinDesignColors.tertiary500, const Color(0xFF7A7A7A));
      expect(FlowinDesignColors.tertiary400, const Color(0xFFB6B6B6));
      expect(FlowinDesignColors.tertiary300, const Color(0xFFDBDBDB));
      expect(FlowinDesignColors.tertiary200, const Color(0xFFF3F3F3));
      expect(FlowinDesignColors.tertiary100, const Color(0xFFF9F9F9));
    });
  });

  group('FlowinDesignRadius', () {
    test('can be constructed', () {
      expect(FlowinDesignRadius(), isA<FlowinDesignRadius>());
    });

    test('exposes the radius scale', () {
      expect(FlowinDesignRadius.radius100, 4);
      expect(FlowinDesignRadius.radius200, 8);
      expect(FlowinDesignRadius.radius300, 12);
      expect(FlowinDesignRadius.radius400, 16);
      expect(FlowinDesignRadius.radius500, 24);
      expect(FlowinDesignRadius.radius600, 26);
      expect(FlowinDesignRadius.radius700, 28);
      expect(FlowinDesignRadius.radius800, 32);
      expect(FlowinDesignRadius.radius1000, 40);
    });

    test('exposes the iOS smoothing and pill radius', () {
      expect(FlowinDesignRadius.iOSSmooth, 0.6);
      expect(FlowinDesignRadius.full, 9999);
    });
  });

  group('FlowinDesignShadows', () {
    test('can be constructed', () {
      expect(FlowinDesignShadows(), isA<FlowinDesignShadows>());
    });

    test('shadow100 is the base ambient elevation shadow', () {
      const shadow = FlowinDesignShadows.shadow100;
      expect(shadow.color, FlowinDesignColors.neutral200);
      expect(shadow.offset, const Offset(0, 8));
      expect(shadow.blurRadius, 32);
      expect(shadow.spreadRadius, 5);
    });
  });

  group('FlowinDesignSpace', () {
    test('can be constructed', () {
      expect(FlowinDesignSpace(), isA<FlowinDesignSpace>());
    });

    test('exposes the spacing scale', () {
      expect(FlowinDesignSpace.zero, 0);
      expect(FlowinDesignSpace.space50, 2);
      expect(FlowinDesignSpace.space100, 4);
      expect(FlowinDesignSpace.space150, 6);
      expect(FlowinDesignSpace.space200, 8);
      expect(FlowinDesignSpace.space250, 10);
      expect(FlowinDesignSpace.space300, 12);
      expect(FlowinDesignSpace.space400, 16);
      expect(FlowinDesignSpace.space600, 24);
      expect(FlowinDesignSpace.space700, 28);
      expect(FlowinDesignSpace.space800, 32);
      expect(FlowinDesignSpace.space1000, 40);
      expect(FlowinDesignSpace.space1200, 48);
      expect(FlowinDesignSpace.space1400, 56);
      expect(FlowinDesignSpace.space1600, 64);
      expect(FlowinDesignSpace.space2400, 96);
      expect(FlowinDesignSpace.space4000, 160);
    });
  });
}
