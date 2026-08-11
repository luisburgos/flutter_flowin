import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

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
