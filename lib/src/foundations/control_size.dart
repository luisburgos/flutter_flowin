/// {@template flowin_design_control_size}
/// The Flowin control-height scale.
///
/// The fixed heights interactive controls are built to — a button's minimum
/// height, an icon button's square side. Distinct from the spacing scale:
/// a control height is a sizing decision, not a spacing value, even where the
/// two happen to share a number (the spacing scale is a separate family).
///
/// Every other token family has a foundation class; this one did not, so each
/// control height was a bare literal at its call site and nothing marked a
/// given `56` as "the md control height" rather than an incidental one.
///
/// Not every consumer resolves through it. `FlowinItemButton` needs its height
/// in a `const` expression, and Dart cannot const-evaluate an enum getter, so
/// it still spells the number out — with a fidelity test pinning the literal
/// to this scale. That test catches drift; it does not prevent it. Changing a
/// step here is therefore not a one-file edit, and the pin is what tells you
/// where else to look.
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
