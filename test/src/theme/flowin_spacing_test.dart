import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlowinSpacing', () {
    test('default constructor uses the Flowin design tokens', () {
      const spacing = FlowinSpacing();

      expect(spacing.none, FlowinDesignSpace.zero);
      expect(spacing.xxs, FlowinDesignSpace.space100);
      expect(spacing.xs, FlowinDesignSpace.space200);
      expect(spacing.sm, FlowinDesignSpace.space300);
      expect(spacing.md, FlowinDesignSpace.space400);
      expect(spacing.lg, FlowinDesignSpace.space600);
      expect(spacing.xl, FlowinDesignSpace.space800);
      expect(spacing.xxl, FlowinDesignSpace.space1200);
    });

    test('constructor honours overridden steps', () {
      const spacing = FlowinSpacing(
        none: 1,
        xxs: 2,
        xs: 3,
        sm: 4,
        md: 5,
        lg: 6,
        xl: 7,
        xxl: 8,
      );

      expect(spacing.none, 1);
      expect(spacing.xxs, 2);
      expect(spacing.xs, 3);
      expect(spacing.sm, 4);
      expect(spacing.md, 5);
      expect(spacing.lg, 6);
      expect(spacing.xl, 7);
      expect(spacing.xxl, 8);
    });

    group('copyWith', () {
      test('replaces every provided field', () {
        const original = FlowinSpacing();

        final copy = original.copyWith(
          none: 10,
          xxs: 11,
          xs: 12,
          sm: 13,
          md: 14,
          lg: 15,
          xl: 16,
          xxl: 17,
        );

        expect(copy.none, 10);
        expect(copy.xxs, 11);
        expect(copy.xs, 12);
        expect(copy.sm, 13);
        expect(copy.md, 14);
        expect(copy.lg, 15);
        expect(copy.xl, 16);
        expect(copy.xxl, 17);
      });

      test('keeps existing values when no fields are provided', () {
        const original = FlowinSpacing(
          none: 1,
          xxs: 2,
          xs: 3,
          sm: 4,
          md: 5,
          lg: 6,
          xl: 7,
          xxl: 8,
        );

        final copy = original.copyWith();

        expect(copy.none, original.none);
        expect(copy.xxs, original.xxs);
        expect(copy.xs, original.xs);
        expect(copy.sm, original.sm);
        expect(copy.md, original.md);
        expect(copy.lg, original.lg);
        expect(copy.xl, original.xl);
        expect(copy.xxl, original.xxl);
      });

      test('replaces only the md step in isolation', () {
        const original = FlowinSpacing();

        final copy = original.copyWith(md: 99);

        expect(copy.md, 99);
        expect(copy.none, original.none);
        expect(copy.xxs, original.xxs);
        expect(copy.xs, original.xs);
        expect(copy.sm, original.sm);
        expect(copy.lg, original.lg);
        expect(copy.xl, original.xl);
        expect(copy.xxl, original.xxl);
      });
    });

    group('lerp', () {
      test('returns the start value at t = 0', () {
        const a = FlowinSpacing();
        const b = FlowinSpacing(
          none: 100,
          xxs: 100,
          xs: 100,
          sm: 100,
          md: 100,
          lg: 100,
          xl: 100,
          xxl: 100,
        );

        final result = FlowinSpacing.lerp(a, b, 0);

        expect(result.none, a.none);
        expect(result.xxs, a.xxs);
        expect(result.xs, a.xs);
        expect(result.sm, a.sm);
        expect(result.md, a.md);
        expect(result.lg, a.lg);
        expect(result.xl, a.xl);
        expect(result.xxl, a.xxl);
      });

      test('returns the end value at t = 1', () {
        const a = FlowinSpacing();
        const b = FlowinSpacing(
          none: 100,
          xxs: 100,
          xs: 100,
          sm: 100,
          md: 100,
          lg: 100,
          xl: 100,
          xxl: 100,
        );

        final result = FlowinSpacing.lerp(a, b, 1);

        expect(result.none, b.none);
        expect(result.xxs, b.xxs);
        expect(result.xs, b.xs);
        expect(result.sm, b.sm);
        expect(result.md, b.md);
        expect(result.lg, b.lg);
        expect(result.xl, b.xl);
        expect(result.xxl, b.xxl);
      });

      test('interpolates each step at the midpoint', () {
        const a = FlowinSpacing(
          none: 2,
          xxs: 6,
          xs: 10,
          sm: 14,
          md: 18,
          lg: 22,
          xl: 26,
          xxl: 30,
        );
        const b = FlowinSpacing(
          none: 12,
          xxs: 26,
          xs: 30,
          sm: 46,
          md: 50,
          lg: 62,
          xl: 70,
          xxl: 90,
        );

        final result = FlowinSpacing.lerp(a, b, 0.5);

        expect(result.none, 7);
        expect(result.xxs, 16);
        expect(result.xs, 20);
        expect(result.sm, 30);
        expect(result.md, 34);
        expect(result.lg, 42);
        expect(result.xl, 48);
        expect(result.xxl, 60);
      });
    });
  });
}
