import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/navigation/app_bar_demos.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The index of app-bar demos.
///
/// Deliberately not a playground. An app bar can only be demonstrated as a
/// real [Scaffold.appBar]: its contract is the status-bar inset it owns, the
/// footer divider it draws against a body, and — for the tab bar — the body
/// swipe that moves the tabs with it. A preview stage shows none of that, so
/// each bar gets a full page of its own and this page only routes to them.
///
/// [FlowinTabs] is the opposite case and lives on its own page: it is content
/// a caller places in a body rather than chrome, so it does fit a playground.
class AppBarsPage extends StatelessWidget {
  /// {@macro app_bars_page}
  const AppBarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final demos = <(String, String, FDIcons, WidgetBuilder)>[
      (
        'FlowinAppBar',
        'Leading, centre and trailing slots in a real app bar.',
        FDIcons.board,
        (_) => const AppBarDemoPage(),
      ),
      (
        'FlowinTabAppBar',
        'A single-row bar whose centre slot holds the tabs.',
        FDIcons.timeline,
        (_) => const TabAppBarDemoPage(),
      ),
    ];

    return ShowcaseScaffold.stacked(
      title: 'App bars',
      children: [
        for (final (title, subtitle, icon, builder) in demos)
          Padding(
            padding: EdgeInsets.only(bottom: context.spacing.xs),
            child: FlowinItemButton.tonal(
              icon: icon.toIcon(),
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute<void>(builder: builder)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.titleSmall),
                  Text(
                    subtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
