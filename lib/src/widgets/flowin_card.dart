import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// {@template flowin_card_border_radius}
/// Per-corner radii for a [FlowinCard].
/// {@endtemplate}
class FlowinCardBorderRadius {
  /// {@macro flowin_card_border_radius}
  const FlowinCardBorderRadius({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  /// A uniform radius applied to every corner.
  const FlowinCardBorderRadius.all(double radius)
    : topLeft = radius,
      topRight = radius,
      bottomLeft = radius,
      bottomRight = radius;

  /// The default Flowin card radius (radius400 on every corner).
  const FlowinCardBorderRadius.medium()
    : topLeft = FlowinDesignRadius.radius400,
      topRight = FlowinDesignRadius.radius400,
      bottomLeft = FlowinDesignRadius.radius400,
      bottomRight = FlowinDesignRadius.radius400;

  /// The top-left corner radius.
  final double topLeft;

  /// The top-right corner radius.
  final double topRight;

  /// The bottom-left corner radius.
  final double bottomLeft;

  /// The bottom-right corner radius.
  final double bottomRight;

  /// Builds the smoothed (continuous) border radius from these corners.
  SmoothBorderRadius toSmoothBorderRadius() {
    SmoothRadius corner(double r) => SmoothRadius(
      cornerRadius: r,
      cornerSmoothing: FlowinDesignRadius.iOSSmooth,
    );
    return SmoothBorderRadius.only(
      topLeft: corner(topLeft),
      topRight: corner(topRight),
      bottomLeft: corner(bottomLeft),
      bottomRight: corner(bottomRight),
    );
  }
}

/// {@template flowin_card}
/// A surface with iOS-style smooth (continuous) corners — the one thing
/// Material's [Card] cannot draw.
///
/// The default background color comes from the theme's `cardTheme`
/// (`secondaryContainer`); pass [backgroundColor] to override. Everything else
/// (the smooth-corner shape, optional border, shadows, sizing) is intrinsic to
/// the card and supplied here because the framework has no equivalent.
/// {@endtemplate}
class FlowinCard extends StatelessWidget {
  /// {@macro flowin_card}
  const FlowinCard({
    required this.child,
    this.borderRadius,
    this.borderSide = BorderSide.none,
    this.clipChild = false,
    this.resolveForeground = true,
    this.foregroundColor,
    this.size,
    this.backgroundColor,
    this.margin,
    this.padding,
    this.shadows,
    super.key,
  });

  /// The card's content.
  final Widget child;

  /// The per-corner radii.
  ///
  /// When null the radius is resolved from the theme's `cardTheme.shape`, so
  /// changing that slot once moves every card. Pass a value to override a
  /// single card. Falls back to [FlowinCardBorderRadius.medium] only when the
  /// theme carries no card shape at all.
  final FlowinCardBorderRadius? borderRadius;

  /// An optional border drawn around the card.
  final BorderSide borderSide;

  /// The fill color. Falls back to `cardTheme.color` when null.
  final Color? backgroundColor;

  /// Outer margin.
  final EdgeInsets? margin;

  /// Inner padding.
  final EdgeInsets? padding;

  /// An explicit size for the card.
  final Size? size;

  /// Optional drop shadows.
  final List<BoxShadow>? shadows;

  /// Whether to clip [child] to the smooth corners.
  final bool clipChild;

  /// Whether the card resolves a readable text and icon colour for [child]
  /// against its own fill. Defaults to true.
  ///
  /// A card's fill can come from *data* — a team colour, a user accent — but
  /// its content would otherwise inherit the ambient text colour, which the
  /// theme chose for a theme surface, not for this fill. Measured across four
  /// realistic fills, six of eight theme/fill pairings fell below the 4.5:1
  /// readable minimum; dark-grey body text on a black card is 1.18:1. The
  /// failures also invert between brightnesses — light themes fail on dark
  /// fills, dark themes on light ones — so no single inherited colour can
  /// serve a fill the theme cannot see.
  ///
  /// Set false to keep the inherited colour, for a card whose content manages
  /// its own colours or whose fill is not what the content actually sits on.
  ///
  /// A fully transparent fill is never resolved against, whatever this is set
  /// to: the fill is not what the content is read against, and a transparent
  /// colour reports zero luminance, which would resolve as if it were black.
  final bool resolveForeground;

  /// A preferred text and icon colour for [child].
  ///
  /// Tried **first** and kept when it is legible on the card's fill; when it
  /// is not, the resolver falls back to black or white rather than rendering
  /// unreadable content. It is a preference, not an override — a card cannot
  /// promise both "your exact colour" and "readable", and this contract
  /// chooses readable.
  ///
  /// Ignored when [resolveForeground] is false, since nothing is resolved at
  /// all in that case, and when the fill is transparent.
  final Color? foregroundColor;

  /// The corner radii carried by the theme's card slot.
  ///
  /// The slot holds a platform shape rather than Flowin's per-corner value, so
  /// its radii are read back out. Anything that is not a rounded rectangle
  /// (a stadium, a circle) has no per-corner radius to read, so the Flowin
  /// default stands in.
  FlowinCardBorderRadius _themeBorderRadius(BuildContext context) {
    final shape = Theme.of(context).cardTheme.shape;
    if (shape is! RoundedRectangleBorder) {
      return const FlowinCardBorderRadius.medium();
    }
    final radius = shape.borderRadius.resolve(Directionality.of(context));
    return FlowinCardBorderRadius(
      topLeft: radius.topLeft.x,
      topRight: radius.topRight.x,
      bottomLeft: radius.bottomLeft.x,
      bottomRight: radius.bottomRight.x,
    );
  }

  @override
  Widget build(BuildContext context) {
    final smoothRadius = (borderRadius ?? _themeBorderRadius(context))
        .toSmoothBorderRadius();
    final effectiveBackgroundColor =
        backgroundColor ??
        Theme.of(context).cardTheme.color ??
        Theme.of(context).colorScheme.secondaryContainer;

    // A transparent fill is whatever is behind the card, which this widget
    // cannot see, so the inherited colour is the only correct answer.
    final resolvable = effectiveBackgroundColor.a > 0;

    var content = child;
    if (resolveForeground && resolvable) {
      final foreground = AccessibleColorConfig(
        seedColor: effectiveBackgroundColor,
        backgroundColor: effectiveBackgroundColor,
        preferredForegroundColor: foregroundColor,
      ).foregroundColor;
      content = DefaultTextStyle.merge(
        style: TextStyle(color: foreground),
        child: IconTheme.merge(
          data: IconThemeData(color: foreground),
          child: content,
        ),
      );
    }

    return Container(
      width: size?.width,
      height: size?.height,
      margin: margin,
      padding: padding,
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          side: borderSide,
          borderRadius: smoothRadius,
        ),
        color: effectiveBackgroundColor,
        shadows: shadows,
      ),
      child: clipChild
          ? ClipSmoothRect(radius: smoothRadius, child: content)
          : content,
    );
  }
}
