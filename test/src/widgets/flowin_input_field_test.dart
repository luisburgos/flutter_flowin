// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FlowinInputField', () {
    testWidgets('renders the label text and the child', (tester) async {
      await tester.pumpApp(
        FlowinInputField(
          label: 'Name',
          child: FlowinTextField(hintText: 'Enter your name'),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.byType(FlowinTextField), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);
    });

    testWidgets('stacks the label ABOVE the child', (tester) async {
      await tester.pumpApp(
        FlowinInputField(label: 'Name', child: FlowinTextField()),
      );

      final labelBottom = tester.getRect(find.text('Name')).bottom;
      final childTop = tester.getRect(find.byType(FlowinTextField)).top;
      expect(childTop, greaterThanOrEqualTo(labelBottom));
    });

    testWidgets('renders only the child when the label is null', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinInputField(child: FlowinTextField(hintText: 'Bare')),
      );

      expect(find.byType(FlowinTextField), findsOneWidget);
      expect(find.text('Bare'), findsOneWidget);
      // No label means no Column wrapper around the surface.
      expect(
        find.descendant(
          of: find.byType(FlowinInputField),
          matching: find.byType(Column),
        ),
        findsNothing,
      );
    });

    testWidgets('wraps the child in a surface by default', (tester) async {
      await tester.pumpApp(
        FlowinInputField(label: 'Name', child: FlowinTextField()),
      );

      expect(find.byType(FlowinCard), findsOneWidget);
    });

    testWidgets(
      'surface: false omits the surface, for children that draw their own',
      (tester) async {
        await tester.pumpApp(
          FlowinInputField(
            label: 'Name',
            surface: false,
            child: FlowinTextField(),
          ),
        );

        // The label still renders; only the shell surface is gone.
        expect(find.text('Name'), findsOneWidget);
        expect(find.byType(FlowinCard), findsNothing);
      },
    );

    testWidgets(
      'border color comes from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        // The shell chrome binds to the global subtle-border role
        // (spec input-field.md: borderSubtle → Flutter outlineVariant).
        // Override the role alone and assert the rendered border follows it,
        // proving the binding is theme-overridable, not hardcoded.
        const customBorder = Color(0xFF445566);
        final theme = FlowinTheme.light.copyWith(
          colorScheme: FlowinTheme.light.colorScheme.copyWith(
            outlineVariant: customBorder,
          ),
        );

        await tester.pumpApp(
          FlowinInputField(label: 'Name', child: FlowinTextField()),
          theme: theme,
        );

        final card = tester.widget<FlowinCard>(find.byType(FlowinCard));
        expect(card.borderSide.color, customBorder);
      },
    );

    testWidgets('label truncates rather than wrapping', (tester) async {
      await tester.pumpApp(
        FlowinInputField(
          label: 'A very long label that will not fit on one line at all',
          child: FlowinTextField(),
        ),
      );

      final label = tester.widget<Text>(find.textContaining('A very long'));
      expect(label.overflow, TextOverflow.ellipsis);
    });
  });
}
