import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/colors.dart';

/// {@template flowin_design_shadows}
/// The Flowin elevation shadow tokens.
/// {@endtemplate}
class FlowinDesignShadows {
  /// {@macro flowin_design_shadows}
  const FlowinDesignShadows();

  /// A hairline shadow ring for separating a surface from its background
  /// without making it look elevated. Use instead of [shadow100] when the
  /// intent is separation rather than elevation.
  static const BoxShadow shadow10 = BoxShadow(
    color: FlowinDesignColors.neutral200,
    spreadRadius: 1,
  );

  /// [shadow10] resolved against the ambient color scheme, so the delimiter
  /// stays visible in dark themes where [FlowinDesignColors.neutral200] would
  /// disappear against the surface.
  static BoxShadow themedShadow10(BuildContext context) => BoxShadow(
    color: Theme.of(context).colorScheme.outlineVariant,
    spreadRadius: 1,
  );

  /// The base ambient shadow used for raised surfaces, in **light** themes.
  ///
  /// Dark themes take [shadow100Dark] instead — see it for why the colour
  /// cannot be shared.
  static const BoxShadow shadow100 = BoxShadow(
    color: FlowinDesignColors.neutral200,
    offset: Offset(0, 8),
    blurRadius: 32,
    spreadRadius: 5,
  );

  /// [shadow100] for **dark** themes: the same geometry in black.
  ///
  /// A shadow is an absence of light, so it darkens whatever it falls on.
  /// Sharing the light colour inverts that — [FlowinDesignColors.neutral200]
  /// is near-white, so a raised surface in dark mode rendered a bright halo
  /// rather than a shadow.
  ///
  /// Black rather than a dark neutral step: `neutral700` on the `neutral800`
  /// surface is one ramp step of separation and reads as nothing at all.
  static const BoxShadow shadow100Dark = BoxShadow(
    // Stated rather than left to BoxShadow's default, which happens to be
    // black too: the colour is the whole point of this token, so it should
    // be legible here and fail loudly if the default ever changes.
    // ignore: avoid_redundant_argument_values
    color: FlowinDesignColors.black,
    offset: Offset(0, 8),
    blurRadius: 32,
    spreadRadius: 5,
  );
}
