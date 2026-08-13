import 'dart:ui';

import 'package:flutter_flowin/src/foundations/foundations.dart';

/// {@template flowin_spacing}
/// The spacing scale as a theme value, exposing the [FlowinDesignSpace] tokens
/// as instance fields so layouts can read `context.flowinTokens.spacing.md`.
///
/// Defaults are the Flowin design tokens; override individual steps to produce
/// a denser or looser variant of the system.
/// {@endtemplate}
class FlowinSpacing {
  /// {@macro flowin_spacing}
  const FlowinSpacing({
    this.none = FlowinDesignSpace.zero,
    this.xxs = FlowinDesignSpace.space100,
    this.xs = FlowinDesignSpace.space200,
    this.sm = FlowinDesignSpace.space300,
    this.md = FlowinDesignSpace.space400,
    this.lg = FlowinDesignSpace.space600,
    this.xl = FlowinDesignSpace.space800,
    this.xxl = FlowinDesignSpace.space1200,
  });

  /// 0px.
  final double none;

  /// 4px.
  final double xxs;

  /// 8px.
  final double xs;

  /// 12px.
  final double sm;

  /// 16px.
  final double md;

  /// 24px.
  final double lg;

  /// 32px.
  final double xl;

  /// 48px.
  final double xxl;

  /// Returns a copy with the given fields replaced.
  FlowinSpacing copyWith({
    double? none,
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return FlowinSpacing(
      none: none ?? this.none,
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  /// Linearly interpolates between two [FlowinSpacing] values.
  // ignore: prefer_constructors_over_static_methods
  static FlowinSpacing lerp(FlowinSpacing a, FlowinSpacing b, double t) {
    return FlowinSpacing(
      none: lerpDouble(a.none, b.none, t)!,
      xxs: lerpDouble(a.xxs, b.xxs, t)!,
      xs: lerpDouble(a.xs, b.xs, t)!,
      sm: lerpDouble(a.sm, b.sm, t)!,
      md: lerpDouble(a.md, b.md, t)!,
      lg: lerpDouble(a.lg, b.lg, t)!,
      xl: lerpDouble(a.xl, b.xl, t)!,
      xxl: lerpDouble(a.xxl, b.xxl, t)!,
    );
  }
}
