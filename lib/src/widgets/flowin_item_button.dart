import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// The visual variant of a [FlowinItemButton].
///
/// Mirrors the button variant set; the default is [tonal] (the list-row idiom
/// is most commonly tonal).
enum FlowinItemButtonVariant {
  /// A tonal, medium-emphasis row (default).
  tonal,

  /// A solid, high-emphasis row.
  filled,

  /// A low-emphasis, label-only row.
  text,

  /// An outlined, medium-emphasis row.
  outline,

  /// A destructive action row.
  destructive,
}

/// The uniform inner padding of a [FlowinItemButton] (all sides).
const double _kItemButtonPadding = FlowinDesignSpace.space400;

/// The minimum height of a [FlowinItemButton] — the `md` step of the control
/// scale ([FlowinDesignControlSize.md], 56), production's md fixedSize.
///
/// Spelled as a literal because an enum getter is not const-evaluable; the
/// fidelity suite pins it to the token.
const double _kItemButtonMinHeight = 56;

/// The leading icon size — the `md` step of the icon scale
/// ([FlowinDesignIconSize.md], 20).
///
/// Spelled as a literal because `FlowinDesignIconSize.md.value` is an enum
/// getter, which Dart cannot evaluate in a `const` expression; the assertion
/// in the fidelity suite pins the two together.
///
/// This is a deliberate deviation from the legacy reference, which rendered
/// 24: `FDItemButton` hardcoded the *button* size `md`, and the legacy button
/// scale mapped that to icon size `lg`. The v1 contract instead binds the row
/// icon directly to `{iconSize.md}`, so the icon reads as a leading affordance
/// rather than competing with the label. See `specItemButtonIconSize`.
const double _kItemButtonIconSize = 20;

/// {@template flowin_item_button}
/// A full-width, **left-aligned** list-row button.
///
/// Unlike `FlowinButton` — which is centered and content-width — this stretches
/// to its parent's width and aligns its content to the leading edge, making it
/// suitable for lists and menus. It is a *thin* composition over the
/// framework's native button widgets (per [variant]); shape, base text style,
/// and the per-variant color roles come from the theme. Only the full-width
/// sizing, center-left alignment, uniform padding, and the destructive
/// error-role overlay are resolved here.
/// {@endtemplate}
class FlowinItemButton extends StatelessWidget {
  /// {@macro flowin_item_button}
  const FlowinItemButton({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.variant = FlowinItemButtonVariant.tonal,
    super.key,
  }) : assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// A tonal (default) item button.
  const FlowinItemButton.tonal({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    super.key,
  }) : variant = FlowinItemButtonVariant.tonal,
       assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// A filled item button.
  const FlowinItemButton.filled({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    super.key,
  }) : variant = FlowinItemButtonVariant.filled,
       assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// A low-emphasis text item button.
  const FlowinItemButton.text({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    super.key,
  }) : variant = FlowinItemButtonVariant.text,
       assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// An outlined item button.
  const FlowinItemButton.outline({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    super.key,
  }) : variant = FlowinItemButtonVariant.outline,
       assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// A destructive item button.
  const FlowinItemButton.destructive({
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    super.key,
  }) : variant = FlowinItemButtonVariant.destructive,
       assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// The row label. Either [label] or [child] must be provided.
  final String? label;

  /// The row content. Takes precedence over [label] when both are provided.
  final Widget? child;

  /// Called when the row is tapped. A null callback disables the row.
  final VoidCallback? onPressed;

  /// An optional leading icon, rendered at the leading edge before the label.
  final Widget? icon;

  /// The visual variant.
  final FlowinItemButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    // Full-width, left-aligned, uniform 16 padding. Colors and text style are
    // theme-level; these are the per-call concerns the theme can't encode.
    //
    // The shape is pinned here rather than inherited. Every other Flowin
    // button is a pill (Material's StadiumBorder default), but a full-width
    // row 56 tall would then have 28-radius ends. A row reads as a surface,
    // not as a pill, so it takes radius400.
    const style = ButtonStyle(
      alignment: Alignment.centerLeft,
      padding: WidgetStatePropertyAll(
        EdgeInsets.all(_kItemButtonPadding),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(FlowinDesignRadius.radius400),
          ),
        ),
      ),
      // Full width with the production minimum height (md fixedSize, 56).
      minimumSize: WidgetStatePropertyAll(
        Size(double.infinity, _kItemButtonMinHeight),
      ),
      iconSize: WidgetStatePropertyAll(_kItemButtonIconSize),
    );

    final content = child ?? Text(label!);

    final button = switch (variant) {
      FlowinItemButtonVariant.tonal => _build(
        style: style,
        content: content,
        builder: FilledButton.tonal,
        iconBuilder: FilledButton.tonalIcon,
      ),
      FlowinItemButtonVariant.filled => _build(
        style: style,
        content: content,
        builder: FilledButton.new,
        iconBuilder: FilledButton.icon,
      ),
      FlowinItemButtonVariant.text => _build(
        style: style,
        content: content,
        builder: TextButton.new,
        iconBuilder: TextButton.icon,
      ),
      FlowinItemButtonVariant.outline => _build(
        style: style,
        content: content,
        builder: OutlinedButton.new,
        iconBuilder: OutlinedButton.icon,
      ),
      FlowinItemButtonVariant.destructive => _build(
        style: style.copyWith(
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

    // Stretch to the parent's width so the row fills its container.
    return SizedBox(width: double.infinity, child: button);
  }

  Widget _build({
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
