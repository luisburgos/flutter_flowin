// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('typography', () {
    test('font family names are package-namespaced asset families', () {
      // Package-declared fonts resolve as `packages/<package>/<family>`;
      // the bare family name silently falls back to the platform font.
      expect(interFontFamily, 'packages/flutter_flowin/Inter');
      expect(supremeFontFamily, 'packages/flutter_flowin/Supreme');
    });

    group('FlowinBaselineTextTokens', () {
      test('can be constructed', () {
        expect(FlowinBaselineTextTokens(), isA<FlowinBaselineTextTokens>());
      });

      testWidgets('headlineSmall has the expected metrics', (tester) async {
        final style = FlowinBaselineTextTokens.headlineSmall;
        expect(style.fontSize, 24);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.height, 32 / 24);
        expect(style.letterSpacing, -0.05);
      });

      testWidgets('titleLarge has the expected metrics', (tester) async {
        final style = FlowinBaselineTextTokens.titleLarge;
        expect(style.fontSize, 20);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.height, 24 / 20);
        expect(style.letterSpacing, 0);
      });

      testWidgets('titleMedium has the expected metrics', (tester) async {
        final style = FlowinBaselineTextTokens.titleMedium;
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.height, 22 / 16);
        expect(style.letterSpacing, 0);
      });

      testWidgets('titleSmall has the expected metrics', (tester) async {
        final style = FlowinBaselineTextTokens.titleSmall;
        expect(style.fontSize, 14);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.height, 20 / 14);
        expect(style.letterSpacing, 0);
      });

      testWidgets('bodyLarge has the expected metrics', (tester) async {
        final style = FlowinBaselineTextTokens.bodyLarge;
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.height, 24 / 16);
        expect(style.letterSpacing, 0);
      });

      testWidgets('bodyMedium has the expected metrics', (tester) async {
        final style = FlowinBaselineTextTokens.bodyMedium;
        expect(style.fontSize, 14);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.height, 22 / 14);
        expect(style.letterSpacing, 0);
      });

      testWidgets('labelLarge has the expected metrics', (tester) async {
        final style = FlowinBaselineTextTokens.labelLarge;
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.height, 16 / 16);
        expect(style.letterSpacing, 0);
      });

      testWidgets('labelMedium has the expected metrics', (tester) async {
        final style = FlowinBaselineTextTokens.labelMedium;
        expect(style.fontSize, 14);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.height, 14 / 14);
        expect(style.letterSpacing, 0);
      });

      testWidgets('labelSmall has the expected metrics', (tester) async {
        final style = FlowinBaselineTextTokens.labelSmall;
        expect(style.fontSize, 12);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.height, 12 / 12);
        expect(style.letterSpacing, 0);
      });

      testWidgets('captionLarge has the expected metrics', (tester) async {
        final style = FlowinBaselineTextTokens.captionLarge;
        expect(style.fontSize, 12);
        expect(style.fontWeight, FontWeight.w500);
        expect(style.height, 20 / 12);
        expect(style.letterSpacing, 0);
      });

      testWidgets('captionMedium has the expected metrics', (tester) async {
        final style = FlowinBaselineTextTokens.captionMedium;
        expect(style.fontSize, 10);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.height, 16 / 10);
        expect(style.letterSpacing, 0.2);
      });
    });

    group('FlowinBrandTextTokens', () {
      test('can be constructed', () {
        expect(FlowinBrandTextTokens(), isA<FlowinBrandTextTokens>());
      });

      test('displayXL has the expected metrics', () {
        final style = FlowinBrandTextTokens.displayXL;
        expect(style.fontFamily, supremeFontFamily);
        expect(style.fontSize, 160);
        expect(style.fontWeight, FontWeight.w700);
        expect(style.height, 1);
        expect(style.letterSpacing, -2);
      });

      test('displayLG has the expected metrics', () {
        final style = FlowinBrandTextTokens.displayLG;
        expect(style.fontFamily, supremeFontFamily);
        expect(style.fontSize, 80);
        expect(style.fontWeight, FontWeight.w700);
        expect(style.height, 1);
        expect(style.letterSpacing, -1);
      });

      test('headlineLarge has the expected metrics', () {
        final style = FlowinBrandTextTokens.headlineLarge;
        expect(style.fontFamily, supremeFontFamily);
        expect(style.fontSize, 48);
        expect(style.fontWeight, FontWeight.w700);
        expect(style.height, 56 / 48);
        expect(style.letterSpacing, 0);
      });

      test('headlineSmall has the expected metrics', () {
        final style = FlowinBrandTextTokens.headlineSmall;
        expect(style.fontFamily, supremeFontFamily);
        expect(style.fontSize, 24);
        expect(style.fontWeight, FontWeight.w700);
        expect(style.height, 32 / 24);
        expect(style.letterSpacing, 0.2);
      });

      test('titleMedium has the expected metrics', () {
        final style = FlowinBrandTextTokens.titleMedium;
        expect(style.fontFamily, supremeFontFamily);
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w700);
        expect(style.height, 24 / 16);
        expect(style.letterSpacing, 0.2);
      });

      test('titleSmall has the expected metrics', () {
        final style = FlowinBrandTextTokens.titleSmall;
        expect(style.fontFamily, supremeFontFamily);
        expect(style.fontSize, 14);
        expect(style.fontWeight, FontWeight.w700);
        expect(style.height, 20 / 14);
        expect(style.letterSpacing, 0.2);
      });

      test('bodyLarge has the expected metrics', () {
        final style = FlowinBrandTextTokens.bodyLarge;
        expect(style.fontFamily, supremeFontFamily);
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w500);
        expect(style.height, 24 / 16);
        expect(style.letterSpacing, 0.5);
      });
    });

    group('FlowinBaselineTextTheme extension', () {
      test('exposes the caption tokens on TextTheme', () {
        const textTheme = TextTheme();
        expect(
          textTheme.captionLarge,
          FlowinBaselineTextTokens.captionLarge,
        );
        expect(
          textTheme.captionMedium,
          FlowinBaselineTextTokens.captionMedium,
        );
      });
    });

    group('FlowinBrandTextTheme extension', () {
      test('exposes the brand tokens on TextTheme', () {
        const textTheme = TextTheme();
        expect(textTheme.brandDisplayXL, FlowinBrandTextTokens.displayXL);
        expect(textTheme.brandDisplayLG, FlowinBrandTextTokens.displayLG);
        expect(
          textTheme.brandHeadlineLarge,
          FlowinBrandTextTokens.headlineLarge,
        );
        expect(
          textTheme.brandHeadlineSmall,
          FlowinBrandTextTokens.headlineSmall,
        );
        expect(textTheme.brandTitleMedium, FlowinBrandTextTokens.titleMedium);
        expect(textTheme.brandTitleSmall, FlowinBrandTextTokens.titleSmall);
        expect(textTheme.brandBodyLarge, FlowinBrandTextTokens.bodyLarge);
      });
    });

    group('FlowinTypefaces', () {
      test('can be constructed', () {
        expect(FlowinTypefaces(), isA<FlowinTypefaces>());
      });

      testWidgets('baseline overlays the baseline tokens onto the text theme', (
        tester,
      ) async {
        final theme = FlowinTypefaces.baseline();

        expect(theme.headlineSmall, FlowinBaselineTextTokens.headlineSmall);
        // titleLarge is intentionally NOT overridden — production
        // (flowin_design, fidelity oracle 0.3.0) leaves it at the Material
        // 2021 default rendered in Inter. Probable upstream oversight; kept
        // for fidelity.
        expect(theme.titleLarge, isNot(FlowinBaselineTextTokens.titleLarge));
        expect(theme.titleLarge?.fontFamily, interFontFamily);
        // `.black` carries only color/family; geometry (22px w400) is merged
        // in by ThemeData's Typography at theme-build time.
        expect(theme.titleLarge?.fontSize, isNull);
        expect(theme.titleMedium, FlowinBaselineTextTokens.titleMedium);
        expect(theme.titleSmall, FlowinBaselineTextTokens.titleSmall);
        expect(theme.bodyLarge, FlowinBaselineTextTokens.bodyLarge);
        expect(theme.bodyMedium, FlowinBaselineTextTokens.bodyMedium);
        expect(theme.labelLarge, FlowinBaselineTextTokens.labelLarge);
        expect(theme.labelMedium, FlowinBaselineTextTokens.labelMedium);
        expect(theme.labelSmall, FlowinBaselineTextTokens.labelSmall);
      });
    });
  });
}
