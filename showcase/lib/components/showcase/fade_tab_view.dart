import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_flowin/primitives.dart';

/// A [TabBarView] whose pages cross-fade in place instead of sliding.
///
/// Each page is a [FlowinFadePage] driven by the [TabController]'s animation —
/// the same primitive the pager's `FlowinPageTransition.fade` uses, wired to a
/// different position source.
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
    final animation = controller.animation!;
    return TabBarView(
      controller: controller,
      children: [
        for (var index = 0; index < children.length; index++)
          FlowinFadePage(
            listenable: animation,
            positionOf: () => animation.value,
            index: index,
            child: children[index],
          ),
      ],
    );
  }
}
