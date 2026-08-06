import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// The visual variant of a [FlowinButton].
enum FlowinButtonVariant {
  /// A solid, high-emphasis button (primary action).
  filled,

  /// A tonal, medium-emphasis button (secondary action).
  tonal,

  /// A low-emphasis, label-only button.
  text,

  /// An outlined, medium-emphasis button.
  outline,

  /// A destructive action button.
  destructive,
}

/// The size of a [FlowinButton].
enum FlowinButtonSize {
  /// Extra-small.
  xs,

  /// Small (default).
  sm,

  /// Medium.
  md;

  /// The default button size.
  static const FlowinButtonSize defaultSize = FlowinButtonSize.sm;

  /// The minimum height for this size.
  double get minHeight => switch (this) {
    xs => 32,
    sm => 40,
    md => 56,
  };

  /// The content padding for this size (inside the button).
  EdgeInsets get padding => switch (this) {
    xs => const EdgeInsets.symmetric(
      horizontal: FlowinDesignSpace.space300,
      vertical: FlowinDesignSpace.space200,
    ),
    sm => const EdgeInsets.symmetric(
      horizontal: FlowinDesignSpace.space400,
      vertical: FlowinDesignSpace.space250,
    ),
    md => const EdgeInsets.symmetric(
      horizontal: FlowinDesignSpace.space600,
      vertical: FlowinDesignSpace.space400,
    ),
  };

  /// The outer padding step for this size: 8 / 4 / 0.
  ///
  /// Consumed with different geometry by [outerPadding] (vertical-only) and
  /// [iconOuterPadding] (all sides) — see those members.
  double get _outerPaddingStep => switch (this) {
    xs => FlowinDesignSpace.space200,
    sm => FlowinDesignSpace.space100,
    md => FlowinDesignSpace.zero,
  };

  /// The outer padding for this size (around the button), so adjacent same-size
  /// buttons share consistent spacing without the call site adding it.
  ///
  /// Vertical-only, matching production (fd_button.dart wraps the button in
  /// `EdgeInsets.symmetric(vertical: size.padding)`). Contrast
  /// [iconOuterPadding].
  EdgeInsets get outerPadding =>
      EdgeInsets.symmetric(vertical: _outerPaddingStep);

  /// The outer padding for a `FlowinIconButton` of this size.
  ///
  /// **All sides**, not vertical-only: production's icon button wraps in
  /// `EdgeInsets.all(size.padding)` (fd_icon_button.dart:74) while its regular
  /// button uses `EdgeInsets.symmetric(vertical: …)`. Same step, different
  /// geometry — the two are deliberately different, so they get separate
  /// members rather than one shared value.
  EdgeInsets get iconOuterPadding => EdgeInsets.all(_outerPaddingStep);

  /// The paired icon size for this button size.
  FlowinDesignIconSize get iconSize => switch (this) {
    xs => FlowinDesignIconSize.sm,
    sm => FlowinDesignIconSize.md,
    md => FlowinDesignIconSize.lg,
  };

  /// The per-size label text style, resolved from the [TextTheme].
  ///
  /// `md` equals the theme base style (`labelLarge`); `xs`/`sm` override it.
  TextStyle? textStyle(TextTheme textTheme) => switch (this) {
    xs => textTheme.labelSmall,
    sm => textTheme.labelMedium,
    md => textTheme.labelLarge,
  };
}

