// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FlowinLabeledTextField', () {
    testWidgets('renders the label and the field', (tester) async {
      await tester.pumpApp(
        FlowinLabeledTextField(label: 'Email', hintText: 'you@example.com'),
      );
      expect(find.text('Email'), findsOneWidget);
      expect(find.byType(FlowinTextField), findsOneWidget);
    });

    testWidgets('renders the label ABOVE the field (stacked)', (tester) async {
      await tester.pumpApp(
        FlowinLabeledTextField(label: 'Email'),
      );

      final labelY = tester.getCenter(find.text('Email')).dy;
      final fieldY = tester.getCenter(find.byType(FlowinTextField)).dy;
      expect(labelY, lessThan(fieldY)); // label is above
    });

    testWidgets('renders no label row when label is null', (tester) async {
      await tester.pumpApp(
        FlowinLabeledTextField(hintText: 'no label'),
      );
      // Degenerates to a plain field: no Column wrapper introduced.
      expect(
        find.descendant(
          of: find.byType(FlowinLabeledTextField),
          matching: find.byType(Column),
        ),
        findsNothing,
      );
      expect(find.byType(FlowinTextField), findsOneWidget);
    });

    testWidgets('forwards onChanged to the field', (tester) async {
      String? changed;
      await tester.pumpApp(
        FlowinLabeledTextField(
          label: 'Name',
          onChanged: (value) => changed = value,
        ),
      );
      await tester.enterText(find.byType(FlowinTextField), 'Ada');
      expect(changed, 'Ada');
    });

    testWidgets('forwards enabled=false to the field', (tester) async {
      await tester.pumpApp(
        FlowinLabeledTextField(label: 'Locked', enabled: false),
      );
      final field = tester.widget<FlowinTextField>(
        find.byType(FlowinTextField),
      );
      expect(field.enabled, isFalse);
    });

    testWidgets('label uses the labelMedium text style', (tester) async {
      await tester.pumpApp(FlowinLabeledTextField(label: 'Email'));
      final text = tester.widget<Text>(find.text('Email'));
      final expected = FlowinTheme.light.textTheme.labelMedium;
      expect(text.style?.fontSize, expected?.fontSize);
    });
  });
}
