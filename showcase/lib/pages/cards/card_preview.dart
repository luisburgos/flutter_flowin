import 'package:flowin_showcase/pages/cards/card_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// A dark fill a caller might realistically supply from data.
const _dataDark = Color(0xFF1A237E);

/// A light fill a caller might realistically supply from data.
///
/// White specifically: it is the fill a light theme's own text colour fails
/// against, which is the case the foreground resolver exists for.
const _dataLight = Color(0xFFFFFFFF);

/// The cream the preview asks for when the preference knob is on.
///
/// Legible on the dark fill and far short of readable on the light one, so the
/// same request is kept in one case and dropped in the other.
const _cream = Color(0xFFFFF8E1);

/// Draws the bounds a card's margin holds it away from.
///
/// Margin is space *outside* the card, so on an empty stage it is invisible —
/// the card just appears smaller, which is what the padding knob does too.
/// A dashed edge marks where the card would sit at zero margin, so the two
/// knobs read as the different things they are.
class CardMarginBounds extends StatelessWidget {
  /// {@macro card_margin_bounds}
  const CardMarginBounds({required this.child, super.key});

  /// The card, margin and all.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(FlowinDesignRadius.radius400),
      ),
      child: child,
    );
  }
}

/// The card under test, built from a [CardConfig].
///
/// A widget rather than a builder method so the preview keeps its own element
/// across configuration changes.
class CardDemo extends StatelessWidget {
  /// {@macro card_demo}
  const CardDemo({required this.config, this.resolveOverride, super.key});

  /// The configuration driving the card.
  final CardConfig config;

  /// Forces [FlowinCard.resolveForeground] regardless of the configuration.
  ///
  /// Set only by [CardContrastDemo], which renders this card twice to put the
  /// resolved and inherited results beside each other. Null means the
  /// configuration's own value stands.
  final bool? resolveOverride;

  /// The corner radii for [CardConfig.radius].
  ///
  /// Null means the card reads its shape from the theme, which is a distinct
  /// case from asking for the same radii explicitly.
  FlowinCardBorderRadius? get _borderRadius => switch (config.radius) {
    CardRadius.themed => null,
    CardRadius.medium => const FlowinCardBorderRadius.medium(),
    CardRadius.large => const FlowinCardBorderRadius.all(
      FlowinDesignRadius.radius1000,
    ),
    CardRadius.asymmetric => const FlowinCardBorderRadius(
      topLeft: FlowinDesignRadius.radius800,
      topRight: FlowinDesignRadius.radius100,
      bottomLeft: FlowinDesignRadius.radius100,
      bottomRight: FlowinDesignRadius.radius800,
    ),
  };

  /// The fill for [CardConfig.fill].
  ///
  /// Null means the card falls back to `cardTheme.color`.
  Color? get _backgroundColor => switch (config.fill) {
    CardFill.themed => null,
    CardFill.dataDark => _dataDark,
    CardFill.dataLight => _dataLight,
    CardFill.transparent => Colors.transparent,
  };

  @override
  Widget build(BuildContext context) {
    // A transparent or same-as-page fill has no edge of its own, so without a
    // border those specimens would read as floating text rather than a card.
    final borderSide = config.bordered
        ? BorderSide(color: context.colorScheme.outlineVariant)
        : BorderSide.none;

    // Clipping is only observable against a child that paints to the corners,
    // so the demo swaps in a filled child while that knob is on.
    final child = config.clipChild
        ? ColoredBox(
            color: context.colorScheme.primary,
            child: Center(
              child: Text(
                'Clipped to the squircle',
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
          )
        // Min height, so an intrinsic card is the height of its content rather
        // than of whatever the stage would give it. One line deliberately: it
        // clears the compact step with its default inset, so the demo does not
        // open already overflowing. Turning the padding up past what a pinned
        // height can hold is a real thing to discover, but it should be
        // something a reader reaches rather than the state they arrive in.
        : Row(
            mainAxisSize: MainAxisSize.min,
            spacing: context.spacing.xs,
            children: [
              FDIcons.done.toIcon(size: FlowinDesignIconSize.sm),
              const Expanded(child: Text('Card content')),
            ],
          );

    // The card's own padding rather than a Padding around the child: the inset
    // is the card's parameter, and wrapping the child instead would leave the
    // knob demonstrating a widget the caller supplies rather than the one on
    // show. A clipped child takes none regardless — it is meant to reach the
    // corners it is being clipped to.
    final padding = config.clipChild
        ? EdgeInsets.zero
        : config.padding.all(context);

    return FlowinCard(
      // Null rather than a zero height when intrinsic: FlowinCard reads
      // `size?.height`, so only a null Size leaves the height unset — and
      // `Size.fromWidth` would pass 0, collapsing the card rather than sizing
      // it. Dropping the width with it costs nothing, since the card already
      // stretches to its parent without one.
      size: config.intrinsicHeight
          ? null
          : Size(double.infinity, config.height.value),
      borderRadius: _borderRadius,
      backgroundColor: _backgroundColor,
      borderSide: borderSide,
      shadows: config.elevated ? [context.flowinTokens.shadow] : null,
      resolveForeground: resolveOverride ?? config.resolveForeground,
      foregroundColor: config.preferCream ? _cream : null,
      clipChild: config.clipChild,
      margin: config.margin.all(context),
      padding: padding,
      child: child,
    );
  }
}

/// The same card twice: content colour resolved on one, inherited on the
/// other.
///
/// A single card cannot show what the resolver does. Toggling the knob changes
/// the one specimen, so a reader has to remember the previous state to see any
/// difference — and on a fill where the inherited colour happens to be legible
/// there is no difference to remember. Side by side, the failure is simply
/// visible.
///
/// Which column fails inverts with the theme, and that is the point: a light
/// theme fails on dark fills, a dark theme on light ones, so no single
/// inherited colour can serve a fill the theme cannot see.
class CardContrastDemo extends StatelessWidget {
  /// {@macro card_contrast_demo}
  const CardContrastDemo({required this.config, super.key});

  /// The configuration driving both cards.
  final CardConfig config;

  @override
  Widget build(BuildContext context) {
    final captionStyle = context.textTheme.labelSmall?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.spacing.sm,
      children: [
        for (final (caption, resolve) in const [
          ('Resolved against the fill', true),
          ('Inherited from the theme', false),
        ])
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(caption, style: captionStyle),
              SizedBox(height: context.spacing.xxs),
              CardDemo(config: config, resolveOverride: resolve),
            ],
          ),
      ],
    );
  }
}
