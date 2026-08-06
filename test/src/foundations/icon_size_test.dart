import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlowinDesignIconSize', () {
    test('exposes the expected pixel values', () {
      expect(FlowinDesignIconSize.xs.value, 12);
      expect(FlowinDesignIconSize.sm.value, 16);
      expect(FlowinDesignIconSize.md.value, 20);
      expect(FlowinDesignIconSize.lg.value, 24);
      expect(FlowinDesignIconSize.xl.value, 32);
      expect(FlowinDesignIconSize.xxl.value, 40);
    });

    test('defaultSize is md', () {
      expect(FlowinDesignIconSize.defaultSize, FlowinDesignIconSize.md);
    });

    group('fromValue', () {
      test('returns the size whose value matches', () {
        expect(FlowinDesignIconSize.fromValue(12), FlowinDesignIconSize.xs);
        expect(FlowinDesignIconSize.fromValue(16), FlowinDesignIconSize.sm);
        expect(FlowinDesignIconSize.fromValue(20), FlowinDesignIconSize.md);
        expect(FlowinDesignIconSize.fromValue(24), FlowinDesignIconSize.lg);
        expect(FlowinDesignIconSize.fromValue(32), FlowinDesignIconSize.xl);
        expect(FlowinDesignIconSize.fromValue(40), FlowinDesignIconSize.xxl);
      });

      test('throws an ArgumentError when no size matches', () {
        expect(
          () => FlowinDesignIconSize.fromValue(99),
          throwsArgumentError,
        );
      });
    });

    group('stroke', () {
      test('pairs each size with its stroke weight', () {
        expect(FlowinDesignIconSize.xs.stroke, 1.25);
        expect(FlowinDesignIconSize.sm.stroke, 1.5);
        expect(FlowinDesignIconSize.md.stroke, 1.75);
        expect(FlowinDesignIconSize.lg.stroke, 2);
        expect(FlowinDesignIconSize.xl.stroke, 2.5);
        expect(FlowinDesignIconSize.xxl.stroke, 3);
      });
    });
  });
}
