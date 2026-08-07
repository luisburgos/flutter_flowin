// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

List<FlowinChipGroupViewPage> _pages() => [
  FlowinChipGroupViewPage.child(
    label: 'Board',
    child: Center(child: Text('Page 1')),
  ),
  FlowinChipGroupViewPage.child(
    label: 'Timeline',
    child: Center(child: Text('Page 2')),
  ),
  FlowinChipGroupViewPage.child(
    label: 'Settings',
    child: Center(child: Text('Page 3')),
  ),
];

Widget _sized(Widget child) => SizedBox(height: 320, child: child);

void main() {
  group('FlowinChipGroupViewPager', () {
    testWidgets('renders a chip per label and a PageView', (tester) async {
      await tester.pumpApp(
        _sized(FlowinChipGroupViewPager(items: _pages())),
      );

      expect(find.byType(ChoiceChip), findsNWidgets(3));
      expect(find.byType(PageView), findsOneWidget);
      expect(find.text('Board'), findsOneWidget);
      expect(find.text('Timeline'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('tapping a chip changes the page and reports its index', (
      tester,
    ) async {
      int? changedIndex;
      await tester.pumpApp(
        _sized(
          FlowinChipGroupViewPager(
            items: _pages(),
            onIndexChanged: (index) => changedIndex = index,
          ),
        ),
      );

      await tester.tap(find.text('Timeline'));
      await tester.pumpAndSettle();

      expect(changedIndex, 1);
      expect(find.text('Page 2'), findsOneWidget);
    });
  });

  group('FlowinChipGroupViewPager controlled mode (#15)', () {
    testWidgets('external chipGroupController drives selection', (
      tester,
    ) async {
      final chipController = FlowinChipGroupController();
      addTearDown(chipController.dispose);
      final pageController = PageController();
      addTearDown(pageController.dispose);

      await tester.pumpApp(
        _sized(
          FlowinChipGroupViewPager(
            items: _pages(),
            chipGroupController: chipController,
            pageController: pageController,
          ),
        ),
      );

      // A tap routes through the external chip controller.
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(chipController.index, 2);
      expect(find.text('Page 3'), findsOneWidget);
    });

    testWidgets('does not dispose caller-owned controllers', (tester) async {
      final chipController = FlowinChipGroupController();
      addTearDown(chipController.dispose);
      final pageController = PageController();
      addTearDown(pageController.dispose);

      await tester.pumpApp(
        _sized(
          FlowinChipGroupViewPager(
            items: _pages(),
            chipGroupController: chipController,
            pageController: pageController,
          ),
        ),
      );

      // Replace the pager with an empty box → its State.dispose runs.
      await tester.pumpApp(_sized(const SizedBox.shrink()));
      await tester.pump();

      // If the component had disposed them, using them now would throw.
      expect(() => chipController.index = 1, returnsNormally);
      expect(pageController.hasClients, isFalse);
    });

    testWidgets('forwards chipBuilder to the chip row', (tester) async {
      await tester.pumpApp(
        _sized(
          FlowinChipGroupViewPager(
            items: _pages(),
            chipBuilder: (index, label, isSelected, onSelected) => FlowinChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [const Icon(Icons.tag), Text(label)],
              ),
              variant: isSelected
                  ? FlowinChipVariant.selected
                  : FlowinChipVariant.unselected,
              onSelected: onSelected,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.tag), findsNWidgets(3));
    });

    testWidgets(
      'the wrapped chip row spans the pager width, so leading alignment is '
      'visible (a Wrap sizes to its widest line; a centring column would hide '
      'it)',
      (tester) async {
        await tester.pumpApp(
          SizedBox(
            width: 500,
            height: 320,
            child: FlowinChipGroupViewPager(
              items: _pages(),
              isScrollable: false,
            ),
          ),
        );

        // Full width minus the chip row's own horizontal padding.
        expect(tester.getSize(find.byType(Wrap)).width, 500 - 12 * 2);
      },
    );

    testWidgets('forwards wrap run spacing and alignment to the chip row', (
      tester,
    ) async {
      await tester.pumpApp(
        _sized(
          FlowinChipGroupViewPager(
            items: _pages(),
            isScrollable: false,
            chipRunSpacing: 24,
            chipWrapAlignment: WrapAlignment.center,
          ),
        ),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.runSpacing, 24);
      expect(wrap.alignment, WrapAlignment.center);
    });
  });

  group('FlowinChipGroupViewPage', () {
    testWidgets('child factory builds a page with the given child', (
      tester,
    ) async {
      final page = FlowinChipGroupViewPage.child(
        label: 'Board',
        child: Text('Body'),
      );

      expect(page.label, 'Board');
      await tester.pumpApp(Builder(builder: page.builder));
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('one physics governs both scrollers', (tester) async {
      // The chip row and the page view sit one above the other and scroll the
      // same axis. Before this, the row welded in bouncing physics with no
      // parameter, so a caller could clamp the pages and still get a bouncing
      // row — two horizontal scrollers with different feel on one screen.
      const physics = ClampingScrollPhysics();

      await tester.pumpApp(
        _sized(
          FlowinChipGroupViewPager(pagePhysics: physics, items: _pages()),
        ),
      );

      final scrollables = tester
          .widgetList<Scrollable>(find.byType(Scrollable))
          .toList();

      expect(
        scrollables.length,
        greaterThanOrEqualTo(2),
        reason: 'expected both the chip row and the page view',
      );
      // A PageView wraps whatever it is given (page snapping, implicit
      // scrolling), so the outer type is not the one supplied — the supplied
      // physics sits inside the chain. Matching the description covers both
      // the wrapped and the bare case.
      for (final scrollable in scrollables) {
        expect(
          scrollable.physics.toString(),
          contains('ClampingScrollPhysics'),
          reason: 'a scroller did not take the forwarded physics',
        );
      }
    });
  });

  group('FlowinChipGroup physics', () {
    testWidgets('defaults to bouncing', (tester) async {
      // Bouncing is a deliberate choice, not the platform default: a short
      // chip strip that stops dead at the edge reads as broken. Pinned so the
      // default cannot drift silently.
      await tester.pumpApp(
        FlowinChipGroup(labels: const ['One', 'Two']),
      );

      final scrollable = tester.widget<Scrollable>(find.byType(Scrollable));
      expect(scrollable.physics, isA<BouncingScrollPhysics>());
    });

    testWidgets('accepts a caller override', (tester) async {
      await tester.pumpApp(
        FlowinChipGroup(
          labels: const ['One', 'Two'],
          physics: const ClampingScrollPhysics(),
        ),
      );

      final scrollable = tester.widget<Scrollable>(find.byType(Scrollable));
      expect(scrollable.physics, isA<ClampingScrollPhysics>());
    });
  });
}
