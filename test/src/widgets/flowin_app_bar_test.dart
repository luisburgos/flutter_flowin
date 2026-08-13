import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

/// Hosts a [TabController] so [FlowinTabAppBar] can be exercised in tests.
class _TabAppBarHarness extends StatefulWidget {
  const _TabAppBarHarness({
    required this.tabs,
    this.isScrollable = false,
    this.dividerColor,
  });

  final List<Widget> tabs;
  final bool isScrollable;
  final Color? dividerColor;

  @override
  State<_TabAppBarHarness> createState() => _TabAppBarHarnessState();
}

class _TabAppBarHarnessState extends State<_TabAppBarHarness>
    with SingleTickerProviderStateMixin {
  late final TabController controller = TabController(
    length: widget.tabs.length,
    vsync: this,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlowinTabAppBar(
      controller: controller,
      tabs: widget.tabs,
      isScrollable: widget.isScrollable,
      dividerColor: widget.dividerColor,
    );
  }
}

/// A [PreferredSizeWidget] wrapper so [FlowinTabAppBar] (which needs a
/// [TabController], hence State) can be passed to [Scaffold.appBar].
class _TabAppBarHarnessBar extends StatefulWidget
    implements PreferredSizeWidget {
  const _TabAppBarHarnessBar({required this.tabs, this.primary = true});

  final List<Widget> tabs;
  final bool primary;

  @override
  Size get preferredSize => const Size.fromHeight(kFlowinAppBarHeight);

  @override
  State<_TabAppBarHarnessBar> createState() => _TabAppBarHarnessBarState();
}

class _TabAppBarHarnessBarState extends State<_TabAppBarHarnessBar>
    with SingleTickerProviderStateMixin {
  late final TabController controller = TabController(
    length: widget.tabs.length,
    vsync: this,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlowinTabAppBar(
      controller: controller,
      tabs: widget.tabs,
      primary: widget.primary,
    );
  }
}

/// Pumps [bar] in the [Scaffold.appBar] slot under a fake status-bar inset.
Future<void> _pumpInScaffold(
  WidgetTester tester,
  PreferredSizeWidget bar, {
  double topInset = 59,
}) {
  return tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(padding: EdgeInsets.only(top: topInset)),
      child: MaterialApp(
        theme: FlowinTheme.light,
        home: Scaffold(
          appBar: bar,
          body: const SizedBox.expand(key: Key('body')),
        ),
      ),
    ),
  );
}

