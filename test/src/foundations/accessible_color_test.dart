import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContrastCompliance', () {
    test('carries the WCAG 2.1 minimum ratios', () {
      expect(ContrastCompliance.normalText.minRatio, 4.5);
      expect(ContrastCompliance.largeText.minRatio, 3.0);
      expect(ContrastCompliance.uiComponent.minRatio, 3.0);
      expect(ContrastCompliance.aaaNormalText.minRatio, 7.0);
    });
  });

  group('BorderSeparationSensitivity', () {
    test('orders its thresholds from lenient to strict', () {
      expect(BorderSeparationSensitivity.relaxed.threshold, 0.05);
      expect(BorderSeparationSensitivity.normal.threshold, 0.08);
      expect(BorderSeparationSensitivity.strict.threshold, 0.12);
      expect(
        BorderSeparationSensitivity.relaxed.threshold,
        lessThan(BorderSeparationSensitivity.strict.threshold),
      );
    });
  });

  group('AccessibleColorConfig contrast ratio', () {
    test('black on white is the WCAG maximum of 21:1', () {
      final config = AccessibleColorConfig(
        seedColor: Colors.white,
        backgroundColor: Colors.white,
      );
      expect(config.foregroundColor, Colors.black);
      expect(config.contrastRatio, closeTo(21, 0.01));
    });

    test('a colour against itself is the minimum of 1:1', () {
      // Mid-grey fails every candidate, so the best effort is reported.
      const grey = Color(0xFF7F7F7F);
      final config = AccessibleColorConfig(
        seedColor: grey,
        backgroundColor: Colors.white,
        compliance: ContrastCompliance.aaaNormalText,
      );
      expect(config.meetsMinimum, isFalse);
      expect(config.contrastRatio, greaterThan(1));
    });
  });

  group('AccessibleColorConfig foreground selection', () {
    test('prefers the caller candidate when it meets the level', () {
      const preferred = Color(0xFFFFFFFF);
      final config = AccessibleColorConfig(
        seedColor: Colors.black,
        backgroundColor: Colors.black,
        preferredForegroundColor: preferred,
      );
      expect(config.foregroundColor, preferred);
      expect(config.meetsMinimum, isTrue);
    });

    test('falls through to black when the caller candidate is too weak', () {
      // Near-white preferred on a white seed: unreadable, so black wins.
      final config = AccessibleColorConfig(
        seedColor: Colors.white,
        backgroundColor: Colors.white,
        preferredForegroundColor: const Color(0xFFFEFEFE),
      );
      expect(config.foregroundColor, Colors.black);
    });

    test('falls through to white on a dark seed', () {
      final config = AccessibleColorConfig(
        seedColor: const Color(0xFF1A1A1A),
        backgroundColor: Colors.white,
      );
      expect(config.foregroundColor, Colors.white);
      expect(config.meetsMinimum, isTrue);
    });

    test(
      'reports the best effort when NO candidate meets the level, rather '
      'than silently passing',
      () {
        // Mid-grey cannot reach 7:1 against black or white.
        const grey = Color(0xFF808080);
        final config = AccessibleColorConfig(
          seedColor: grey,
          backgroundColor: Colors.white,
          compliance: ContrastCompliance.aaaNormalText,
        );

        expect(config.meetsMinimum, isFalse);
        expect(config.contrastRatio, lessThan(7));
        // Still the better of the two candidates.
        expect(config.foregroundColor, anyOf(Colors.black, Colors.white));
      },
    );
  });

  group('AccessibleColorConfig border separation', () {
    test('flags a border when the seed and background are near-identical', () {
      final config = AccessibleColorConfig(
        seedColor: Colors.white,
        backgroundColor: Colors.white,
      );
      expect(config.shouldDisplayBorderOnBackground, isTrue);
    });

    test('needs no border when the seed contrasts with the background', () {
      final config = AccessibleColorConfig(
        seedColor: Colors.black,
        backgroundColor: Colors.white,
      );
      expect(config.shouldDisplayBorderOnBackground, isFalse);
    });

    test('sensitivity moves the threshold', () {
      // #F7F7F7 on white: luminance delta ~0.072 — above relaxed (0.05) so it
      // reads as separated, below strict (0.12) so it does not. The pair sits
      // deliberately between the two thresholds.
      const seed = Color(0xFFF7F7F7);
      const background = Color(0xFFFFFFFF);

      final relaxed = AccessibleColorConfig(
        seedColor: seed,
        backgroundColor: background,
        separationSensitivity: BorderSeparationSensitivity.relaxed,
      );
      final strict = AccessibleColorConfig(
        seedColor: seed,
        backgroundColor: background,
        separationSensitivity: BorderSeparationSensitivity.strict,
      );

      expect(relaxed.shouldDisplayBorderOnBackground, isFalse);
      expect(strict.shouldDisplayBorderOnBackground, isTrue);
    });
  });

  group('AccessibleColorConfig readability getters', () {
    test('black on white is readable at both text levels', () {
      final config = AccessibleColorConfig(
        seedColor: Colors.white,
        backgroundColor: Colors.grey,
      );
      expect(config.isReadable, isTrue);
      expect(config.isReadableForLargeText, isTrue);
    });

    test('a weak pairing is readable for large text but not normal text', () {
      // A near-white preferred foreground on #949494 reaches 3.03:1 — over the
      // large-text bar (3.0) and under the normal-text bar (4.5). Requesting
      // largeText lets that candidate win instead of falling through to black.
      final config = AccessibleColorConfig(
        seedColor: const Color(0xFF949494),
        backgroundColor: Colors.white,
        preferredForegroundColor: Colors.white,
        compliance: ContrastCompliance.largeText,
      );
      expect(config.foregroundColor, Colors.white);
      expect(config.isReadableForLargeText, isTrue);
      expect(config.isReadable, isFalse);
    });
  });

  group('AccessibleColorConfig surface', () {
    test('retains the inputs it was resolved from', () {
      const seed = Color(0xFF3DA20B);
      const background = Color(0xFFF3F3F3);
      final config = AccessibleColorConfig(
        seedColor: seed,
        backgroundColor: background,
        compliance: ContrastCompliance.uiComponent,
      );

      expect(config.seedColor, seed);
      expect(config.backgroundColor, background);
      expect(config.compliance, ContrastCompliance.uiComponent);
    });
  });
}
