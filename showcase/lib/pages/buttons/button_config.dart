import 'package:flutter_flowin/flutter_flowin.dart';

/// The state of the [FlowinButton] preview.
///
/// Value equality is what lets the playground tell a preset from a custom
/// configuration, so it is a requirement of the type rather than a
/// convenience.
@immutable
class ButtonConfig {
  /// {@macro button_config}
  const ButtonConfig({
    this.variant = FlowinButtonVariant.filled,
    this.size = FlowinButtonSize.sm,
    this.hasIcon = false,
    this.enabled = true,
  });

  /// Which emphasis the button carries.
  final FlowinButtonVariant variant;

  /// The control size.
  final FlowinButtonSize size;

  /// Whether a leading icon sits before the label.
  final bool hasIcon;

  /// Whether the button responds to a press.
  ///
  /// Disabled is a null `onPressed` rather than a flag on the widget, so the
  /// knob toggles whether a callback is passed at all.
  final bool enabled;

  /// A copy with the given fields replaced.
  ButtonConfig copyWith({
    FlowinButtonVariant? variant,
    FlowinButtonSize? size,
    bool? hasIcon,
    bool? enabled,
  }) => ButtonConfig(
    variant: variant ?? this.variant,
    size: size ?? this.size,
    hasIcon: hasIcon ?? this.hasIcon,
    enabled: enabled ?? this.enabled,
  );

  @override
  bool operator ==(Object other) =>
      other is ButtonConfig &&
      other.variant == variant &&
      other.size == size &&
      other.hasIcon == hasIcon &&
      other.enabled == enabled;

  @override
  int get hashCode => Object.hash(variant, size, hasIcon, enabled);
}
