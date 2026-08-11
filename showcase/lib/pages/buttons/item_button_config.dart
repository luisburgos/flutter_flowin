import 'package:flutter_flowin/flutter_flowin.dart';

/// The state of the [FlowinItemButton] preview.
@immutable
class ItemButtonConfig {
  /// {@macro item_button_config}
  const ItemButtonConfig({
    this.variant = FlowinItemButtonVariant.tonal,
    this.hasIcon = true,
    this.enabled = true,
  });

  /// Which emphasis the row carries.
  final FlowinItemButtonVariant variant;

  /// Whether a leading icon sits before the label.
  final bool hasIcon;

  /// Whether the row responds to a press.
  final bool enabled;

  /// A copy with the given fields replaced.
  ItemButtonConfig copyWith({
    FlowinItemButtonVariant? variant,
    bool? hasIcon,
    bool? enabled,
  }) => ItemButtonConfig(
    variant: variant ?? this.variant,
    hasIcon: hasIcon ?? this.hasIcon,
    enabled: enabled ?? this.enabled,
  );

  @override
  bool operator ==(Object other) =>
      other is ItemButtonConfig &&
      other.variant == variant &&
      other.hasIcon == hasIcon &&
      other.enabled == enabled;

  @override
  int get hashCode => Object.hash(variant, hasIcon, enabled);
}
