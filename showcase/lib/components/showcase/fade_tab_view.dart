import 'package:flutter_flowin/flutter_flowin.dart';

/// A [TabBarView] whose pages cross-fade in place instead of sliding.
///
/// The tab view still owns the motion — swiping scrubs the fade and the
/// controller's animation drives it — but each page counter-translates by
/// exactly its slide offset, so it holds still and only its opacity follows.
/// The same idea as the pager's `FlowinPageTransition.fade`, reimplemented
/// here because a [TabBarView] is driven by a [TabController]'s animation
/// rather than a [PageController].
class FadeTabView extends StatelessWidget {
  /// {@macro fade_tab_view}
  const FadeTabView({
    required this.controller,
    required this.children,
    super.key,
  });

  /// The controller shared with the tab bar.
  final TabController controller;

  /// The pages, one per tab.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: [
        for (var index = 0; index < children.length; index++)
          _FadeTabPage(
            controller: controller,
            index: index,
            child: children[index],
          ),
      ],
    );
  }
}

class _FadeTabPage extends StatelessWidget {
  const _FadeTabPage({
    required this.controller,
    required this.index,
    required this.child,
  });

  final TabController controller;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder inside the tab view: each page is laid out at the
    // viewport's width, which is exactly the slide offset to cancel.
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: controller.animation!,
        builder: (context, child) {
          final delta = controller.animation!.value - index;
          final opacity = (1 - delta.abs()).clamp(0.0, 1.0);
          return Transform.translate(
            offset: Offset(delta * constraints.maxWidth, 0),
            // A page mid-fade overlaps its neighbour, so it must not
            // intercept the neighbour's taps.
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
