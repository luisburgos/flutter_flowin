/// {@template flowin_design_space}
/// The Flowin spacing scale.
///
/// A geometric-ish scale of layout distances (padding, margins, gaps) named by
/// design-token weight rather than raw pixels. Exposed at runtime through the
/// `FlowinTokens` theme extension.
/// {@endtemplate}
class FlowinDesignSpace {
  /// {@macro flowin_design_space}
  const FlowinDesignSpace();

  /// 0px.
  static const double zero = 0;

  /// 2px.
  static const double space50 = 2;

  /// 4px.
  static const double space100 = 4;

  /// 6px.
  static const double space150 = 6;

  /// 8px.
  static const double space200 = 8;

  /// 10px.
  static const double space250 = 10;

  /// 12px.
  static const double space300 = 12;

  /// 16px.
  static const double space400 = 16;

  /// 24px.
  static const double space600 = 24;

  /// 28px.
  static const double space700 = 28;

  /// 32px.
  static const double space800 = 32;

  /// 40px.
  static const double space1000 = 40;

  /// 48px.
  static const double space1200 = 48;

  /// 56px.
  static const double space1400 = 56;

  /// 64px.
  static const double space1600 = 64;

  /// 96px.
  static const double space2400 = 96;

  /// 160px.
  static const double space4000 = 160;
}
