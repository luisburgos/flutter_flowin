import 'package:flutter_flowin/flutter_flowin.dart';

/// Which form the swatch is shown in.
enum SwatchSubject {
  /// The bare [FlowinColorRadialButton] primitive, in a row.
  swatches,

  /// The composed [FlowinColorPickerField]: swatches inside a labelled field.
  pickerField,
}

/// The state of the colour-swatch preview.
///
/// Value equality is what lets the playground tell a preset from a custom
/// configuration, so it is a requirement of the type rather than a
/// convenience.
@immutable
class SwatchConfig {
  /// {@macro swatch_config}
  const SwatchConfig({
    this.subject = SwatchSubject.swatches,
    this.selected = true,
    this.showGradient = true,
    this.large = false,
  });

  /// Whether the primitive or the composed field is previewed.
  final SwatchSubject subject;

  /// Whether one swatch carries the selection ring.
  ///
  /// Only meaningful for [SwatchSubject.swatches]; the picker field owns its
  /// own selection.
  final bool selected;

  /// Whether the custom-colour gradient swatch is shown beside the solids.
  ///
  /// Only meaningful for [SwatchSubject.swatches]; the picker field always
  /// pins one to its trailing edge.
  final bool showGradient;

  /// Whether the swatches render at a larger diameter.
  ///
  /// The ring and gap are token widths that do not scale with the swatch, so
  /// the selection ring reads differently at each size.
  ///
  /// Only meaningful for [SwatchSubject.swatches]; the picker field exposes no
  /// swatch size.
  final bool large;

  /// A copy with the given fields replaced.
  SwatchConfig copyWith({
    SwatchSubject? subject,
    bool? selected,
    bool? showGradient,
    bool? large,
  }) => SwatchConfig(
    subject: subject ?? this.subject,
    selected: selected ?? this.selected,
    showGradient: showGradient ?? this.showGradient,
    large: large ?? this.large,
  );

  @override
  bool operator ==(Object other) =>
      other is SwatchConfig &&
      other.subject == subject &&
      other.selected == selected &&
      other.showGradient == showGradient &&
      other.large == large;

  @override
  int get hashCode => Object.hash(subject, selected, showGradient, large);
}
