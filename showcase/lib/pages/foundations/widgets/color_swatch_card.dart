import 'package:flutter_flowin/flutter_flowin.dart';

/// A named colour role rendered as a filled card.
class ColorSwatchCard extends StatelessWidget {
  /// {@macro color_swatch_card}
  const ColorSwatchCard({
    required this.label,
    required this.background,
    required this.foreground,
    super.key,
  });

  /// The role's name.
  final String label;

  /// The role's colour.
  final Color background;

  /// The role's matching on-colour, used for the label.
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return FlowinCard(
      backgroundColor: background,
      size: const Size(104, 64),
      child: Center(
        child: Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(color: foreground),
        ),
      ),
    );
  }
}
