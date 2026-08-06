import 'dart:math';

import 'package:flutter/material.dart';

/// {@template contrast_compliance}
/// WCAG 2.1 contrast compliance levels.
///
/// Defines the minimum contrast ratio required between a foreground and its
/// background, according to what is being rendered.
/// {@endtemplate}
enum ContrastCompliance {
  /// Normal-sized text (body copy). Requires 4.5:1.
  normalText(4.5),

  /// Large text — 18pt and up, or bold 14pt and up. Requires 3.0:1.
  largeText(3),

  /// Non-text UI: icons, input outlines, borders. Requires 3.0:1.
  uiComponent(3),

  /// Maximum readability (WCAG AAA). Requires 7.0:1.
  aaaNormalText(7);

  /// {@macro contrast_compliance}
  const ContrastCompliance(this.minRatio);

  /// The minimum contrast ratio required at this level.
  final double minRatio;
}

/// {@template border_separation_sensitivity}
/// How eagerly a border is suggested to separate two similar backgrounds.
///
/// When a surface and the colour placed on it are close in luminance, the edge
/// between them disappears. The threshold is the luminance delta below which
/// that is judged to have happened.
/// {@endtemplate}
enum BorderSeparationSensitivity {
  /// Most lenient — a border only when the two are nearly identical.
  relaxed(0.05),

  /// Balanced default.
  normal(0.08),

  /// Strict — suggests a border whenever separation is not strong.
  strict(0.12);

  /// {@macro border_separation_sensitivity}
  const BorderSeparationSensitivity(this.threshold);

  /// The luminance difference below which the two read as visually similar.
  final double threshold;
}

/// {@template accessible_color_config}
/// Resolves an accessible foreground for a caller-supplied colour, and reports
/// whether that colour needs a border to separate it from its background.
///
/// The design system supplies neutrals and semantic roles, not a spectrum, so
/// any colour that comes from *data* — a team's colour, a chart series, a
/// user-picked accent — arrives at a component unvetted. This is the shared
/// answer to the two questions that then follow: what can be legibly drawn on
/// top of it, and does it stand apart from what is behind it.
///
/// It **reports**; it does not repaint. The caller decides what to do with the
/// result, so a colour a designer chose is never silently replaced.
/// {@endtemplate}
@immutable
class AccessibleColorConfig {
  /// Resolves the configuration for [seedColor] drawn on [backgroundColor].
  ///
  /// Foreground candidates are tried in order — [preferredForegroundColor]
  /// first when given, then black, then white — and the first meeting
  /// [compliance] wins. If none does, the highest-contrast candidate is used
  /// and [meetsMinimum] reports false: a best effort, never a silent pass.
  factory AccessibleColorConfig({
    required Color seedColor,
    required Color backgroundColor,
    Color? preferredForegroundColor,
    ContrastCompliance compliance = ContrastCompliance.normalText,
    BorderSeparationSensitivity separationSensitivity =
        BorderSeparationSensitivity.normal,
  }) {
    final needsBorder = _shouldDisplayBorder(
      seedColor,
      backgroundColor,
      separationSensitivity.threshold,
    );

    var bestColor = Colors.black;
    var bestRatio = 0.0;

    for (final candidate in [
      ?preferredForegroundColor,
      Colors.black,
      Colors.white,
    ]) {
      final ratio = flowinContrastRatio(seedColor, candidate);
      if (ratio >= compliance.minRatio) {
        return AccessibleColorConfig._(
          seedColor: seedColor,
          backgroundColor: backgroundColor,
          foregroundColor: candidate,
          contrastRatio: ratio,
          shouldDisplayBorderOnBackground: needsBorder,
          compliance: compliance,
        );
      }
      if (ratio > bestRatio) {
        bestColor = candidate;
        bestRatio = ratio;
      }
    }

    // Nothing met the bar; fall back to the closest and let the caller see it.
    return AccessibleColorConfig._(
      seedColor: seedColor,
      backgroundColor: backgroundColor,
      foregroundColor: bestColor,
      contrastRatio: bestRatio,
      shouldDisplayBorderOnBackground: needsBorder,
      compliance: compliance,
    );
  }

  const AccessibleColorConfig._({
    required this.seedColor,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.contrastRatio,
    required this.shouldDisplayBorderOnBackground,
    required this.compliance,
  });

  /// The caller-supplied colour being evaluated.
  final Color seedColor;

  /// The surface [seedColor] sits on, used for the border decision.
  final Color backgroundColor;

  /// The best available foreground for [seedColor] at [compliance].
  final Color foregroundColor;

  /// The achieved ratio between [seedColor] and [foregroundColor].
  final double contrastRatio;

  /// Whether [seedColor] is too close in luminance to [backgroundColor] to
  /// read as a distinct shape without a border.
  final bool shouldDisplayBorderOnBackground;

  /// The level this configuration was resolved against.
  final ContrastCompliance compliance;

  /// Whether [contrastRatio] satisfies [compliance].
  ///
  /// False means no candidate met the bar and [foregroundColor] is a best
  /// effort — worth surfacing rather than ignoring.
  bool get meetsMinimum => contrastRatio >= compliance.minRatio;

  /// Whether the contrast is enough for normal-sized text (4.5:1).
  bool get isReadable =>
      contrastRatio >= ContrastCompliance.normalText.minRatio;

  /// Whether the contrast is enough for large text (3.0:1).
  bool get isReadableForLargeText =>
      contrastRatio >= ContrastCompliance.largeText.minRatio;
}

/// The WCAG 2.1 contrast ratio between [a] and [b], from 1:1 to 21:1.
/// The WCAG 2.1 contrast ratio between [a] and [b].
///
/// Ranges from 1 (identical colours) to 21 (black on white). Exposed because
/// a caller sometimes needs to measure a *specific* pair, which
/// [AccessibleColorConfig.contrastRatio] cannot answer — that reports the
/// ratio of whichever candidate the resolver chose, which is not the caller's
/// preference when the preference was rejected.
double flowinContrastRatio(Color a, Color b) {
  final first = a.computeLuminance();
  final second = b.computeLuminance();
  return (max(first, second) + 0.05) / (min(first, second) + 0.05);
}

/// Whether [a] and [b] are close enough in luminance to need a border between
/// them.
bool _shouldDisplayBorder(Color a, Color b, double threshold) =>
    (a.computeLuminance() - b.computeLuminance()).abs() < threshold;
