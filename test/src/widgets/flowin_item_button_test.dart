// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FlowinItemButton', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: () {}, label: 'Settings'),
      );
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders a child over a label', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: () {}, child: Text('Custom')),
      );
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        FlowinItemButton(onPressed: () => tapped = true, label: 'Go'),
      );
      await tester.tap(find.byType(FlowinItemButton));
      expect(tapped, isTrue);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: null, label: 'Disabled'),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('default variant is tonal (FilledButton)', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: () {}, label: 'Row'),
      );
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('tonal named constructor renders a FilledButton', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinItemButton.tonal(onPressed: () {}, label: 'Tonal'),
      );
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('Tonal'), findsOneWidget);
    });

    testWidgets('variants map to the right native widget', (tester) async {
      Future<void> expectVariant(
        FlowinItemButton button,
        Type nativeType,
      ) async {
        await tester.pumpApp(button);
        expect(find.byType(nativeType), findsOneWidget);
      }

      await expectVariant(
        FlowinItemButton.filled(onPressed: () {}, label: 'F'),
        FilledButton,
      );
      await expectVariant(
        FlowinItemButton.outline(onPressed: () {}, label: 'O'),
        OutlinedButton,
      );
      await expectVariant(
        FlowinItemButton.text(onPressed: () {}, label: 'T'),
        TextButton,
      );
      await expectVariant(
        FlowinItemButton.destructive(onPressed: () {}, label: 'D'),
        FilledButton,
      );
    });

    testWidgets('stretches to full width', (tester) async {
      await tester.pumpApp(
        SizedBox(
          width: 400,
          child: FlowinItemButton(onPressed: () {}, label: 'Wide'),
        ),
      );
      final size = tester.getSize(find.byType(FilledButton));
      expect(size.width, 400);
    });

    testWidgets('aligns content to the leading (left) edge', (tester) async {
      await tester.pumpApp(
        SizedBox(
          width: 400,
          child: FlowinItemButton(onPressed: () {}, label: 'Lead'),
        ),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.style?.alignment, Alignment.centerLeft);
    });

    testWidgets('uses uniform 16 padding', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: () {}, label: 'Pad'),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(
        button.style?.padding?.resolve({}),
        const EdgeInsets.all(FlowinDesignSpace.space400),
      );
    });

    testWidgets('renders a leading icon before the label', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(
          onPressed: () {},
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      );
      expect(find.byIcon(Icons.settings), findsOneWidget);
      final iconX = tester.getCenter(find.byIcon(Icons.settings)).dx;
      final labelX = tester.getCenter(find.text('Settings')).dx;
      expect(iconX, lessThan(labelX));
    });
  });
}
