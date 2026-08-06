/// {@template flowin_design_radius}
/// The Flowin corner-radius scale.
///
/// Includes [iOSSmooth] (the smoothing factor used with `figma_squircle` for
/// iOS-style continuous corners) and [full] for fully rounded / pill shapes.
/// {@endtemplate}
class FlowinDesignRadius {
  /// {@macro flowin_design_radius}
  const FlowinDesignRadius();

  /// 4px.
  static const double radius100 = 4;

  /// 8px.
  static const double radius200 = 8;

  /// 12px.
  static const double radius300 = 12;

  /// 16px.
  static const double radius400 = 16;

  /// 24px.
  static const double radius500 = 24;

  /// 26px.
  static const double radius600 = 26;

  /// 28px.
  static const double radius700 = 28;

  /// 32px.
  static const double radius800 = 32;

  /// 40px.
  static const double radius1000 = 40;

  /// The corner-smoothing factor for iOS-style continuous corners
  /// (used with `figma_squircle`).
  static const double iOSSmooth = 0.6;

  /// A very large radius used to produce fully rounded / pill shapes.
  static const double full = 9999;
}
