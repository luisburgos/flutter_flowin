import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// The selection state of a [FlowinChip].
enum FlowinChipVariant {
  /// The chip is selected (the chosen chip in a group).
  selected,

  /// The chip is not selected.
  unselected,

  /// The chip is not selected and rendered with reduced emphasis.
  unselectedDimmed;

  /// Whether this variant represents a selected chip.
  bool get isSelected => this == FlowinChipVariant.selected;

  /// The opacity applied to the chip for this variant.
  double get opacity => switch (this) {
    FlowinChipVariant.selected || FlowinChipVariant.unselected => 1,
    FlowinChipVariant.unselectedDimmed => 0.5,
  };
}

/// Inset applied to the label when the chip has a [FlowinChip.leading].
///
/// `chipTheme` pins `labelPadding` to zero, which is right for a label-only
/// chip — production's chip is a bare Container with no leading slot, so
/// Material's default 8-per-side would be slack around a lone label. It is
/// wrong once a leading widget is present: the same zero closes the gap before
/// the label and leaves the icon touching the text.
///
/// The half step is a true 4px now that the icon no longer overflows its
/// box: the old near-touching look was the glyph painting past a squeezed
/// avatar box into the gap, not the gap itself being too small.
///
/// The vertical component is what sizes the leading correctly. RenderChip's
/// content height is label plus labelPadding, the avatar box tracks that
/// content height, and its layout *asserts* no box exceeds it — so with a
/// zero labelPadding a 16px icon was squeezed into a label-height 12px box
/// and painted past it, spilling into the gap and fraying the pill. Two
/// pixels per side lifts the content to 16, exactly the `sm` icon step the
/// leading slot is built for. (Unconstraining `avatarBoxConstraints` instead
/// trips the assert and crashes in debug.)
const _leadingLabelGap = EdgeInsetsDirectional.only(
  start: FlowinDesignSpace.space100,
  top: FlowinDesignSpace.space50,
  bottom: FlowinDesignSpace.space50,
);

/// {@template flowin_chip}
/// A Flowin chip.
///
/// A *thin* composition over the framework's [ChoiceChip]. The pill shape,
/// background/selected colors, border, label style, and padding all come from
/// the theme's `chipTheme` — they are **not** hardcoded here. Only the per-call
/// concerns the theme cannot encode are resolved by this widget: the
/// [FlowinChipVariant] selection state and the dimmed opacity.
/// {@endtemplate}
class FlowinChip extends StatelessWidget {
  /// {@macro flowin_chip}
  const FlowinChip({
    required this.label,
    this.variant = FlowinChipVariant.unselected,
    this.onSelected,
    this.onLongPress,
    this.leading,
    this.constraints,
    super.key,
  });

  /// The chip's label. Accepts arbitrary content, not only text.
  final Widget label;

  /// The selection state of the chip.
  final FlowinChipVariant variant;

  /// Called when the chip is tapped, with the desired selection state.
  ///
  /// A null callback renders the chip non-interactive.
  final ValueChanged<bool>? onSelected;

  /// Called when the chip is long-pressed.
  ///
  /// Secondary gesture: it does not change selection. A null callback disables
  /// the long-press gesture.
  final VoidCallback? onLongPress;

  /// An optional widget shown before the label, typically an icon.
  ///
  /// Maps onto the framework's `ChoiceChip.avatar` slot. Named `leading` here
  /// to match `FlowinAppBar` and because the slot is positional, not
  /// semantic — Material's own doc calls it "a widget to display prior to the
  /// chip's label", and `avatar` is a Material 2 holdover from contact chips.
  final Widget? leading;

  /// Size constraints for the chip.
  ///
  /// A chip otherwise sizes to its content plus the theme's padding, so chips
  /// in a row end up ragged when their labels differ in length. Supply a
  /// minimum to make a group uniform.
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final chip = ChoiceChip(
      label: label,
      // The framework's slot keeps its Material name; ours does not.
      avatar: leading,
      selected: variant.isSelected,
      onSelected: onSelected,
      // Null defers to the theme's zero; see [_leadingLabelGap].
      labelPadding: leading == null ? null : _leadingLabelGap,
      // ChipThemeData cannot express these two, so they are pinned here:
      // production's chip is a bare GestureDetector+Container with no 48pt
      // tap-target inflation and no density-driven insets, so the rendered
      // box stays padding-driven. See oracleChipBoxTolerance.
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
    );

    // ChoiceChip has no long-press hook; layer one on top when provided
    // without disturbing the tap/selection behavior it owns.
    final gestured = onLongPress == null
        ? chip
        : GestureDetector(onLongPress: onLongPress, child: chip);

    // Inside the gesture layer so the whole tappable box is constrained, not
    // just the painted chip.
    final sized = constraints == null
        ? gestured
        : ConstrainedBox(constraints: constraints!, child: gestured);

    return Opacity(opacity: variant.opacity, child: sized);
  }
}
