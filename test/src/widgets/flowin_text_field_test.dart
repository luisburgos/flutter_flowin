// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter/services.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FlowinTextField', () {
    testWidgets('renders an editable field', (tester) async {
      await tester.pumpApp(FlowinTextField());
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('shows the hint text', (tester) async {
      await tester.pumpApp(FlowinTextField(hintText: 'Your name'));
      expect(find.text('Your name'), findsOneWidget);
    });

    testWidgets('fires onChanged as the user types', (tester) async {
      String? value;
      await tester.pumpApp(
        FlowinTextField(onChanged: (v) => value = v),
      );
      await tester.enterText(find.byType(TextFormField), 'hello');
      expect(value, 'hello');
    });

    testWidgets('applies input formatters', (tester) async {
      await tester.pumpApp(
        FlowinTextField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      );
      await tester.enterText(find.byType(TextFormField), 'a1b2');
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('is not editable when disabled', (tester) async {
      await tester.pumpApp(
        FlowinTextField(initialValue: 'read only', enabled: false),
      );
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
    });

    testWidgets('keeps the subtle-border role when disabled', (tester) async {
      // The contract binds the border colour for the disabled state and says
      // it is unchanged in v1. Without an explicit disabled border the field
      // falls through to the platform's own disabled tint, which is not one
      // of our roles — and asserting only `enabled == false`, as the test
      // above does, cannot see that.
      await tester.pumpApp(
        FlowinTextField(initialValue: 'read only', enabled: false),
      );

      final context = tester.element(find.byType(TextField));
      final border = tester
          .widget<TextField>(find.byType(TextField))
          .decoration!
          .disabledBorder!;

      expect(
        border.borderSide.color,
        Theme.of(context).colorScheme.outlineVariant,
      );
    });

    testWidgets(
      'border radius comes from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        const customRadius = 2.0;
        final theme = FlowinTheme.light.copyWith(
          inputDecorationTheme: FlowinTheme.light.inputDecorationTheme.copyWith(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(customRadius),
            ),
          ),
        );

        await tester.pumpApp(FlowinTextField(), theme: theme);

        expect(
          Theme.of(
            tester.element(find.byType(TextFormField)),
          ).inputDecorationTheme.border,
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(customRadius),
          ),
        );
      },
    );
  });
}
