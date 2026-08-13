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
    // Unmistakable in painted output, so an indicator assertion cannot match
    // some other line the bar happens to draw.
    const indicatorColor = Color(0xFFFF0000);

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

    testWidgets(
      'indicator size comes from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        // The full-tab indicator is a theme binding, so overriding it has to
        // change what the bar paints. `.label` narrows the indicator to the
        // text and switches the framework to an rrect, while the shipped
        // `.tab` draws a line spanning the whole tab slot — a widget-level
        // indicatorSize would keep painting that line regardless.
        final theme = FlowinTheme.light.copyWith(
          tabBarTheme: FlowinTheme.light.tabBarTheme.copyWith(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: indicatorColor,
          ),
        );

        await tester.pumpApp(const _TabsHarness(tabs: tabs), theme: theme);
        await tester.pumpAndSettle();

        final labelRect = tester.getRect(find.text('One'));
        final tabBarWidth = tester.getSize(find.byType(TabBar)).width;

        expect(
          tester.renderObject(find.byType(TabBar)),
          paints..something((symbol, args) {
            if (symbol != #drawRRect) return false;
            final rrect = args.first as RRect;
            final paint = args.last as Paint;
            if (paint.color != indicatorColor) return false;
            // Hugs the label rather than spanning the tab slot, which for a
            // two-tab bar is half the bar's width.
            return (rrect.left - labelRect.left).abs() < 1 &&
                (rrect.right - labelRect.right).abs() < 1 &&
                rrect.width < tabBarWidth / 2;
          }),
        );
      },
    );

    testWidgets(
      'divider colour comes from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        // The bar hides the TabBar's built-in divider through the theme rather
        // than per-widget. Asserting the shipped transparent default would
        // pass even if the binding were hardcoded, so this overrides it to a
        // visible colour and checks the bar actually paints that line.
        const customDivider = Color(0xFF00FF00);
        final theme = FlowinTheme.light.copyWith(
          tabBarTheme: FlowinTheme.light.tabBarTheme.copyWith(
            dividerColor: customDivider,
          ),
        );

        await tester.pumpApp(const _TabsHarness(tabs: tabs), theme: theme);
        await tester.pumpAndSettle();

        expect(
          tester.renderObject(find.byType(TabBar)),
          paints..line(color: customDivider),
        );
      },
    );

    testWidgets('renders no stray divider (dividerColor is transparent)', (
      tester,
    ) async {
      await tester.pumpApp(const _TabsHarness(tabs: tabs));
      await tester.pumpAndSettle();

      // The shipped default: the divider line is still painted by the
      // framework, but fully transparent so nothing shows.
      expect(
        tester.renderObject(find.byType(TabBar)),
        paints..line(color: Colors.transparent),
      );
    });
  });
}
