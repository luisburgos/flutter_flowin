import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The stage a [FlowinPlayground]'s subject renders on.
///
/// The background defaults to `outlineVariant` rather than a
/// `surfaceContainer` role: the Flowin scheme leaves those at their default,
/// which resolves to plain `surface` — pure white in light mode — so a
/// container role would tint nothing and a white subject would vanish into
/// its own stage. See flowin_pm#33.
///
/// That tint is wrong for a subject that is itself a neutral: `outlineVariant`
/// and `secondaryContainer` resolve to the same value, so a tonal button on
/// the default stage is invisible. Those callers pass [background].
class FlowinPlaygroundPreview extends StatelessWidget {
  /// {@macro flowin_playground_preview}
  const FlowinPlaygroundPreview({
    required this.child,
    this.maxWidth,
    this.background,
    super.key,
  });

  /// The subject being previewed.
  final Widget child;

  /// Clamps the subject's width.
  ///
  /// Pass the width the real component renders at — showing it wider than it
  /// can ever reach would misinform the eye this stage exists to inform.
  final double? maxWidth;

  /// Overrides the stage's background.
  ///
  /// Pass `surface` when the subject is a neutral that the default tint would
  /// swallow — a tonal or outlined control.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background ?? context.colorScheme.outlineVariant,
      ),
      child: Padding(
        padding: const EdgeInsets.all(FlowinDesignSpace.space600),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? double.infinity,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
