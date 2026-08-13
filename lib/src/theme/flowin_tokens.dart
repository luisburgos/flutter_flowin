import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';
import 'package:flutter_flowin/src/theme/flowin_semantic_colors.dart';
import 'package:flutter_flowin/src/theme/flowin_spacing.dart';

/// {@template flowin_tokens}
/// The Flowin design tokens that live *outside* Material's [ThemeData] surface
/// area — the spacing scale, semantic status colors, the brand text styles, the
/// base shadow, and the default icon size.
///
/// Everything that Material already models (colors via [ColorScheme],
/// typography via [TextTheme], component shapes via component themes) is set on
/// [ThemeData] directly so native widgets pick it up. [FlowinTokens] is the
/// home for the rest, accessed via `context.flowinTokens`.
/// {@endtemplate}
class FlowinTokens extends ThemeExtension<FlowinTokens> {
  /// {@macro flowin_tokens}
  const FlowinTokens({
    this.spacing = const FlowinSpacing(),
    this.semanticColors = const FlowinSemanticColors.light(),
    this.shadow = FlowinDesignShadows.shadow100,
    this.defaultIconSize = FlowinDesignIconSize.defaultSize,
    this.onSurfaceBright = FlowinDesignColors.neutral800,
  });

  /// Light-theme defaults.
  const FlowinTokens.light()
    : spacing = const FlowinSpacing(),
      semanticColors = const FlowinSemanticColors.light(),
      shadow = FlowinDesignShadows.shadow100,
      defaultIconSize = FlowinDesignIconSize.defaultSize,
      onSurfaceBright = FlowinDesignColors.neutral800;

  /// Dark-theme defaults.
  const FlowinTokens.dark()
    : spacing = const FlowinSpacing(),
      semanticColors = const FlowinSemanticColors.dark(),
      // Not shadow100: its colour is a near-white neutral, which reads as a
      // halo rather than a shadow on a dark surface.
      shadow = FlowinDesignShadows.shadow100Dark,
      defaultIconSize = FlowinDesignIconSize.defaultSize,
      onSurfaceBright = FlowinDesignColors.neutral200;

  /// The spacing scale.
  final FlowinSpacing spacing;

  /// Semantic status colors (success / warning / info).
  final FlowinSemanticColors semanticColors;

  /// The base ambient shadow for raised surfaces.
  final BoxShadow shadow;

  /// The default icon size used by Flowin icons.
  final FlowinDesignIconSize defaultIconSize;

  /// Foreground on `ColorScheme.surfaceBright`.
  ///
  /// Lives here rather than on the scheme because Material models the bright
  /// surface but offers no slot for its on-color. Without it the role had no
  /// legible foreground specified, which breaks the role-plus-on-color pairing
  /// the semantic tier is built on.
  final Color onSurfaceBright;

  @override
  FlowinTokens copyWith({
    FlowinSpacing? spacing,
    FlowinSemanticColors? semanticColors,
    BoxShadow? shadow,
    FlowinDesignIconSize? defaultIconSize,
    Color? onSurfaceBright,
  }) {
    return FlowinTokens(
      spacing: spacing ?? this.spacing,
      semanticColors: semanticColors ?? this.semanticColors,
      shadow: shadow ?? this.shadow,
      defaultIconSize: defaultIconSize ?? this.defaultIconSize,
      onSurfaceBright: onSurfaceBright ?? this.onSurfaceBright,
    );
  }

  @override
  FlowinTokens lerp(ThemeExtension<FlowinTokens>? other, double t) {
    if (other is! FlowinTokens) return this;
    return FlowinTokens(
      spacing: FlowinSpacing.lerp(spacing, other.spacing, t),
      semanticColors: FlowinSemanticColors.lerp(
        semanticColors,
        other.semanticColors,
        t,
      ),
      // BoxShadow.lerp can return null; fall back to the start value.
      shadow: BoxShadow.lerp(shadow, other.shadow, t) ?? shadow,
      defaultIconSize: t < 0.5 ? defaultIconSize : other.defaultIconSize,
      // Non-null on both sides, so `Color.lerp` cannot return null here —
      // unlike `BoxShadow.lerp` above, which can.
      onSurfaceBright: Color.lerp(onSurfaceBright, other.onSurfaceBright, t)!,
    );
  }
}