void main() {
  group('FlowinAppBar safe-area contract', () {
    const inset = 59.0;

    testWidgets('primary insets its content below the status bar', (
      tester,
    ) async {
      await _pumpInScaffold(tester, const FlowinAppBar(child: Text('T')));

      // The content starts below the inset rather than under the status bar.
      expect(tester.getRect(find.text('T')).top, greaterThanOrEqualTo(inset));
    });

    testWidgets('primary: false leaves the content un-inset', (tester) async {
      await _pumpInScaffold(
        tester,
        const FlowinAppBar(primary: false, child: Text('T')),
      );

      expect(tester.getRect(find.text('T')).top, lessThan(inset));
    });

    testWidgets('preferredSize excludes the inset (Scaffold adds it)', (
      tester,
    ) async {
      // Guards against double-counting: Scaffold already adds
      // MediaQuery.padding.top for any PreferredSizeWidget, so the bar must
      // report only its own height.
      const bar = FlowinAppBar(child: Text('T'));
      expect(bar.preferredSize.height, kFlowinAppBarHeight);

      await _pumpInScaffold(tester, bar);

      // The body starts exactly one inset + one bar height down — no gap.
      expect(
        tester.getRect(find.byKey(const Key('body'))).top,
        inset + kFlowinAppBarHeight,
      );
    });

    testWidgets('FlowinTabAppBar forwards primary to the bar', (tester) async {
      await _pumpInScaffold(
        tester,
        const _TabAppBarHarnessBar(tabs: [Text('A'), Text('B')]),
      );
      expect(tester.getRect(find.text('A')).top, greaterThanOrEqualTo(inset));
    });

    testWidgets('FlowinTabAppBar honours primary: false', (tester) async {
      await _pumpInScaffold(
        tester,
        const _TabAppBarHarnessBar(
          tabs: [Text('A'), Text('B')],
          primary: false,
        ),
      );
      expect(tester.getRect(find.text('A')).top, lessThan(inset));
    });
  });

  group('FlowinAppBar', () {
    testWidgets('renders leading, trailing, and child widgets', (tester) async {
      await tester.pumpApp(
        const FlowinAppBar(
          leading: Icon(Icons.menu),
          trailing: Icon(Icons.more_vert),
          child: Text('Title'),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('exposes the default preferred size', (tester) async {
      await tester.pumpApp(const FlowinAppBar(child: Text('Title')));

      final widget = tester.widget<FlowinAppBar>(find.byType(FlowinAppBar));
      expect(widget.preferredSize.height, kFlowinAppBarHeight);
    });

    testWidgets('reflects a custom height in its preferred size', (
      tester,
    ) async {
      const customHeight = 96.0;
      await tester.pumpApp(
        const FlowinAppBar(height: customHeight, child: Text('Title')),
      );

      final widget = tester.widget<FlowinAppBar>(find.byType(FlowinAppBar));
      expect(widget.preferredSize.height, customHeight);
    });

    testWidgets('renders the footer when provided', (tester) async {
      await tester.pumpApp(
        const FlowinAppBar(footer: Divider(), child: Text('Title')),
      );

      expect(find.byType(Divider), findsOneWidget);
    });
  });

  group('FlowinTabAppBar', () {
    const tabs = [Tab(text: 'One'), Tab(text: 'Two'), Tab(text: 'Three')];

    testWidgets('renders its tabs', (tester) async {
      await tester.pumpApp(const _TabAppBarHarness(tabs: tabs));

      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('Three'), findsOneWidget);
    });

    testWidgets('exposes a single-row preferred size', (tester) async {
      await tester.pumpApp(const _TabAppBarHarness(tabs: tabs));

      final widget = tester.widget<FlowinTabAppBar>(
        find.byType(FlowinTabAppBar),
      );
      // Single-row layout (H3): the bar is one ~space1400-tall row, not the
      // bar height stacked on top of a full tabs height.
      expect(widget.preferredSize.height, kFlowinAppBarHeight);
    });

    testWidgets('keeps the whole bar within a single app-bar height', (
      tester,
    ) async {
      await tester.pumpApp(const _TabAppBarHarness(tabs: tabs));

      final size = tester.getSize(find.byType(FlowinAppBar));
      expect(size.height, kFlowinAppBarHeight);
    });

    testWidgets('embeds a FlowinTabs and a TabBar', (tester) async {
      await tester.pumpApp(const _TabAppBarHarness(tabs: tabs));

      expect(find.byType(FlowinTabs), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets('places the tabs in the bar center slot, not below it', (
      tester,
    ) async {
      await tester.pumpApp(const _TabAppBarHarness(tabs: tabs));

      // Single-row: the tabs sit in the content Row (center), so their vertical
      // center is above the footer hairline pinned at the bottom.
      final tabsCenter = tester.getCenter(find.byType(FlowinTabs)).dy;
      final dividerTop = tester.getTopLeft(find.byType(Divider)).dy;
      expect(tabsCenter, lessThan(dividerTop));
    });

    testWidgets('forwards isScrollable to the embedded tabs', (tester) async {
      await tester.pumpApp(
        const _TabAppBarHarness(tabs: tabs, isScrollable: true),
      );

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.isScrollable, isTrue);
    });

    testWidgets('draws a token-pinned hairline divider (borders.regular)', (
      tester,
    ) async {
      await tester.pumpApp(const _TabAppBarHarness(tabs: tabs));

      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.thickness, FlowinDesignBorders.regular);
      expect(divider.height, FlowinDesignBorders.regular);
    });

    testWidgets('applies an explicit dividerColor when provided', (
      tester,
    ) async {
      const color = Color(0xFF112233);
      await tester.pumpApp(
        const _TabAppBarHarness(tabs: tabs, dividerColor: color),
      );

      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.color, color);
    });

    testWidgets(
      'falls back to the global subtle-border role when dividerColor is null',
      (tester) async {
        // Theme-only: override the global divider role and assert the hairline
        // resolves from it rather than a hardcoded value.
        const overridden = Color(0xFFABCDEF);
        final theme = FlowinTheme.light.copyWith(
          dividerTheme: FlowinTheme.light.dividerTheme.copyWith(
            color: overridden,
          ),
        );

        await tester.pumpApp(
          const _TabAppBarHarness(tabs: tabs),
          theme: theme,
        );

        // The widget passes null; the resolved color comes from the theme role.
        final divider = tester.widget<Divider>(find.byType(Divider));
        expect(divider.color, isNull);

        final resolved = DividerTheme.of(
          tester.element(find.byType(Divider)),
        ).color;
        expect(resolved, overridden);
      },
    );
  });
}
