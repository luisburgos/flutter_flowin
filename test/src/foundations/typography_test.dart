// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('titleLarge', () {
    test('is installed into the type scale', () {
      // It was defined but never installed, so the slot carried no Flowin
      // value and a widget reading it inherited from ambient text. The spec
      // binds it like every other named style.
      final scale = FlowinTypefaces.baseline();
      expect(
        scale.titleLarge?.fontSize,
        FlowinBaselineTextTokens.titleLarge.fontSize,
      );
      expect(
        scale.titleLarge?.fontWeight,
        FlowinBaselineTextTokens.titleLarge.fontWeight,
      );
    });
  });
  group('typography', () {
    test('font family names are package-namespaced asset families', () {
      // Package-declared fonts resolve as `packages/<package>/<family>`;
      // the bare family name silently falls back to the platform font.
      expect(interFontFamily, 'packages/flutter_flowin/Inter');
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

    group('FlowinTypefaces', () {
      test('can be constructed', () {
        expect(FlowinTypefaces(), isA<FlowinTypefaces>());
      });

      testWidgets('baseline overlays the baseline tokens onto the text theme', (
        tester,
      ) async {
        final theme = FlowinTypefaces.baseline();

        expect(theme.headlineSmall, FlowinBaselineTextTokens.headlineSmall);
        // titleLarge IS overridden now. Production left it at the Material
        // default, which meant the slot carried no Flowin geometry at all —
        // `fontSize` came back null and a widget reading it inherited from
        // ambient text. The spec binds it like every other named style, so
        // this is a deliberate divergence from the production oracle.
        expect(theme.titleLarge, FlowinBaselineTextTokens.titleLarge);
        expect(theme.titleLarge?.fontFamily, interFontFamily);
        expect(theme.titleLarge?.fontSize, 20);
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
