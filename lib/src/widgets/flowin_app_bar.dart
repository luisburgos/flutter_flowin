import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';
import 'package:flutter_flowin/src/widgets/flowin_tabs.dart';

/// The default height of a [FlowinAppBar].
const double kFlowinAppBarHeight = FlowinDesignSpace.space1400;

/// The default minimum height/width of a [FlowinAppBar] leading/trailing slot.
const double kFlowinAppBarContentSize = FlowinDesignSpace.space1200;

/// The default padding around a [FlowinAppBar].
const double kFlowinAppBarPadding = FlowinDesignSpace.space200;

/// {@template flowin_app_bar}
/// A fixed-height top bar with leading, trailing, center [child], and an
/// optional [footer] slot.
///
/// Material's [AppBar] has a different slot model (it owns title/actions/back
/// behavior), so this is a custom layout. It implements [PreferredSizeWidget]
/// so it can be passed to [Scaffold.appBar]. Heights and padding come from
/// Flowin space tokens.
///
/// Like [AppBar], the bar insets its own content below the status bar when
/// [primary] is true — see that field for the layout contract.
/// {@endtemplate}
class FlowinAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro flowin_app_bar}
  const FlowinAppBar({
    this.leading,
    this.trailing,
    this.child,
    this.footer,
    this.height = kFlowinAppBarHeight,
    this.primary = true,
    super.key,
  });

  /// The leading slot (e.g. a back or menu button).
  final Widget? leading;

  /// The trailing slot (e.g. an action button).
  final Widget? trailing;

  /// The center slot, expanded to fill the space between the edges.
  final Widget? child;

  /// An optional footer pinned to the bottom (e.g. a divider or tab bar).
  final Widget? footer;

  /// The fixed bar height.
  final double height;

  /// Whether this app bar is displayed at the top of the screen.
  ///
  /// When true (the default), the bar's content is padded on top by the height
  /// of the system status bar, matching [AppBar.primary]. Set it to false when
  /// the bar is *not* at the top of the screen — for example nested inside a
  /// body that is already wrapped in a [SafeArea], where insetting again would
  /// double-pad.
  ///
  /// This does **not** change [preferredSize]: [Scaffold] already adds
  /// `MediaQuery.padding.top` to the height it reserves for any
  /// [PreferredSizeWidget], so including the inset here would count it twice.
  final bool primary;

  // Deliberately excludes the status-bar inset — Scaffold adds it. See
  // [primary].
  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final bar = SizedBox(
      height: height,
      child: Stack(
        children: [
          if (footer != null)
            Positioned(left: 0, right: 0, bottom: 0, child: footer!),
          Padding(
            padding: const EdgeInsets.only(
              top: kFlowinAppBarPadding,
              left: kFlowinAppBarPadding,
              right: kFlowinAppBarPadding,
            ),
            child: Row(
              children: [
                _Slot(child: leading),
                if (child != null) Expanded(child: child!) else const Spacer(),
                _Slot(child: trailing),
              ],
            ),
          ),
        ],
      ),
    );

    // Mirrors AppBar: the bar owns its status-bar inset rather than delegating
    // it to the app. `bottom: false` because a top bar never insets the bottom.
    return primary ? SafeArea(bottom: false, child: bar) : bar;
  }
}

class _Slot extends StatelessWidget {
  const _Slot({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: kFlowinAppBarContentSize,
        minWidth: kFlowinAppBarContentSize,
      ),
      child: child,
    );
  }
}

/// {@template flowin_tab_app_bar}
/// A [FlowinAppBar] whose center slot holds a [FlowinTabs] bar driven by a
/// [TabController], with a hairline divider pinned as the footer. The bar is a
/// single [kFlowinAppBarHeight]-tall row (leading · tabs · trailing).
/// Implements [PreferredSizeWidget] for use as a [Scaffold.appBar].
/// {@endtemplate}
class FlowinTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro flowin_tab_app_bar}
  const FlowinTabAppBar({
    required this.controller,
    required this.tabs,
    this.leading,
    this.trailing,
    this.isScrollable = false,
    this.dividerColor,
    this.primary = true,
    super.key,
  });

  /// The controller driving tab selection.
  final TabController controller;

  /// The tabs, typically [Tab] widgets.
  final List<Widget> tabs;

  /// The leading slot.
  final Widget? leading;

  /// The trailing slot.
  final Widget? trailing;

  /// Whether the tab bar scrolls horizontally.
  final bool isScrollable;

  /// The color of the hairline divider between the bar and the tabs.
  ///
  /// When null, falls back to the global subtle-border role
  /// ([DividerThemeData.color], bound to `outlineVariant`).
  final Color? dividerColor;

  /// Whether this app bar is displayed at the top of the screen.
  ///
  /// Forwarded to [FlowinAppBar.primary].
  final bool primary;

  static const double _height = kFlowinAppBarHeight;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    // Single-row layout: the tabs occupy the bar's center (child) slot, with a
    // token-pinned hairline pinned at the bottom as the footer. The bar stays a
    // single ~space1400-tall row (the legacy layout) rather than stacking the
    // tabs below the content row.
    return FlowinAppBar(
      leading: leading,
      trailing: trailing,
      primary: primary,
      // Token-pinned hairline (borders.regular = 1px), no extra vertical space.
      // Color falls back to the global subtle-border role when [dividerColor]
      // is null.
      footer: Divider(
        height: FlowinDesignBorders.regular,
        thickness: FlowinDesignBorders.regular,
        color: dividerColor,
      ),
      child: FlowinTabs(
        controller: controller,
        tabs: tabs,
        isScrollable: isScrollable,
        // Fit the tabs to the bar's content row (bar height minus the top
        // padding) so the single-row bar doesn't overflow its fixed height.
        height: _height - kFlowinAppBarPadding,
      ),
    );
  }
}
