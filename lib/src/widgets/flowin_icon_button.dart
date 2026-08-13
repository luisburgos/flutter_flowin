import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/widgets/flowin_button.dart'
    show FlowinButtonSize;

/// The visual variant of a [FlowinIconButton].
enum FlowinIconButtonVariant {
  /// A solid, high-emphasis icon button.
  filled,

  /// A tonal, medium-emphasis icon button.
  tonal,

  /// A low-emphasis, transparent icon button.
  text,

  /// A destructive icon button.
  destructive,
}

/// {@template flowin_icon_button}
/// A circular Flowin icon button.
///
/// A *thin* composition over the framework's [IconButton]. The circular
/// [CircleBorder] shape comes from the theme's `iconButtonTheme` — not
/// hardcoded here. Only the per-call concerns the theme cannot know are
/// resolved by this widget: which [FlowinIconButtonVariant] (mapped to the
/// matching [ColorScheme] color roles) and which [FlowinButtonSize] (mapped to
/// a square minimum size and icon size).
/// {@endtemplate}
class FlowinIconButton extends StatelessWidget {
  /// {@macro flowin_icon_button}
  const FlowinIconButton({
    required this.onPressed,
    required this.icon,
    this.variant = FlowinIconButtonVariant.filled,
    this.size = FlowinButtonSize.defaultSize,
    super.key,
  });

  /// A tonal icon button.
  const FlowinIconButton.tonal({
    required this.onPressed,
    required this.icon,
    this.size = FlowinButtonSize.defaultSize,
    super.key,
  }) : variant = FlowinIconButtonVariant.tonal;

  /// A low-emphasis text icon button.
  const FlowinIconButton.text({
    required this.onPressed,
    required this.icon,
    this.size = FlowinButtonSize.defaultSize,
    super.key,
  }) : variant = FlowinIconButtonVariant.text;

  /// A destructive icon button.
  const FlowinIconButton.destructive({
    required this.onPressed,
    required this.icon,
    this.size = FlowinButtonSize.defaultSize,
    super.key,
  }) : variant = FlowinIconButtonVariant.destructive;

  /// Called when the button is tapped. A null callback disables the button.
  final VoidCallback? onPressed;

  /// The icon to render.
  final Widget icon;

  /// The visual variant.
  final FlowinIconButtonVariant variant;

  /// The size.
  final FlowinButtonSize size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final side = size.minHeight;

    final (Color background, Color foreground) = switch (variant) {
      FlowinIconButtonVariant.filled => (
        colorScheme.primary,
        colorScheme.onPrimary,
      ),
      FlowinIconButtonVariant.tonal => (
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
      ),
      FlowinIconButtonVariant.text => (
        Colors.transparent,
        colorScheme.primary,
      ),
      FlowinIconButtonVariant.destructive => (
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
      ),
    };

    final button = IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: size.iconSize.value,
      // Shape (CircleBorder) comes from the theme's iconButtonTheme. Only the
      // variant colors and per-size square dimensions are set here.
      style: IconButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        minimumSize: Size.square(side),
        fixedSize: Size.square(side),
        padding: EdgeInsets.zero,
      ),
    );

    // Per-size outer padding, all sides (md = none) — see iconOuterPadding for
    // why this differs from FlowinButton's vertical-only wrapper.
    final outer = size.iconOuterPadding;
    if (outer == EdgeInsets.zero) return button;
    return Padding(padding: outer, child: button);
  }
}
