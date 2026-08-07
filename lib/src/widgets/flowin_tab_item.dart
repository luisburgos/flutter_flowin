import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';
// Imported for the doc-comment reference to [FlowinTabs].
import 'package:flutter_flowin/src/widgets/flowin_tabs.dart';

/// The gap between a [FlowinTabItem]'s leading icon and its label.
// Production uses a raw 4px gap (fd_tab_item.dart) — space100.
const double _kTabItemIconGap = FlowinDesignSpace.space100;

/// {@template flowin_tab_item}
/// A single cell within a [FlowinTabs] bar: an **icon-left** row with a
/// single-line, **ellipsized** label. The label style comes from the bar's
/// tab theme.
///
/// This differs from Material's default `Tab(icon:, text:)`, which stacks the
/// icon *above* the label. Pass instances as the `tabs` of [FlowinTabs]; the
/// bar sizes and wraps them to its height, and applies selected/unselected
/// coloring from the theme.
/// {@endtemplate}
class FlowinTabItem extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro flowin_tab_item}
  const FlowinTabItem({
    required this.label,
    this.icon,
    this.height = kFlowinTabsHeight,
    super.key,
  });

  /// The tab label. Rendered single-line and ellipsized when constrained.
  final String label;

  /// An optional leading icon, rendered to the **left** of the label.
  final Widget? icon;

  /// The height of the cell, and so of its tap target.
  ///
  /// Defaults to the bar's own height so the whole cell is tappable. Set it
  /// only when the bar is given a non-default [FlowinTabs.height].
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final labelWidget = Flexible(
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        // Deliberately unstyled: the bar's tab theme supplies the label
        // style, so a Flowin cell and a raw platform cell in the same bar
        // render alike. A style set here would outrank the theme.
      ),
    );

    // Wrapped in a [Tab] so the cell fills the bar's height, which is what
    // makes the whole cell tappable rather than just the label — the ink
    // follows the child's size, and a row sized to its own content leaves a
    // 16-tall target on a 56-tall bar.
    //
    // `Tab` rather than a stretched row: a scrollable TabBar lays its tabs
    // out without a bounded height, and a row that stretches into that throws
    // during layout. `Tab` reports a height instead of demanding one, so the
    // same cell works in both the fixed and scrollable bars.
    return Tab(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: _kTabItemIconGap),
          ],
          labelWidget,
        ],
      ),
    );
  }
}
