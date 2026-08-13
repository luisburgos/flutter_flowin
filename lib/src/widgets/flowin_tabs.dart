import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// The default height of a [FlowinTabs] bar.
const double kFlowinTabsHeight = FlowinDesignSpace.space1400;

/// {@template flowin_tabs}
/// A fixed-height Flowin tab bar.
///
/// A *thin* composition over the framework's [TabBar]. The label styles,
/// selected/unselected colors, tab-sized indicator, and transparent divider all
/// come from the theme's `tabBarTheme` — they are **not** hardcoded here. This
/// wrapper only fixes the bar to a Flowin height via [PreferredSize], exposing
/// the [TabController] and [tabs] the caller drives.
///
/// Because it implements [PreferredSizeWidget], it can be used directly as an
/// [AppBar.bottom].
/// {@endtemplate}
class FlowinTabs extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro flowin_tabs}
  const FlowinTabs({
    required this.controller,
    required this.tabs,
    this.isScrollable = false,
    this.height = kFlowinTabsHeight,
    super.key,
  });

  /// The controller that drives tab selection.
  final TabController controller;

  /// The tabs to display, typically [Tab] widgets.
  final List<Widget> tabs;

  /// Whether the tab bar scrolls horizontally.
  final bool isScrollable;

  /// The fixed height of the bar.
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TabBar(
        controller: controller,
        tabs: tabs,
        isScrollable: isScrollable,
        // Material 3 defaults a scrollable bar to `startOffset`, which indents
        // the first tab by 52 so it clears a leading navigation icon. A Flowin
        // bar is page content rather than an app-bar slot, so that indent
        // reads as a stray gap.
        //
        // `start` alone would then put the first label hard against the bar's
        // edge, since a scrollable tab is only as wide as its own label. The
        // row gets the standard content inset instead, so it breathes against
        // its container the way the rest of the system's content does.
        //
        // Both are set here rather than on the theme because `start` asserts
        // on a fixed bar, so the value has to follow [isScrollable].
        tabAlignment: isScrollable ? TabAlignment.start : null,
        padding: isScrollable
            ? const EdgeInsets.symmetric(
                horizontal: FlowinDesignSpace.space400,
              )
            : null,
      ),
    );
  }
}
