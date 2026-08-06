import 'package:flowin_showcase/main.dart';
import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the Components tab lists every component page', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());

    expect(find.text('Components'), findsOneWidget);
    expect(find.text('Examples'), findsOneWidget);
    for (final entry in componentEntries) {
      expect(find.text(entry.title), findsOneWidget);
    }
  });

  testWidgets('the Examples tab lists every example page', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());

    await tester.tap(find.text('Examples'));
    await tester.pumpAndSettle();

    for (final entry in exampleEntries) {
      expect(find.text(entry.title), findsOneWidget);
    }
  });

  testWidgets('the theme toggle is reachable from a nested page', (
    tester,
  ) async {
    await tester.pumpWidget(const ShowcaseApp());
    await tester.tap(find.text('Buttons'));
    await tester.pumpAndSettle();

    expect(find.byType(ThemeModeToggle), findsOneWidget);
  });

  testWidgets('toggling from a nested page switches the app theme', (
    tester,
  ) async {
    await tester.pumpWidget(const ShowcaseApp());
    await tester.tap(find.text('Buttons'));
    await tester.pumpAndSettle();

    Brightness brightnessOf(WidgetTester t) => Theme.of(
      t.element(find.byType(ThemeModeToggle)),
    ).brightness;

    expect(brightnessOf(tester), Brightness.light);

    await tester.tap(find.byType(ThemeModeToggle));
    await tester.pumpAndSettle();

    expect(brightnessOf(tester), Brightness.dark);
  });

  testWidgets('the mode set on a nested page persists back on the index', (
    tester,
  ) async {
    await tester.pumpWidget(const ShowcaseApp());
    await tester.tap(find.text('Buttons'));
    await tester.pumpAndSettle();

    // Flip to dark from the nested page, then pop back to the index.
    // `pageBack()` hunts for a Material/Cupertino back button; the showcase
    // uses a FlowinIconButton, so pop through the navigator directly.
    await tester.tap(find.byType(ThemeModeToggle));
    await tester.pumpAndSettle();
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();

    // One shared source of truth: the index reflects the nested page's change.
    expect(
      Theme.of(tester.element(find.text('Components'))).brightness,
      Brightness.dark,
    );
  });
}
