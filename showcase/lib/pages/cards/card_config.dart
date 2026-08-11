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
@immutable
class CardConfig {
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
  }) => CardConfig(
    radius: radius ?? this.radius,
    fill: fill ?? this.fill,
    bordered: bordered ?? this.bordered,
    elevated: elevated ?? this.elevated,
    resolveForeground: resolveForeground ?? this.resolveForeground,
    preferCream: preferCream ?? this.preferCream,
    clipChild: clipChild ?? this.clipChild,
    compareContrast: compareContrast ?? this.compareContrast,
  );

  @override
  bool operator ==(Object other) =>
      other is CardConfig &&
      other.radius == radius &&
      other.fill == fill &&
      other.bordered == bordered &&
      other.elevated == elevated &&
      other.resolveForeground == resolveForeground &&
      other.preferCream == preferCream &&
      other.clipChild == clipChild &&
      other.compareContrast == compareContrast;

  @override
  int get hashCode => Object.hash(
    radius,
    fill,
    bordered,
    elevated,
    resolveForeground,
    preferCream,
    clipChild,
    compareContrast,
  );
}
