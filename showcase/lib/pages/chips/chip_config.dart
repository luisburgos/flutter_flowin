import 'package:flutter_flowin/flutter_flowin.dart';

/// The state of the [FlowinChip] preview.
///
/// Value equality is what lets the playground tell a preset from a custom
/// configuration, so it is a requirement of the type rather than a
/// convenience.
@immutable
class ChipConfig {
  /// {@macro chip_config}
  const ChipConfig({
    this.variant = FlowinChipVariant.unselected,
    this.hasLeading = false,
    this.enabled = true,
  });

  /// Which emphasis the chip carries.
  final FlowinChipVariant variant;

  /// Whether a glyph sits before the label.
  final bool hasLeading;

  /// Whether the chip responds to a tap.
  ///
  /// A null `onSelected` is what makes a chip non-interactive, so the knob
  /// toggles whether a callback is passed at all.
  final bool enabled;

  /// A copy with the given fields replaced.
  ChipConfig copyWith({
    FlowinChipVariant? variant,
    bool? hasLeading,
    bool? enabled,
  }) => ChipConfig(
    variant: variant ?? this.variant,
    hasLeading: hasLeading ?? this.hasLeading,
    enabled: enabled ?? this.enabled,
  );

  @override
  bool operator ==(Object other) =>
      other is ChipConfig &&
      other.variant == variant &&
      other.hasLeading == hasLeading &&
      other.enabled == enabled;

  @override
  int get hashCode => Object.hash(variant, hasLeading, enabled);
}
