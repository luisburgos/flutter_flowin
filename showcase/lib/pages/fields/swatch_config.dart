import 'package:flutter_flowin/flutter_flowin.dart';

/// The diameters a swatch can be previewed at.
///
/// A scale rather than the boolean this used to be: the ring and the gap are
/// fixed token widths that do *not* scale with the swatch, so the selection
/// ring reads differently at every diameter — thick and dominant on a small
/// swatch, a hairline on a large one. Two hardcoded sizes showed two points on
/// that curve and hid the rest.
enum SwatchSize {
  /// The size a swatch takes in a dense row.
  small(FlowinDesignSpace.space600),

  /// The component's own default.
  regular(FlowinDesignSpace.space700),

  /// A comfortable tap target.
  large(FlowinDesignSpace.space1000),

  /// Large enough that the ring reads as a hairline.
  huge(FlowinDesignSpace.space1200);

  const SwatchSize(this.value);

  /// The diameter in logical pixels.
  final double value;
}

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
    this.size = SwatchSize.regular,
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

  /// The diameter the swatches render at.
  ///
  /// Only meaningful for [SwatchSubject.swatches]; the picker field exposes no
  /// swatch size.
  final SwatchSize size;

  /// A copy with the given fields replaced.
  SwatchConfig copyWith({
    SwatchSubject? subject,
    bool? selected,
    bool? showGradient,
    SwatchSize? size,
  }) => SwatchConfig(
    subject: subject ?? this.subject,
    selected: selected ?? this.selected,
    showGradient: showGradient ?? this.showGradient,
    size: size ?? this.size,
  );

  @override
  bool operator ==(Object other) =>
      other is SwatchConfig &&
      other.subject == subject &&
      other.selected == selected &&
      other.showGradient == showGradient &&
      other.size == size;

  @override
  int get hashCode => Object.hash(subject, selected, showGradient, size);
}
