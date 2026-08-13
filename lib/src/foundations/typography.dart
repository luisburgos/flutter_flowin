import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The Inter family as registered by the Flutter asset bundle.
///
/// Fonts declared by a package are namespaced `packages/<package>/<family>`.
/// Referencing the bare family name resolves to nothing and silently falls
/// back to the platform font — San Francisco on iOS, Roboto on Android — which
/// looks close enough to Inter on iOS to pass unnoticed.
const String interFontFamily = 'packages/flutter_flowin/Inter';

/// {@template flowin_baseline_text_tokens}
/// The baseline Flowin text styles, built on the Inter typeface.
///
/// These map onto Material's [TextTheme] roles via [FlowinTypefaces.baseline].
/// {@endtemplate}
class FlowinBaselineTextTokens {
  /// {@macro flowin_baseline_text_tokens}
  const FlowinBaselineTextTokens();

  /// Headline / small.
  static TextStyle get headlineSmall => const TextStyle(
    fontFamily: interFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.05,
  );

  /// Title / large.
  static TextStyle get titleLarge => const TextStyle(
    fontFamily: interFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 24 / 20,
    letterSpacing: 0,
  );

  /// Title / medium.
  static TextStyle get titleMedium => const TextStyle(
    fontFamily: interFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22 / 16,
    letterSpacing: 0,
  );

  /// Title / small.
  static TextStyle get titleSmall => const TextStyle(
    fontFamily: interFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0,
  );

  /// Body / large.
  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: interFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
  );

  /// Body / medium.
  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: interFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22 / 14,
    letterSpacing: 0,
  );

  /// Label / large.
  static TextStyle get labelLarge => const TextStyle(
    fontFamily: interFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 16 / 16,
    letterSpacing: 0,
  );

  /// Label / medium.
  static TextStyle get labelMedium => const TextStyle(
    fontFamily: interFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 14 / 14,
    letterSpacing: 0,
  );

  /// Label / small.
  static TextStyle get labelSmall => const TextStyle(
    fontFamily: interFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 12 / 12,
    letterSpacing: 0,
  );

  /// Caption / large.
  static TextStyle get captionLarge => const TextStyle(
    fontFamily: interFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 20 / 12,
    letterSpacing: 0,
  );

  /// Caption / medium.
  static TextStyle get captionMedium => const TextStyle(
    fontFamily: interFontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 16 / 10,
    letterSpacing: 0.2,
  );
}

/// Caption styles that have no Material [TextTheme] slot, exposed as
/// extension getters so call sites read `textTheme.captionLarge`.
extension FlowinBaselineTextTheme on TextTheme {
  /// Caption / large.
  TextStyle get captionLarge => FlowinBaselineTextTokens.captionLarge;

  /// Caption / medium.
  TextStyle get captionMedium => FlowinBaselineTextTokens.captionMedium;
}

/// {@template flowin_typefaces}
/// Builds the Flowin [TextTheme] by overlaying [FlowinBaselineTextTokens] onto
/// the Material 2021 baseline with Inter applied, so that native widgets
/// reading from `Theme.of(context).textTheme` pick up Flowin typography
/// automatically.
///
/// Mirrors the production `flowin_design` package (fidelity oracle 0.3.0):
/// same base ([Typography.material2021] `.black` with [interFontFamily]
/// applied).
///
/// One deliberate deviation: production leaves `titleLarge` at the Material
/// default rather than overriding it, which left the slot carrying no Flowin
/// value at all — a widget reading it inherited from ambient text. The spec
/// binds it like every other named style, so it is installed here.
/// {@endtemplate}
class FlowinTypefaces {
  /// {@macro flowin_typefaces}
  const FlowinTypefaces();

  /// The baseline [TextTheme] used by both light and dark themes.
  static TextTheme baseline() {
    return Typography.material2021(platform: defaultTargetPlatform).black
        .apply(fontFamily: interFontFamily)
        .copyWith(
          headlineSmall: FlowinBaselineTextTokens.headlineSmall,
          titleLarge: FlowinBaselineTextTokens.titleLarge,
          titleMedium: FlowinBaselineTextTokens.titleMedium,
          titleSmall: FlowinBaselineTextTokens.titleSmall,
          bodyLarge: FlowinBaselineTextTokens.bodyLarge,
          bodyMedium: FlowinBaselineTextTokens.bodyMedium,
          labelLarge: FlowinBaselineTextTokens.labelLarge,
          labelMedium: FlowinBaselineTextTokens.labelMedium,
          labelSmall: FlowinBaselineTextTokens.labelSmall,
        );
  }
}
