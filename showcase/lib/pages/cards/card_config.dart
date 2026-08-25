import 'package:equatable/equatable.dart';
import 'package:flowin_showcase/components/flowin_spacing_knob.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Which corner treatment the previewed card carries.
enum CardRadius {
  /// The theme's own card shape — what a card gets when it says nothing.
  themed,

  /// A uniform radius400 on every corner, the Flowin default.
  medium,

  /// A uniform radius1000, the radius action sheets use.
  large,

  /// Different radii per corner.
  asymmetric,
}

/// The heights the previewed card can be pinned to.
///
/// Its own scale rather than [SpacingStep]: the spacing scale tops out at 48,
/// which is shorter than a card with a single line of content and its default
/// padding, so reusing it would offer mostly heights that clip. These are
/// space tokens still — a card height is a sizing decision, but the values it
/// lands on are the system's, not arbitrary pixels.
enum CardHeight {
  /// A compact row.
  compact(FlowinDesignSpace.space1600),

  /// The height a single-line card sits at comfortably.
  regular(FlowinDesignSpace.space2400),

  /// Room for a title, body and an action.
  tall(FlowinDesignSpace.space4000);

  const CardHeight(this.value);

  /// The height in logical pixels.
  final double value;
}

/// Which fill the previewed card carries.
///
/// The distinction that matters is not which colour but where it came from:
/// a theme fill is one the card can reason about, a data fill is one only the
/// caller knows, and transparent is no fill at all.
enum CardFill {
  /// The theme's card colour, used when the card says nothing.
  themed,

  /// A dark fill supplied by the caller, standing in for data.
  dataDark,

  /// A light fill supplied by the caller, standing in for data.
  dataLight,

  /// No fill, so whatever sits behind the card shows through.
  transparent,
}

/// The state of the [FlowinCard] preview.
///
/// Value equality is what lets the playground tell a preset from a custom
/// configuration, so it is a requirement of the type rather than a
/// convenience.
class CardConfig extends Equatable {
  /// {@macro card_config}
  const CardConfig({
    this.radius = CardRadius.themed,
    this.fill = CardFill.themed,
    this.bordered = false,
    this.elevated = false,
    this.resolveForeground = true,
    this.preferCream = false,
    this.clipChild = false,
    this.compareContrast = false,
    this.padding = SpacingStep.md,
    this.margin = SpacingStep.none,
    this.intrinsicHeight = false,
    this.height = CardHeight.regular,
  });

  /// The corner treatment.
  final CardRadius radius;

  /// Where the card's fill comes from.
  final CardFill fill;

  /// Whether a hairline is drawn around the card.
  final bool bordered;

  /// Whether the card casts the themed drop shadow.
  final bool elevated;

  /// Whether the card resolves a readable content colour against its fill.
  ///
  /// Inert on a transparent fill: the card cannot see what is behind it, so
  /// there is nothing to resolve against.
  final bool resolveForeground;

  /// Whether a cream foreground colour is asked for.
  ///
  /// Demonstrates that [FlowinCard.foregroundColor] is a preference rather
  /// than an override: it is kept where legible and dropped where it is not.
  final bool preferCream;

  /// Whether the child is clipped to the card's smooth corners.
  ///
  /// Only observable with a child that would otherwise paint past them, so the
  /// preview fills the card edge to edge while this is on.
  final bool clipChild;

  /// Whether the preview shows the resolved and inherited results together.
  ///
  /// The resolver's whole contract is a comparison — this colour rather than
  /// the one the theme would have supplied — so one card can only ever show
  /// half of it. Turning this on renders the same card both ways at once.
  final bool compareContrast;

  /// How much room the card leaves around its content.
  ///
  /// Inert while [clipChild] is on: a clipped child is meant to reach the
  /// card's corners, and an inset would hold it away from the very edges it is
  /// being clipped to.
  final SpacingStep padding;

  /// How much room the card keeps outside itself.
  ///
  /// Distinct from [padding] in who it pushes away: padding holds the content
  /// off the card's edge, margin holds the card off its neighbours. Both are
  /// the card's own parameters, and reading them side by side is the clearest
  /// way to see which is which.
  final SpacingStep margin;

  /// Whether the card takes its height from its content.
  ///
  /// The question behind `size`: most callers never pin a height and let the
  /// content decide, which is what a null `size` does. Pinning one is the
  /// exception — a row that has to align with its neighbours — so the demo
  /// shows both rather than only the pinned case it happened to be built for.
  final bool intrinsicHeight;

  /// The height the card is pinned to when not [intrinsicHeight].
  final CardHeight height;

  /// A copy with the given fields replaced.
  CardConfig copyWith({
    CardRadius? radius,
    CardFill? fill,
    bool? bordered,
    bool? elevated,
    bool? resolveForeground,
    bool? preferCream,
    bool? clipChild,
    bool? compareContrast,
    SpacingStep? padding,
    SpacingStep? margin,
    bool? intrinsicHeight,
    CardHeight? height,
  }) => CardConfig(
    radius: radius ?? this.radius,
    fill: fill ?? this.fill,
    bordered: bordered ?? this.bordered,
    elevated: elevated ?? this.elevated,
    resolveForeground: resolveForeground ?? this.resolveForeground,
    preferCream: preferCream ?? this.preferCream,
    clipChild: clipChild ?? this.clipChild,
    compareContrast: compareContrast ?? this.compareContrast,
    padding: padding ?? this.padding,
    margin: margin ?? this.margin,
    intrinsicHeight: intrinsicHeight ?? this.intrinsicHeight,
    height: height ?? this.height,
  );

  @override
  List<Object?> get props => [
    radius,
    fill,
    bordered,
    elevated,
    resolveForeground,
    preferCream,
    clipChild,
    compareContrast,
    padding,
    margin,
    intrinsicHeight,
    height,
  ];
}
