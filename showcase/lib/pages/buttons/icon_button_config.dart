import 'package:flutter_flowin/flutter_flowin.dart';

/// The state of the [FlowinIconButton] preview.
@immutable
class IconButtonConfig {
  /// {@macro icon_button_config}
  const IconButtonConfig({
    this.variant = FlowinIconButtonVariant.filled,
    this.size = FlowinButtonSize.sm,
    this.enabled = true,
  });

  /// Which emphasis the button carries.
  final FlowinIconButtonVariant variant;

  /// The control size.
  final FlowinButtonSize size;

  /// Whether the button responds to a press.
  final bool enabled;

  /// A copy with the given fields replaced.
  IconButtonConfig copyWith({
    FlowinIconButtonVariant? variant,
    FlowinButtonSize? size,
    bool? enabled,
  }) => IconButtonConfig(
    variant: variant ?? this.variant,
    size: size ?? this.size,
    enabled: enabled ?? this.enabled,
  );

  @override
  bool operator ==(Object other) =>
      other is IconButtonConfig &&
      other.variant == variant &&
      other.size == size &&
      other.enabled == enabled;

  @override
  int get hashCode => Object.hash(variant, size, enabled);
}
