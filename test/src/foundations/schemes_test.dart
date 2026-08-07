import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlowinDesignSchemes', () {
    test('can be instantiated', () {
      expect(const FlowinDesignSchemes(), isNotNull);
    });

    group('light', () {
      test('is a light ColorScheme', () {
        expect(FlowinDesignSchemes.light.brightness, Brightness.light);
      });

      test('maps the Flowin palette onto Material roles', () {
        const scheme = FlowinDesignSchemes.light;
        expect(scheme.primary, FlowinDesignColors.primary800);
        expect(scheme.onPrimary, FlowinDesignColors.white);
        expect(scheme.secondary, FlowinDesignColors.secondary200);
        expect(scheme.onSecondary, FlowinDesignColors.secondary800);
        expect(scheme.tertiary, FlowinDesignColors.tertiary100);
        expect(scheme.onTertiary, FlowinDesignColors.tertiary800);
        expect(scheme.surface, FlowinDesignColors.white);
        expect(scheme.onSurface, FlowinDesignColors.neutral800);
        expect(scheme.onSurfaceVariant, FlowinDesignColors.neutral400);
        expect(scheme.inverseSurface, FlowinDesignColors.neutral700);
        expect(scheme.onInverseSurface, FlowinDesignColors.white);
        expect(scheme.shadow, FlowinDesignColors.neutral200);
        expect(scheme.primaryContainer, FlowinDesignColors.primary800);
        expect(scheme.onPrimaryContainer, FlowinDesignColors.white);
        expect(scheme.secondaryContainer, FlowinDesignColors.secondary200);
        expect(scheme.onSecondaryContainer, FlowinDesignColors.secondary800);
        expect(scheme.outline, FlowinDesignColors.neutral800);
        expect(scheme.outlineVariant, FlowinDesignColors.neutral200);
        expect(scheme.error, FlowinDesignColors.error500);
        expect(scheme.onError, FlowinDesignColors.white);
        expect(scheme.errorContainer, FlowinDesignColors.error100);
        expect(scheme.onErrorContainer, FlowinDesignColors.error500);
      });
    });

    group('dark', () {
      test('is a dark ColorScheme', () {
        expect(FlowinDesignSchemes.dark.brightness, Brightness.dark);
      });

      test('maps the Flowin palette onto Material roles', () {
        const scheme = FlowinDesignSchemes.dark;
        expect(scheme.primary, FlowinDesignColors.primary200);
        expect(scheme.onPrimary, FlowinDesignColors.primary800);
        expect(scheme.secondary, FlowinDesignColors.secondary700);
        expect(scheme.onSecondary, FlowinDesignColors.secondary200);
        expect(scheme.tertiary, FlowinDesignColors.tertiary500);
        expect(scheme.onTertiary, FlowinDesignColors.tertiary800);
        expect(scheme.surface, FlowinDesignColors.neutral800);
        expect(scheme.onSurface, FlowinDesignColors.neutral200);
        expect(scheme.onSurfaceVariant, FlowinDesignColors.neutral400);
        expect(scheme.surfaceBright, FlowinDesignColors.neutral700);
        expect(scheme.inverseSurface, FlowinDesignColors.white);
        expect(scheme.onInverseSurface, FlowinDesignColors.neutral800);
        // Black, not neutral700: one ramp step from the neutral800 surface
        // reads as nothing. Kept equal to shadow100Dark — see the theme test.
        expect(scheme.shadow, FlowinDesignColors.black);
        expect(scheme.primaryContainer, FlowinDesignColors.primary200);
        expect(scheme.onPrimaryContainer, FlowinDesignColors.primary800);
        expect(scheme.secondaryContainer, FlowinDesignColors.secondary700);
        expect(scheme.onSecondaryContainer, FlowinDesignColors.secondary200);
        expect(scheme.outline, FlowinDesignColors.neutral200);
        expect(scheme.outlineVariant, FlowinDesignColors.neutral700);
        expect(scheme.error, FlowinDesignColors.error500);
        expect(scheme.onError, FlowinDesignColors.white);
        expect(scheme.errorContainer, FlowinDesignColors.error800);
        expect(scheme.onErrorContainer, FlowinDesignColors.error500);
      });
    });
  });

  group('FlowinColorSchemeExt', () {
    test('fixedNeutral200 returns a brightness-independent neutral-200', () {
      expect(
        FlowinDesignSchemes.light.fixedNeutral200,
        FlowinDesignColors.neutral200,
      );
      expect(
        FlowinDesignSchemes.dark.fixedNeutral200,
        FlowinDesignColors.neutral200,
      );
    });

    test('fixedNeutral600 returns a brightness-independent neutral-600', () {
      expect(
        FlowinDesignSchemes.light.fixedNeutral600,
        FlowinDesignColors.neutral600,
      );
      expect(
        FlowinDesignSchemes.dark.fixedNeutral600,
        FlowinDesignColors.neutral600,
      );
    });

    test('fixedSuccess returns a brightness-independent success color', () {
      expect(
        FlowinDesignSchemes.light.fixedSuccess,
        FlowinDesignColors.success500,
      );
      expect(
        FlowinDesignSchemes.dark.fixedSuccess,
        FlowinDesignColors.success500,
      );
    });
  });
}
