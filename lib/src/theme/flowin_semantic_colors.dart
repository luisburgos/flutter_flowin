import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// {@template flowin_semantic_colors}
/// Semantic status colors that have no direct Material [ColorScheme] role —
/// success, warning, and info — together with their on-colors.
///
/// Defaults are drawn from the Flowin palette; the light and dark themes supply
/// brightness-appropriate variants.
/// {@endtemplate}
class FlowinSemanticColors {
  /// {@macro flowin_semantic_colors}
  const FlowinSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
  });

  /// Semantic colors tuned for light surfaces.
  const FlowinSemanticColors.light()
    : success = FlowinDesignColors.success500,
      onSuccess = FlowinDesignColors.white,
      warning = FlowinDesignColors.warning500,
      onWarning = FlowinDesignColors.neutral800,
      info = FlowinDesignColors.neutral700,
      onInfo = FlowinDesignColors.white;

  /// Semantic colors tuned for dark surfaces.
  const FlowinSemanticColors.dark()
    : success = FlowinDesignColors.success400,
      onSuccess = FlowinDesignColors.neutral800,
      warning = FlowinDesignColors.warning400,
      onWarning = FlowinDesignColors.neutral800,
      info = FlowinDesignColors.neutral200,
      onInfo = FlowinDesignColors.neutral800;

  /// Color for success states.
  final Color success;

  /// Content color on top of [success].
  final Color onSuccess;

  /// Color for warning states.
  final Color warning;

  /// Content color on top of [warning].
  final Color onWarning;

  /// Color for informational states.
  final Color info;

  /// Content color on top of [info].
  final Color onInfo;

  /// Returns a copy with the given fields replaced.
  FlowinSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
  }) {
    return FlowinSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
    );
  }

  /// Linearly interpolates between two [FlowinSemanticColors] values.
  // ignore: prefer_constructors_over_static_methods
  static FlowinSemanticColors lerp(
    FlowinSemanticColors a,
    FlowinSemanticColors b,
    double t,
  ) {
    return FlowinSemanticColors(
      success: Color.lerp(a.success, b.success, t)!,
      onSuccess: Color.lerp(a.onSuccess, b.onSuccess, t)!,
      warning: Color.lerp(a.warning, b.warning, t)!,
      onWarning: Color.lerp(a.onWarning, b.onWarning, t)!,
      info: Color.lerp(a.info, b.info, t)!,
      onInfo: Color.lerp(a.onInfo, b.onInfo, t)!,
    );
  }
}
