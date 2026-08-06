import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/colors.dart';

/// {@template flowin_design_schemes}
/// Maps the raw [FlowinDesignColors] palette onto Material's [ColorScheme]
/// roles for the light and dark themes.
///
/// This is the bridge that lets native Flutter widgets be styled by the Flowin
/// palette: assign these schemes to `ThemeData.colorScheme` and every Material
/// component inherits the right colors.
/// {@endtemplate}
class FlowinDesignSchemes {
  /// {@macro flowin_design_schemes}
  const FlowinDesignSchemes();

  /// The light [ColorScheme].
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: FlowinDesignColors.primary800,
    onPrimary: FlowinDesignColors.white,
    secondary: FlowinDesignColors.secondary200,
    onSecondary: FlowinDesignColors.secondary800,
    tertiary: FlowinDesignColors.tertiary100,
    onTertiary: FlowinDesignColors.tertiary800,
    surface: FlowinDesignColors.white,
    onSurface: FlowinDesignColors.neutral800,
    onSurfaceVariant: FlowinDesignColors.neutral400,
    inverseSurface: FlowinDesignColors.neutral700,
    onInverseSurface: FlowinDesignColors.white,
    shadow: FlowinDesignColors.neutral200,
    primaryContainer: FlowinDesignColors.primary800,
    onPrimaryContainer: FlowinDesignColors.white,
    secondaryContainer: FlowinDesignColors.secondary200,
    onSecondaryContainer: FlowinDesignColors.secondary800,
    outline: FlowinDesignColors.neutral800,
    outlineVariant: FlowinDesignColors.neutral200,
    error: FlowinDesignColors.error500,
    onError: FlowinDesignColors.white,
    errorContainer: FlowinDesignColors.error100,
    onErrorContainer: FlowinDesignColors.error500,
  );

  /// The dark [ColorScheme].
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: FlowinDesignColors.primary200,
    onPrimary: FlowinDesignColors.primary800,
    secondary: FlowinDesignColors.secondary700,
    onSecondary: FlowinDesignColors.secondary200,
    tertiary: FlowinDesignColors.tertiary500,
    onTertiary: FlowinDesignColors.tertiary800,
    surface: FlowinDesignColors.neutral800,
    onSurface: FlowinDesignColors.neutral200,
    onSurfaceVariant: FlowinDesignColors.neutral400,
    surfaceBright: FlowinDesignColors.neutral700,
    inverseSurface: FlowinDesignColors.white,
    onInverseSurface: FlowinDesignColors.neutral800,
    shadow: FlowinDesignColors.neutral700,
    primaryContainer: FlowinDesignColors.primary200,
    onPrimaryContainer: FlowinDesignColors.primary800,
    secondaryContainer: FlowinDesignColors.secondary700,
    onSecondaryContainer: FlowinDesignColors.secondary200,
    outline: FlowinDesignColors.neutral200,
    outlineVariant: FlowinDesignColors.neutral700,
    error: FlowinDesignColors.error500,
    onError: FlowinDesignColors.white,
    errorContainer: FlowinDesignColors.error800,
    onErrorContainer: FlowinDesignColors.error500,
  );
}

/// Brightness-independent ("fixed") color accessors that are not part of the
/// Material [ColorScheme] roles but are needed by some Flowin components.
extension FlowinColorSchemeExt on ColorScheme {
  /// A fixed neutral-200 that does not flip with brightness.
  Color get fixedNeutral200 => FlowinDesignColors.neutral200;

  /// A fixed neutral-600 that does not flip with brightness.
  Color get fixedNeutral600 => FlowinDesignColors.neutral600;

  /// A fixed success color that does not flip with brightness.
  Color get fixedSuccess => FlowinDesignColors.success500;
}
