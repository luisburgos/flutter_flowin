import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The showcase's tab app bar, capped to the content width.
///
/// Uncapped, an ultrawide window strands the leading icon and the toggle at
/// the screen's far corners and stretches each tab across half of it, so the
/// bar lays out under [maxWidth], centered. The hairline is the exception —
/// an edge is chrome, not content, so it spans the window: a full-width
/// divider sits behind the capped bar at the same bottom edge the bar's own
/// (now transparent) footer occupies, keeping every spacing pixel identical.
class ShowcaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro showcase_app_bar}
  const ShowcaseAppBar({
    required this.controller,
    required this.tabs,
    required this.maxWidth,
    super.key,
  });

  /// The controller driving tab selection.
  ///
  /// Owned by the caller, which shares it with the [TabBarView] the tabs
  /// switch between.
  final TabController controller;

  /// The tabs, one per page of the caller's [TabBarView].
  final List<FlowinTabItem> tabs;

  /// The widest the bar's content may lay out.
  final double maxWidth;

  @override
  Size get preferredSize => const Size.fromHeight(kFlowinAppBarHeight);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Divider(height: 1, thickness: 1),
        ),
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: FlowinTabAppBar(
              primary: !kIsWeb,
              controller: controller,
              leading: FDIcons.scanFace.toIcon(),
              trailing: const ThemeModeToggle(),
              // Silenced because the capped bar would cut it at the content
              // edge; the full-width hairline is painted behind, above.
              dividerColor: Colors.transparent,
              tabs: tabs,
            ),
          ),
        ),
      ],
    );
  }
}
