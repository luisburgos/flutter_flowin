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

/// The height the card is previewed at.
const _cardHeight = 96.0;

/// The card under test, built from a [CardConfig].
///
/// A widget rather than a builder method so the preview keeps its own element
/// across configuration changes.
class CardDemo extends StatelessWidget {
  /// {@macro card_demo}
  const CardDemo({required this.config, super.key});

  /// The configuration driving the card.
  final CardConfig config;

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
        : Padding(
            padding: EdgeInsets.all(context.spacing.md),
            child: Row(
              spacing: context.spacing.xs,
              children: [
                FDIcons.done.toIcon(size: FlowinDesignIconSize.sm),
                const Expanded(child: Text('Card content')),
              ],
            ),
          );

    return FlowinCard(
      size: const Size(double.infinity, _cardHeight),
      borderRadius: _borderRadius,
      backgroundColor: _backgroundColor,
      borderSide: borderSide,
      shadows: config.elevated ? [context.flowinTokens.shadow] : null,
      resolveForeground: config.resolveForeground,
      foregroundColor: config.preferCream ? _cream : null,
      clipChild: config.clipChild,
      child: child,
    );
  }
}
