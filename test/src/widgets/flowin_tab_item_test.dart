// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FlowinTabItem', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpApp(FlowinTabItem(label: 'Board'));
      expect(find.text('Board'), findsOneWidget);
    });

    testWidgets('renders the icon to the LEFT of the label (same row)', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinTabItem(icon: Icon(Icons.dashboard), label: 'Board'),
      );

      final iconX = tester.getCenter(find.byIcon(Icons.dashboard)).dx;
      final labelX = tester.getCenter(find.text('Board')).dx;
      final iconY = tester.getCenter(find.byIcon(Icons.dashboard)).dy;
      final labelY = tester.getCenter(find.text('Board')).dy;

      // Icon-left: the icon sits to the left of the label...
      expect(iconX, lessThan(labelX));
      // ...and on the same row (not stacked above), so centers share a Y band.
      expect((iconY - labelY).abs(), lessThan(8));
    });

    testWidgets('omits the icon when none is provided', (tester) async {
      await tester.pumpApp(FlowinTabItem(label: 'Timeline'));
      expect(find.byType(Icon), findsNothing);
      expect(find.text('Timeline'), findsOneWidget);
    });

    testWidgets('label is single-line and ellipsized', (tester) async {
      await tester.pumpApp(
        SizedBox(
          width: 60,
          child: FlowinTabItem(
            label: 'A very long tab label that will not fit',
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('label uses the 14/w500 style', (tester) async {
      await tester.pumpApp(FlowinTabItem(label: 'Board'));
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontSize, 14);
      expect(text.style?.fontWeight, FontWeight.w500);
    });

    testWidgets('works as a FlowinTabs tab', (tester) async {
      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpApp(
        FlowinTabs(
          controller: controller,
          tabs: const [
            FlowinTabItem(icon: Icon(Icons.dashboard), label: 'Board'),
            FlowinTabItem(label: 'Timeline'),
          ],
        ),
      );
      expect(find.byType(FlowinTabItem), findsNWidgets(2));
      expect(find.text('Board'), findsOneWidget);
      expect(find.text('Timeline'), findsOneWidget);
    });

    testWidgets('the tappable cell fills the height of the bar', (
      tester,
    ) async {
      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpApp(
        FlowinTabs(
          controller: controller,
          tabs: const [
            FlowinTabItem(label: 'One'),
            FlowinTabItem(label: 'Two'),
          ],
        ),
      );

      // A row sized to its own content left the ink — and so the tap target —
      // only as tall as the label, leaving most of the bar dead to touch.
      // Asserting against the bar's own height rather than a constant keeps
      // this honest if kFlowinTabsHeight changes.
      final barHeight = tester.getSize(find.byType(FlowinTabs)).height;
      final ink = find.descendant(
        of: find.byType(TabBar),
        matching: find.byType(InkWell),
      );

      expect(tester.getSize(ink.first).height, closeTo(barHeight, 0.01));
      expect(tester.getSize(ink.at(1)).height, closeTo(barHeight, 0.01));
    });

    testWidgets('the tap target clears the 48 minimum touch target', (
      tester,
    ) async {
      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpApp(
        FlowinTabs(
          controller: controller,
          tabs: const [
            FlowinTabItem(icon: Icon(Icons.dashboard), label: 'Board'),
            FlowinTabItem(label: 'Timeline'),
          ],
        ),
      );

      final ink = find.descendant(
        of: find.byType(TabBar),
        matching: find.byType(InkWell),
      );
      expect(tester.getSize(ink.first).height, greaterThanOrEqualTo(48));
    });

    testWidgets('renders in a SCROLLABLE bar without throwing', (
      tester,
    ) async {
      // A scrollable TabBar lays its tabs out without a bounded height. An
      // item that stretches into that throws during layout, and no test
      // covered the scrollable variant — so the whole demo page rendered a
      // stack of exceptions while the suite stayed green.
      // Labels drive the controller's length so the two cannot drift: a
      // TabController shorter than its tab list asserts on build.
      const labels = [
        'One',
        'Two',
        'Three',
        'Four',
        'Five',
        'Longer tab',
        'A longer tab label',
        'A much longer tab label',
      ];
      final controller = TabController(length: labels.length, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpApp(
        FlowinTabs(
          controller: controller,
          isScrollable: true,
          tabs: [
            for (final label in labels) FlowinTabItem(label: label),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(FlowinTabItem), findsWidgets);
    });

    testWidgets('the scrollable cell fills the bar height too', (
      tester,
    ) async {
      final controller = TabController(length: 3, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpApp(
        FlowinTabs(
          controller: controller,
          isScrollable: true,
          tabs: const [
            FlowinTabItem(label: 'One'),
            FlowinTabItem(label: 'Two'),
            FlowinTabItem(label: 'Three'),
          ],
        ),
      );

      final barHeight = tester.getSize(find.byType(FlowinTabs)).height;
      final ink = find.descendant(
        of: find.byType(TabBar),
        matching: find.byType(InkWell),
      );
      expect(tester.getSize(ink.first).height, closeTo(barHeight, 0.01));
    });

    testWidgets('a scrollable bar does not indent its first tab', (
      tester,
    ) async {
      // Material 3 defaults a scrollable bar to TabAlignment.startOffset,
      // which indents the first tab by 52 to clear a leading navigation icon.
      // A Flowin bar is page content, so that reads as a stray gap and starts
      // the scrollable variant in a different place from the fixed one.
      final controller = TabController(length: 3, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpApp(
        FlowinTabs(
          controller: controller,
          isScrollable: true,
          tabs: const [
            FlowinTabItem(label: 'One'),
            FlowinTabItem(label: 'Two'),
            FlowinTabItem(label: 'Three'),
          ],
        ),
      );

      final bar = tester.getRect(find.byType(FlowinTabs));
      final first = tester.getRect(find.byType(FlowinTabItem).first);
      final inset = first.left - bar.left;

      // Well clear of Material's 52 offset...
      expect(inset, lessThan(32));
      // ...but not flush against the bar's edge either. A scrollable tab is
      // only as wide as its own label, so with no content inset the first
      // label sits hard against the container it is drawn in.
      expect(
        inset,
        greaterThanOrEqualTo(FlowinDesignSpace.space400),
        reason: 'the row needs the standard content inset to breathe',
      );
    });

    testWidgets('a tap near the bar edge still selects the tab', (
      tester,
    ) async {
      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpApp(
        FlowinTabs(
          controller: controller,
          tabs: const [
            FlowinTabItem(label: 'One'),
            FlowinTabItem(label: 'Two'),
          ],
        ),
      );
      expect(controller.index, 0);

      // Tap the second tab near the TOP of the bar — outside the old
      // label-sized hit box, which is exactly what users were missing.
      final second = tester.getRect(find.byType(FlowinTabItem).at(1));
      await tester.tapAt(Offset(second.center.dx, second.top + 4));
      await tester.pumpAndSettle();

      expect(controller.index, 1);
    });
  });
}
