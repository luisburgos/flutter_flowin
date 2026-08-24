import 'package:flutter/material.dart';

/// {@template flowin_fade_page}
/// Cross-fades one page in place against a scrolling position.
///
/// The scroller still owns the motion — [listenable] drives rebuilds and
/// [positionOf] reports the continuous page position — but the page
/// counter-translates by exactly its slide offset, so it holds still and only
/// its opacity follows. A page mid-fade ignores pointers, since the
/// counter-translation overlaps it with its neighbour.
///
/// Works with any position-carrying scroller: a [PageView] page passes its
/// [PageController] as [listenable] and reads `controller.page` in
/// [positionOf]; a [TabBarView] page passes the [TabController]'s animation
/// and reads its value. The slide offset to cancel is the width the page is
/// laid out at, which both lay out at viewport width, so it is measured here
/// with a [LayoutBuilder] rather than asked of the controller.
/// {@endtemplate}
class FlowinFadePage extends StatelessWidget {
  /// {@macro flowin_fade_page}
  const FlowinFadePage({
    required this.listenable,
    required this.positionOf,
    required this.index,
    required this.child,
    super.key,
  });

  /// What drives rebuilds while the position changes — typically the
  /// [PageController] itself, or a [TabController]'s animation.
  final Listenable listenable;

  /// Reads the current continuous page position.
  ///
  /// The callback owns any guarding its source needs (e.g. a [PageController]
  /// before its first layout has no page yet and should report a fallback).
  final ValueGetter<double> positionOf;

  /// This page's index in the scroller.
  final int index;

  /// The page content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: listenable,
        builder: (context, child) {
          final delta = positionOf() - index;
          final opacity = (1 - delta.abs()).clamp(0.0, 1.0);
          return Transform.translate(
            offset: Offset(delta * constraints.maxWidth, 0),
            child: IgnorePointer(
              ignoring: opacity < 1,
              child: Opacity(opacity: opacity, child: child),
            ),
          );
        },
        child: child,
      ),
    );
  }
}
