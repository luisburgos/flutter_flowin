import 'package:flowin_showcase/catalogue.dart';
import 'package:flowin_showcase/components/showcase/cover_arts/cover_arts.dart';
import 'package:flowin_showcase/main.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every catalogue card carries a cover art', () {
    final entries = [
      ...foundationEntries,
      ...componentEntries,
      ...exampleEntries,
    ];
    for (final entry in entries) {
      expect(
        entry.coverArt,
        isNotNull,
        reason: '${entry.title} is missing a cover art',
      );
    }
  });

  testWidgets('the POC cards render their lowframer cover art', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());

    // Buttons and Chips sit in the viewport on the Components page; Text
    // fields may start below the fold, so scroll it into view.
    expect(find.byType(ButtonsCoverArt), findsOneWidget);
    expect(find.byType(ChipsCoverArt), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byType(TextFieldsCoverArt),
      120,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.byType(TextFieldsCoverArt), findsOneWidget);
  });

  testWidgets('a card with cover art still routes to its page', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());

    await tester.tap(find.byType(ButtonsCoverArt));
    await tester.pumpAndSettle();

    expect(find.byType(FlowinButton), findsWidgets);
  });
}
