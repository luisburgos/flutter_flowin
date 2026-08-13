import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlowinSpacing', () {
    const spacing = FlowinSpacing();

    test('has Flowin design-token defaults', () {
      expect(spacing.none, FlowinDesignSpace.zero);
      expect(spacing.xxs, FlowinDesignSpace.space100);
      expect(spacing.xs, FlowinDesignSpace.space200);
      expect(spacing.sm, FlowinDesignSpace.space300);
      expect(spacing.md, FlowinDesignSpace.space400);
      expect(spacing.lg, FlowinDesignSpace.space600);
      expect(spacing.xl, FlowinDesignSpace.space800);
      expect(spacing.xxl, FlowinDesignSpace.space1200);
    });

    test('copyWith updates only the provided fields', () {
      final updated = spacing.copyWith(md: 20);
      expect(updated.md, 20);
      expect(updated.lg, spacing.lg);
    });

    test('lerp interpolates between two instances', () {
      const other = FlowinSpacing(md: 32);
      final result = FlowinSpacing.lerp(spacing, other, 0.5);
      expect(result.md, (16 + 32) / 2);
    });
  });

  group('FlowinSemanticColors', () {
    test('light and dark presets differ', () {
      const light = FlowinSemanticColors.light();
      const dark = FlowinSemanticColors.dark();
      expect(light.success, isNot(dark.success));
    });

    test('copyWith updates only the provided fields', () {
      const colors = FlowinSemanticColors.light();
      final updated = colors.copyWith(success: const Color(0xFF000000));
      expect(updated.success, const Color(0xFF000000));
      expect(updated.warning, colors.warning);
    });

    test('lerp interpolates between two instances', () {
      const a = FlowinSemanticColors.light();
      const b = FlowinSemanticColors.dark();
      final result = FlowinSemanticColors.lerp(a, b, 0.5);
      expect(result.success, isNotNull);
      expect(result.warning, isNotNull);
      expect(result.info, isNotNull);
    });
  });

  group('FlowinTokens', () {
    const tokens = FlowinTokens.light();

    test('exposes spacing, semantic colors, shadow and icon size', () {
      expect(tokens.spacing, isA<FlowinSpacing>());
      expect(tokens.semanticColors, isA<FlowinSemanticColors>());
      expect(tokens.shadow, FlowinDesignShadows.shadow100);
      expect(tokens.defaultIconSize, FlowinDesignIconSize.md);
    });

    test('copyWith updates only the provided fields', () {
      final updated = tokens.copyWith(
        defaultIconSize: FlowinDesignIconSize.lg,
      );
      expect(updated.defaultIconSize, FlowinDesignIconSize.lg);
      expect(updated.spacing, tokens.spacing);
    });

    test('copyWith falls back to existing values when args are null', () {
      final updated = tokens.copyWith(spacing: const FlowinSpacing(md: 20));
      expect(updated.spacing.md, 20);
      expect(updated.semanticColors, tokens.semanticColors);
      expect(updated.shadow, tokens.shadow);
      expect(updated.defaultIconSize, tokens.defaultIconSize);
    });

    test(
      'default constructor uses light semantic colors and base defaults',
      () {
        const defaults = FlowinTokens();
        expect(
          defaults.semanticColors.success,
          const FlowinSemanticColors.light().success,
        );
        expect(defaults.shadow, FlowinDesignShadows.shadow100);
        expect(defaults.defaultIconSize, FlowinDesignIconSize.defaultSize);
      },
    );

    test('dark constructor uses dark semantic colors', () {
      const dark = FlowinTokens.dark();
      expect(
        dark.semanticColors.success,
        const FlowinSemanticColors.dark().success,
      );
    });

    test('the elevation shadow colour differs between brightnesses', () {
      // A single shared colour is what produced a halo in dark mode: the
      // light value is a near-white neutral, which lightens rather than
      // darkens the surface it falls on.
      expect(
        const FlowinTokens.dark().shadow.color,
        isNot(const FlowinTokens.light().shadow.color),
      );
    });

    test('the dark elevation shadow is darker than its surface', () {
      // Asserting that a shadow merely exists is insufficient — the
      // light-only value was a valid BoxShadow throughout and still glowed.
      // What makes it a shadow is being darker than its background.
      final shadow = const FlowinTokens.dark().shadow.color;
      final surface = FlowinDesignSchemes.dark.surface;
      expect(
        shadow.computeLuminance(),
        lessThan(surface.computeLuminance()),
        reason: 'a shadow lighter than its surface is a glow',
      );
    });

    test('both elevation shadows share one geometry', () {
      // Only the colour is brightness-aware; a different offset or blur in
      // dark mode would be a second, undocumented elevation.
      const light = FlowinDesignShadows.shadow100;
      const dark = FlowinDesignShadows.shadow100Dark;
      expect(dark.offset, light.offset);
      expect(dark.blurRadius, light.blurRadius);
      expect(dark.spreadRadius, light.spreadRadius);
    });

    test('lerp keeps start icon size below midpoint, end at or above', () {
      const a = FlowinTokens();
      final b = a.copyWith(defaultIconSize: FlowinDesignIconSize.lg);
      expect(a.lerp(b, 0.25).defaultIconSize, a.defaultIconSize);
      expect(a.lerp(b, 0.75).defaultIconSize, b.defaultIconSize);
    });

    test('lerp falls back to start shadow when BoxShadow.lerp is null', () {
      const tokens = FlowinTokens();
      final result = tokens.lerp(const FlowinTokens.dark(), 0.5);
      expect(result.shadow, isA<BoxShadow>());
    });

    test('lerp returns this when other is not FlowinTokens', () {
      expect(tokens.lerp(null, 0.5), tokens);
    });

    test('lerp interpolates spacing and semantic colors', () {
      const other = FlowinTokens.dark();
      final result = tokens.lerp(other, 0.5);
      expect(result, isA<FlowinTokens>());
      expect(result.spacing.md, tokens.spacing.md);
    });
  });
}
