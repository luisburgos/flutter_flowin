import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

/// Hosts a [TabController] so [FlowinTabs] can be exercised in tests.
class _TabsHarness extends StatefulWidget {
  const _TabsHarness({required this.tabs, this.isScrollable = false});

  final List<Widget> tabs;
  final bool isScrollable;

  @override
  State<_TabsHarness> createState() => _TabsHarnessState();
}

class _TabsHarnessState extends State<_TabsHarness>
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
    return FlowinTabs(
      controller: controller,
      tabs: widget.tabs,
      isScrollable: widget.isScrollable,
    );
  }
}

void main() {
  group('FlowinTabs', () {
    const tabs = [Tab(text: 'One'), Tab(text: 'Two')];

    testWidgets('renders a TabBar with its tabs', (tester) async {
      await tester.pumpApp(const _TabsHarness(tabs: tabs));
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
    });

    testWidgets('exposes a fixed preferred size', (tester) async {
      await tester.pumpApp(const _TabsHarness(tabs: tabs));
      final widget = tester.widget<FlowinTabs>(find.byType(FlowinTabs));
      expect(widget.preferredSize.height, kFlowinTabsHeight);
    });

    testWidgets('forwards isScrollable to the TabBar', (tester) async {
      await tester.pumpApp(
        const _TabsHarness(tabs: tabs, isScrollable: true),
      );
      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.isScrollable, isTrue);
    });

    testWidgets(
      'label style comes from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        const customStyle = TextStyle(fontSize: 21);
        final theme = FlowinTheme.light.copyWith(
          tabBarTheme: FlowinTheme.light.tabBarTheme.copyWith(
            labelStyle: customStyle,
          ),
        );

        await tester.pumpApp(const _TabsHarness(tabs: tabs), theme: theme);

        expect(
          TabBarTheme.of(
            tester.element(find.byType(TabBar)),
          ).labelStyle,
          customStyle,
        );
      },
    );

    testWidgets('renders no stray divider (dividerColor is transparent)', (
      tester,
    ) async {
      await tester.pumpApp(const _TabsHarness(tabs: tabs));

      // The bar relies on the theme to hide the TabBar's built-in divider
      // rather than setting it per-widget; assert the resolved value at the
      // rendered TabBar.
      final resolved = TabBarTheme.of(
        tester.element(find.byType(TabBar)),
      ).dividerColor;
      expect(resolved, Colors.transparent);
    });
  });
}
