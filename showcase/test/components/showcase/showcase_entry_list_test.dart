// Standing tests for the responsive entry grid. Synthetic entries, so the
// catalogue can grow or shrink without touching this file; what is pinned is
// the layout contract, including the current tuning (280 minimum tile,
// 4-column cap) — retuning those constants should update these expectations
// deliberately, not silently.
import 'package:flowin_showcase/components/showcase/showcase_entry.dart';
import 'package:flowin_showcase/components/showcase/showcase_entry_list.dart';
import 'package:flowin_showcase/components/showcase/showcase_entry_tile.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

/// Six entries: one full row of four plus a short row of two at the cap.
final _entries = <ShowcaseEntry>[
  for (final name in ['Alpha', 'Bravo', 'Charlie', 'Delta', 'Echo', 'Foxtrot'])
    ShowcaseEntry(
      title: name,
      subtitle: 'A synthetic entry for the layout contract.',
      icon: FDIcons.board,
      builder: (_) => Scaffold(body: Text('$name destination')),
    ),
];

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: FlowinTheme.light,
      home: Scaffold(body: ShowcaseEntryList(entries: _entries)),
    ),
  );
  await tester.pumpAndSettle();
}

/// How many tiles share the topmost row, by comparing their tops.
int _tilesInFirstRow(WidgetTester tester) {
  final tiles = find.byType(ShowcaseEntryTile).evaluate().toList();
  final firstTop = tester.getTopLeft(find.byWidget(tiles.first.widget)).dy;
  return tiles
      .where(
        (e) =>
            (tester.getTopLeft(find.byWidget(e.widget)).dy - firstTop).abs() <
            1,
      )
      .length;
}

void main() {
  group('column count follows the available width', () {
    final cases = <String, (double, int)>{
      'phone stays a single column': (390, 1),
      'a narrow tablet takes two': (700, 2),
      'a desktop takes four': (1400, 4),
      'ultrawide stays capped at four': (2400, 4),
    };

    for (final MapEntry(key: name, value: expected) in cases.entries) {
      testWidgets(name, (tester) async {
        final (width, columns) = expected;
        await _pumpAt(tester, Size(width, 1400));
        expect(tester.takeException(), isNull);
        expect(_tilesInFirstRow(tester), columns);
      });
    }
  });

  group('rows lay out correctly', () {
    testWidgets('tiles in a row share a top, a height, and a width', (
      tester,
    ) async {
      await _pumpAt(tester, const Size(1400, 1400));

      final tiles = find.byType(ShowcaseEntryTile);
      final first = tester.getRect(tiles.at(0));
      final second = tester.getRect(tiles.at(1));

      expect(first.top, moreOrLessEquals(second.top, epsilon: 0.5));
      expect(
        first.height,
        moreOrLessEquals(second.height, epsilon: 0.5),
        reason: 'IntrinsicHeight must equalise tiles within a row',
      );
      expect(first.width, moreOrLessEquals(second.width, epsilon: 0.5));
      expect(
        first.right,
        lessThanOrEqualTo(second.left + 0.5),
        reason: 'tiles must not overlap',
      );
    });

    testWidgets('a short final row keeps column width', (tester) async {
      // Six entries over four columns leave a final row of two.
      await _pumpAt(tester, const Size(1400, 1400));

      final firstRowTile = tester.getSize(find.byType(ShowcaseEntryTile).at(0));
      final lastTile = tester.getSize(
        find.byType(ShowcaseEntryTile).at(_entries.length - 1),
      );

      expect(
        lastTile.width,
        moreOrLessEquals(firstRowTile.width, epsilon: 0.5),
        reason:
            'the short row must not stretch its tiles across the space the '
            'missing ones left',
      );
    });

    testWidgets('every entry renders exactly once at every width', (
      tester,
    ) async {
      for (final width in [390.0, 700.0, 1400.0]) {
        await _pumpAt(tester, Size(width, 2400));
        expect(
          find.byType(ShowcaseEntryTile),
          findsNWidgets(_entries.length),
          reason: 'width $width dropped or duplicated an entry',
        );
        for (final entry in _entries) {
          expect(find.text(entry.title), findsOneWidget, reason: entry.title);
        }
      }
    });
  });

  testWidgets('tapping a tile routes to its page', (tester) async {
    await _pumpAt(tester, const Size(1400, 1400));

    await tester.tap(find.text('Charlie'));
    await tester.pumpAndSettle();

    expect(find.text('Charlie destination'), findsOneWidget);
    expect(find.byType(ShowcaseEntryList), findsNothing);
  });
}
