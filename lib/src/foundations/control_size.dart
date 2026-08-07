/// {@template flowin_design_control_size}
/// The Flowin control-height scale.
///
/// The fixed heights interactive controls are built to — a button's minimum
/// height, an icon button's square side. Distinct from the spacing scale: a
/// control height is a sizing decision, not a spacing value, even where the
/// two happen to share a number.
///
/// `FlowinItemButton` needs its height in a `const` expression, which cannot
/// evaluate an enum getter, so it spells its value out and the fidelity suite
/// pins the literal to this scale. Changing a step here is therefore not a
/// single-file edit.
/// {@endtemplate}
enum FlowinDesignControlSize {
  /// Extra-small — 32px.
  xs(32),

  /// Small — 40px.
  sm(40),

  /// Medium — 56px.
  md(56);

  /// {@macro flowin_design_control_size}
  const FlowinDesignControlSize(this.value);

  /// The control height in logical pixels.
  final double value;
}
