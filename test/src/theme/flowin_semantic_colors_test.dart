// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlowinSemanticColors', () {
    test('default constructor assigns each field', () {
      final colors = FlowinSemanticColors(
        success: Color(0xFF000001),
        onSuccess: Color(0xFF000002),
        warning: Color(0xFF000003),
        onWarning: Color(0xFF000004),
        info: Color(0xFF000005),
        onInfo: Color(0xFF000006),
      );

      expect(colors.success, Color(0xFF000001));
      expect(colors.onSuccess, Color(0xFF000002));
      expect(colors.warning, Color(0xFF000003));
      expect(colors.onWarning, Color(0xFF000004));
      expect(colors.info, Color(0xFF000005));
      expect(colors.onInfo, Color(0xFF000006));
    });

    test('light constructor uses the light palette variants', () {
      const colors = FlowinSemanticColors.light();

      expect(colors.success, FlowinDesignColors.success500);
      expect(colors.onSuccess, FlowinDesignColors.white);
      expect(colors.warning, FlowinDesignColors.warning500);
      expect(colors.onWarning, FlowinDesignColors.neutral800);
      expect(colors.info, FlowinDesignColors.neutral700);
      expect(colors.onInfo, FlowinDesignColors.white);
    });

    test('dark constructor uses the dark palette variants', () {
      const colors = FlowinSemanticColors.dark();

      expect(colors.success, FlowinDesignColors.success400);
      expect(colors.onSuccess, FlowinDesignColors.neutral800);
      expect(colors.warning, FlowinDesignColors.warning400);
      expect(colors.onWarning, FlowinDesignColors.neutral800);
      expect(colors.info, FlowinDesignColors.neutral200);
      expect(colors.onInfo, FlowinDesignColors.neutral800);
    });

    group('copyWith', () {
      test('replaces every field when each is provided', () {
        const base = FlowinSemanticColors.light();

        final copy = base.copyWith(
          success: Color(0xFF000011),
          onSuccess: Color(0xFF000012),
          warning: Color(0xFF000013),
          onWarning: Color(0xFF000014),
          info: Color(0xFF000015),
          onInfo: Color(0xFF000016),
        );

        expect(copy.success, Color(0xFF000011));
        expect(copy.onSuccess, Color(0xFF000012));
        expect(copy.warning, Color(0xFF000013));
        expect(copy.onWarning, Color(0xFF000014));
        expect(copy.info, Color(0xFF000015));
        expect(copy.onInfo, Color(0xFF000016));
      });

      test('keeps original values when no overrides are given', () {
        const base = FlowinSemanticColors.light();

        final copy = base.copyWith();

        expect(copy.success, base.success);
        expect(copy.onSuccess, base.onSuccess);
        expect(copy.warning, base.warning);
        expect(copy.onWarning, base.onWarning);
        expect(copy.info, base.info);
        expect(copy.onInfo, base.onInfo);
      });
    });

    group('lerp', () {
      test('returns the start value at t = 0', () {
        const a = FlowinSemanticColors.light();
        const b = FlowinSemanticColors.dark();

        final result = FlowinSemanticColors.lerp(a, b, 0);

        expect(result.success, Color.lerp(a.success, b.success, 0));
        expect(result.onSuccess, Color.lerp(a.onSuccess, b.onSuccess, 0));
        expect(result.warning, Color.lerp(a.warning, b.warning, 0));
        expect(result.onWarning, Color.lerp(a.onWarning, b.onWarning, 0));
        expect(result.info, Color.lerp(a.info, b.info, 0));
        expect(result.onInfo, Color.lerp(a.onInfo, b.onInfo, 0));
      });

      test('returns the end value at t = 1', () {
        const a = FlowinSemanticColors.light();
        const b = FlowinSemanticColors.dark();

        final result = FlowinSemanticColors.lerp(a, b, 1);

        expect(result.success, b.success);
        expect(result.onSuccess, b.onSuccess);
        expect(result.warning, b.warning);
        expect(result.onWarning, b.onWarning);
        expect(result.info, b.info);
        expect(result.onInfo, b.onInfo);
      });

      test('interpolates each channel halfway at t = 0.5', () {
        const a = FlowinSemanticColors.light();
        const b = FlowinSemanticColors.dark();

        final result = FlowinSemanticColors.lerp(a, b, 0.5);

        expect(result.success, Color.lerp(a.success, b.success, 0.5));
        expect(result.onSuccess, Color.lerp(a.onSuccess, b.onSuccess, 0.5));
        expect(result.warning, Color.lerp(a.warning, b.warning, 0.5));
        expect(result.onWarning, Color.lerp(a.onWarning, b.onWarning, 0.5));
        expect(result.info, Color.lerp(a.info, b.info, 0.5));
        expect(result.onInfo, Color.lerp(a.onInfo, b.onInfo, 0.5));
      });
    });
  });
}
