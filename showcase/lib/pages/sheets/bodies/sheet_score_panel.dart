import 'package:flutter_flowin/flutter_flowin.dart';

/// A full-bleed body: a dark panel spanning the card corner to corner.
///
/// Deliberately carries no horizontal inset of its own. That is the whole
/// point of the demo — the sheet insets nothing, so reaching the card edge is
/// the body's own choice rather than something it has to undo.
class SheetScorePanel extends StatelessWidget {
  /// {@macro sheet_score_panel}
  const SheetScorePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(
        minHeight: FlowinDesignSpace.space1400 * 3,
      ),
      color: scheme.inverseSurface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: FlowinDesignSpace.space600,
          horizontal: FlowinDesignSpace.space800,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final score in ['2', '2'])
              Text(
                score,
                style: context.textTheme.displaySmall?.copyWith(
                  color: scheme.onInverseSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
