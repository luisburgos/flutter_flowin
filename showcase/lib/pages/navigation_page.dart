import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/components/showcase/showcase_section.dart';
import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The index of navigation demos.
///
/// App bars can only be demonstrated as a real [Scaffold.appBar] — rendering
/// one inside a card shows the layout but not the behaviour (status-bar inset,
/// scroll interaction, footer divider against the body). So each bar gets a
/// full page of its own and this page only routes to them.
class NavigationPage extends StatelessWidget {
  /// {@macro navigation_page}
  const NavigationPage({super.key});

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
      (
        'FlowinTabs',
        'The tab bar on its own, fixed and scrollable, as page content.',
        FDIcons.settings,
        (_) => const TabsDemoPage(),
      ),
    ];

    return ShowcaseScaffold.stacked(
      title: 'Navigation',
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

/// A full page whose [Scaffold.appBar] is a plain [FlowinAppBar].
class AppBarDemoPage extends StatelessWidget {
  /// {@macro app_bar_demo_page}
  const AppBarDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlowinAppBar(
        leading: FlowinIconButton.text(
          icon: FDIcons.back.toIcon(),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: const ThemeModeToggle(),
        child: Text('FlowinAppBar', style: context.textTheme.titleMedium),
      ),
      body: ListView(
        padding: EdgeInsets.all(context.spacing.md),
        children: [
          Text(
            'The bar above is the real thing, not a preview: it owns its '
            'status-bar inset and sits in Scaffold.appBar.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.spacing.lg),
          Text('Slots', style: context.textTheme.titleMedium),
          SizedBox(height: context.spacing.sm),
          Text(
            'Leading holds the back button, trailing the theme toggle, and '
            'the centre child expands to fill the space between them.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// A full page whose [Scaffold.appBar] is a [FlowinTabAppBar] driving a
/// [TabBarView].
class TabAppBarDemoPage extends StatefulWidget {
  /// {@macro tab_app_bar_demo_page}
  const TabAppBarDemoPage({super.key});

  @override
  State<TabAppBarDemoPage> createState() => _TabAppBarDemoPageState();
}

class _TabAppBarDemoPageState extends State<TabAppBarDemoPage>
    with TickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  static const List<(String, FDIcons)> _sections = [
    ('Board', FDIcons.board),
    ('Timeline', FDIcons.timeline),
    ('Settings', FDIcons.settings),
  ];

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlowinTabAppBar(
        controller: _tabs,
        leading: FlowinIconButton.text(
          icon: FDIcons.back.toIcon(),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: const ThemeModeToggle(),
        tabs: [
          for (final section in _sections)
            FlowinTabItem(label: section.$1, icon: section.$2.toIcon()),
        ],
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [_BoardTab(), _TimelineTab(), _SettingsTab()],
      ),
    );
  }
}

/// A full page demonstrating [FlowinTabs] as page content rather than as part
/// of an app bar.
class TabsDemoPage extends StatefulWidget {
  /// {@macro tabs_demo_page}
  const TabsDemoPage({super.key});

  @override
  State<TabsDemoPage> createState() => _TabsDemoPageState();
}

class _TabsDemoPageState extends State<TabsDemoPage>
    with TickerProviderStateMixin {
  late final TabController _fixed = TabController(length: 3, vsync: this);

  /// The labels for the scrollable demo, driving the bar, the pages, and the
  /// controller's length together.
  ///
  /// Kept as one list because a TabController whose length disagrees with the
  /// number of tabs silently drops the extras — the surplus tabs render but
  /// have no page behind them.
  static const _scrollableLabels = [
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'A much longer tab label',
  ];

  late final TabController _scrollable = TabController(
    length: _scrollableLabels.length,
    vsync: this,
  );

  @override
  void dispose() {
    _fixed.dispose();
    _scrollable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold.paged(
      title: 'FlowinTabs',
      sections: [
        ShowcaseSection(
          chipLabel: 'Fixed',
          title: 'FlowinTabs — fixed',
          description:
              'Tabs divide the available width equally. Icon-and-label tabs '
              'rely on the tightened label padding to avoid ellipsizing.',
          children: [
            FlowinCard(
              clipChild: true,
              child: Column(
                children: [
                  FlowinTabs(
                    controller: _fixed,
                    tabs: [
                      for (final section in const [
                        ('Board', FDIcons.board),
                        ('Timeline', FDIcons.timeline),
                        ('Settings', FDIcons.settings),
                      ])
                        FlowinTabItem(
                          label: section.$1,
                          icon: section.$2.toIcon(),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 120,
                    child: TabBarView(
                      controller: _fixed,
                      children: [
                        for (final label in ['Board', 'Timeline', 'Settings'])
                          Center(
                            child: Text(
                              '$label content',
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Scrollable',
          title: 'FlowinTabs — scrollable',
          description:
              'Each tab takes its natural width and the row scrolls, so long '
              'labels stay readable.',
          children: [
            FlowinCard(
              clipChild: true,
              child: Column(
                children: [
                  FlowinTabs(
                    controller: _scrollable,
                    isScrollable: true,
                    tabs: [
                      for (final label in _scrollableLabels)
                        FlowinTabItem(label: label),
                    ],
                  ),
                  SizedBox(
                    height: 120,
                    child: TabBarView(
                      controller: _scrollable,
                      children: [
                        for (final label in _scrollableLabels)
                          Center(
                            child: Text(
                              '$label content',
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BoardTab extends StatelessWidget {
  const _BoardTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(context.spacing.md),
      children: [
        Text('FlowinTabAppBar', style: context.textTheme.titleMedium),
        SizedBox(height: context.spacing.xxs),
        Text(
          'The bar above is a single-row tab app bar with a leading back '
          'button, a trailing action, and a hairline footer divider. Swiping '
          'this body moves the tabs with it.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _TimelineTab extends StatelessWidget {
  const _TimelineTab();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(context.spacing.md),
      itemCount: 6,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(vertical: context.spacing.xs),
        child: Row(
          spacing: FlowinDesignSpace.space300,
          children: [
            FDIcons.timer.toIcon(size: FlowinDesignIconSize.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event ${index + 1}',
                    style: context.textTheme.titleSmall,
                  ),
                  Text(
                    'Something happened at step ${index + 1}.',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(context.spacing.md),
      children: [
        FlowinItemButton.tonal(
          icon: FDIcons.paint.toIcon(),
          onPressed: () {},
          label: 'Appearance',
        ),
        SizedBox(height: context.spacing.xs),
        FlowinItemButton.tonal(
          icon: FDIcons.share.toIcon(),
          onPressed: () {},
          label: 'Sharing',
        ),
        SizedBox(height: context.spacing.xs),
        FlowinItemButton.destructive(
          icon: FDIcons.trash.toIcon(),
          onPressed: () {},
          label: 'Delete workspace',
        ),
      ],
    );
  }
}
