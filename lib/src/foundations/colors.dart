import 'package:flutter/material.dart';

/// {@template flowin_design_colors}
/// The raw Flowin color palette.
///
/// These are the primitive color tokens of the design system. They are not
/// meant to be consumed directly by application code — instead they are mapped
/// onto Material's [ColorScheme] roles (see `FlowinDesignSchemes`) so that
/// native Flutter widgets are styled by the theme.
/// {@endtemplate}
class FlowinDesignColors {
  /// {@macro flowin_design_colors}
  const FlowinDesignColors();

  /// Pure white.
  static const Color white = Colors.white;

  /// Pure black.
  static const Color black = Colors.black;

  /// Neutral 800.
  static const Color neutral800 = Color(0xFF181818);

  /// Neutral 700.
  static const Color neutral700 = Color(0xFF313131);

  /// Neutral 600.
  static const Color neutral600 = Color(0xFF494949);

  /// Neutral 500.
  static const Color neutral500 = Color(0xFF7A7A7A);

  /// Neutral 400.
  static const Color neutral400 = Color(0xFFABABAB);

  /// Neutral 300.
  static const Color neutral300 = Color(0xFFDBDBDB);

  /// Neutral 200.
  static const Color neutral200 = Color(0xFFF3F3F3);

  /// Neutral 100.
  static const Color neutral100 = Color(0xFFF9F9F9);

  /// Error 800.
  static const Color error800 = Color(0xFF55161F);

  /// Error 700.
  static const Color error700 = Color(0xFF821D1B);

  /// Error 600.
  static const Color error600 = Color(0xFFAC1F1D);

  /// Error 500.
  static const Color error500 = Color(0xFFEC221F);

  /// Error 400.
  static const Color error400 = Color(0xFFF15957);

  /// Error 300.
  static const Color error300 = Color(0xFFF5918F);

  /// Error 200.
  static const Color error200 = Color(0xFFFDE9E9);

  /// Error 100.
  static const Color error100 = Color(0xFFFEF7F7);

  /// Warning 800.
  static const Color warning800 = Color(0xFFBD6F10);

  /// Warning 700.
  static const Color warning700 = Color(0xFFEDA043);

  /// Warning 600.
  static const Color warning600 = Color(0xFFEDB143);

  /// Warning 500.
  static const Color warning500 = Color(0xFFEABF24);

  /// Warning 400.
  static const Color warning400 = Color(0xFFF1D672);

  /// Warning 300.
  static const Color warning300 = Color(0xFFF6E3A1);

  /// Warning 200.
  static const Color warning200 = Color(0xFFFBF1D0);

  /// Warning 100.
  static const Color warning100 = Color(0xFFFDF8E7);

  /// Success 800.
  static const Color success800 = Color(0xFF213B15);

  /// Success 700.
  static const Color success700 = Color(0xFF2B5D12);

  /// Success 600.
  static const Color success600 = Color(0xFF34800E);

  /// Success 500.
  static const Color success500 = Color(0xFF3DA20B);

  /// Success 400.
  static const Color success400 = Color(0xFF6EB948);

  /// Success 300.
  static const Color success300 = Color(0xFF9ED185);

  /// Success 200.
  static const Color success200 = Color(0xFFCEE8C2);

  /// Success 100.
  static const Color success100 = Color(0xFFE7F3E1);

  // --- Accent ramps -------------------------------------------------------
  //
  // Kept as their own ramps rather than aliased to `neutral`, because they are
  // a customization surface: an application re-pointing an accent gets a full
  // ramp to work from, and the roles stay independently re-pointable (see
  // DESIGN.md section 2). Their values track `neutral` only because neutral is
  // the accent default — nothing requires that, and a real accent palette would
  // replace them.
  //
  // The 400 step read `#b6b6b6` while `neutral400` read `#ababab`. The spec
  // recorded that as an artifact of aliasing the roles onto neutral, to be
  // resolved rather than kept, so it is aligned here. No scheme reads a 400
  // step, so nothing rendered changes.

  /// Primary 800.
  static const Color primary800 = Color(0xFF181818);

  /// Primary 700.
  static const Color primary700 = Color(0xFF313131);

  /// Primary 600.
  static const Color primary600 = Color(0xFF494949);

  /// Primary 500.
  static const Color primary500 = Color(0xFF7A7A7A);

  /// Primary 400.
  static const Color primary400 = Color(0xFFABABAB);

  /// Primary 300.
  static const Color primary300 = Color(0xFFDBDBDB);

  /// Primary 200.
  static const Color primary200 = Color(0xFFF3F3F3);

  /// Primary 100.
  static const Color primary100 = Color(0xFFF9F9F9);

  /// Secondary 800.
  static const Color secondary800 = Color(0xFF181818);

  /// Secondary 700.
  static const Color secondary700 = Color(0xFF313131);

  /// Secondary 600.
  static const Color secondary600 = Color(0xFF494949);

  /// Secondary 500.
  static const Color secondary500 = Color(0xFF7A7A7A);

  /// Secondary 400.
  static const Color secondary400 = Color(0xFFABABAB);

  /// Secondary 300.
  static const Color secondary300 = Color(0xFFDBDBDB);

  /// Secondary 200.
  static const Color secondary200 = Color(0xFFF3F3F3);

  /// Secondary 100.
  static const Color secondary100 = Color(0xFFF9F9F9);

  /// Tertiary 800.
  static const Color tertiary800 = Color(0xFF181818);

  /// Tertiary 700.
  static const Color tertiary700 = Color(0xFF313131);

  /// Tertiary 600.
  static const Color tertiary600 = Color(0xFF494949);

  /// Tertiary 500.
  static const Color tertiary500 = Color(0xFF7A7A7A);

  /// Tertiary 400.
  static const Color tertiary400 = Color(0xFFABABAB);

  /// Tertiary 300.
  static const Color tertiary300 = Color(0xFFDBDBDB);

  /// Tertiary 200.
  static const Color tertiary200 = Color(0xFFF3F3F3);

  /// Tertiary 100.
  static const Color tertiary100 = Color(0xFFF9F9F9);
}