/// {@template flowin_button}
/// A Flowin button.
///
/// This is a *thin* composition over the framework's native button widgets:
/// each [FlowinButtonVariant] maps to a [FilledButton], [FilledButton.tonal],
/// [TextButton], or [OutlinedButton]. Shape, corner radius, and base text style
/// come from the theme's component themes (`filledButtonTheme`, …) — they are
/// **not** hardcoded here. Only the per-call concerns that the theme cannot
/// know — which variant, which size — are resolved by this widget, layered on
/// top of the theme as size-specific padding / minimum size and, for the
/// destructive variant, the error color role.
/// {@endtemplate}
class FlowinButton extends StatelessWidget {
  /// {@macro flowin_button}
  const FlowinButton({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.variant = FlowinButtonVariant.filled,
    this.size = FlowinButtonSize.defaultSize,
    super.key,
  }) : assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// A filled (primary) button.
  const FlowinButton.filled({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.size = FlowinButtonSize.defaultSize,
    super.key,
  }) : variant = FlowinButtonVariant.filled,
       assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// A tonal (secondary) button.
  const FlowinButton.tonal({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.size = FlowinButtonSize.defaultSize,
    super.key,
  }) : variant = FlowinButtonVariant.tonal,
       assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// A low-emphasis text button.
  const FlowinButton.text({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.size = FlowinButtonSize.defaultSize,
    super.key,
  }) : variant = FlowinButtonVariant.text,
       assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// An outlined button.
  const FlowinButton.outline({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.size = FlowinButtonSize.defaultSize,
    super.key,
  }) : variant = FlowinButtonVariant.outline,
       assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// A destructive action button.
  const FlowinButton.destructive({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.size = FlowinButtonSize.defaultSize,
    super.key,
  }) : variant = FlowinButtonVariant.destructive,
       assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// The button label. Either [label] or [child] must be provided.
  final String? label;

  /// The button content. Takes precedence over [label] when both are provided.
  final Widget? child;

  /// Called when the button is tapped. A null callback disables the button.
  final VoidCallback? onPressed;

  /// An optional leading icon.
  final Widget? icon;

  /// The visual variant.
  final FlowinButtonVariant variant;

  /// The size.
  final FlowinButtonSize size;

  @override
  Widget build(BuildContext context) {
    // Size is the only per-call dimension the theme can't encode globally:
    // content padding, min height, icon size, and the per-size label text
    // style (md = theme base; xs/sm override it).
    final sizeStyle = ButtonStyle(
      padding: WidgetStatePropertyAll(size.padding),
      minimumSize: WidgetStatePropertyAll(Size(0, size.minHeight)),
      iconSize: WidgetStatePropertyAll(size.iconSize.value),
      textStyle: WidgetStatePropertyAll(
        size.textStyle(Theme.of(context).textTheme),
      ),
    );

    final content = child ?? Text(label!);

    final button = switch (variant) {
      FlowinButtonVariant.filled => _build(
        icon: icon,
        style: sizeStyle,
        content: content,
        builder: FilledButton.new,
        iconBuilder: FilledButton.icon,
      ),
      FlowinButtonVariant.tonal => _build(
        icon: icon,
        style: sizeStyle,
        content: content,
        builder: FilledButton.tonal,
        iconBuilder: FilledButton.tonalIcon,
      ),
      FlowinButtonVariant.text => _build(
        icon: icon,
        style: sizeStyle,
        content: content,
        builder: TextButton.new,
        iconBuilder: TextButton.icon,
      ),
      FlowinButtonVariant.outline => _build(
        icon: icon,
        style: sizeStyle,
        content: content,
        builder: OutlinedButton.new,
        iconBuilder: OutlinedButton.icon,
      ),
      // Destructive layers the error color role onto the filled theme.
      FlowinButtonVariant.destructive => _build(
        icon: icon,
        style: sizeStyle.copyWith(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.errorContainer,
          ),
          foregroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        content: content,
        builder: FilledButton.new,
        iconBuilder: FilledButton.icon,
      ),
    };

    // Per-size outer padding around the button (md = none).
    final outer = size.outerPadding;
    if (outer == EdgeInsets.zero) return button;
    return Padding(padding: outer, child: button);
  }

  Widget _build({
    required Widget? icon,
    required ButtonStyle style,
    required Widget content,
    required Widget Function({
      required VoidCallback? onPressed,
      required Widget child,
      ButtonStyle? style,
    })
    builder,
    required Widget Function({
      required VoidCallback? onPressed,
      required Widget label,
      Widget? icon,
      ButtonStyle? style,
    })
    iconBuilder,
  }) {
    if (icon != null) {
      return iconBuilder(
        onPressed: onPressed,
        icon: icon,
        label: content,
        style: style,
      );
    }
    return builder(onPressed: onPressed, style: style, child: content);
  }
}
