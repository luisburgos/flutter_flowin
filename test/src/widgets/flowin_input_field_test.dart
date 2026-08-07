// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fidelity/oracle_fixtures.dart';
import '../../helpers/helpers.dart';

/// The style the framework actually paints [text] with.
///
/// Reading the style off the [Text] widget would only echo what the widget was
/// handed; the span inside [RichText] is the merged, post-theme result, which
/// is the only thing that proves a theme value survived to the screen.
TextStyle _renderedStyleOf(WidgetTester tester, String text) {
  final richText = tester.widget<RichText>(
    find.descendant(of: find.text(text), matching: find.byType(RichText)),
  );
  return richText.text.style!;
}

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

    testWidgets(
      'label text style comes from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        // The label binds to two global roles: labelMedium for the type and
        // onSurface for the colour. Override both and assert the rendered
        // label follows, proving the field composes the roles rather than
        // spelling a size or a colour of its own.
        const customFontSize = 29.0;
        const customLabelColor = Color(0xFF00FF7F);
        final theme = FlowinTheme.light.copyWith(
          textTheme: FlowinTheme.light.textTheme.copyWith(
            labelMedium: FlowinTheme.light.textTheme.labelMedium?.copyWith(
              fontSize: customFontSize,
            ),
          ),
          colorScheme: FlowinTheme.light.colorScheme.copyWith(
            onSurface: customLabelColor,
          ),
        );

        await tester.pumpApp(
          FlowinInputField(label: 'Name', child: Text('x')),
          theme: theme,
        );

        final style = _renderedStyleOf(tester, 'Name');
        expect(style.fontSize, customFontSize);
        expect(style.color, customLabelColor);
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

  group('FlowinInputField dimensional contract', () {
    // The spec fixes four measures for this component: the label gap, the
    // surface minimum height, the content row height, and the inner padding.
    // The widget's own constants are pinned to the spec in the fidelity suite;
    // these tests pin the RENDERED geometry, which is what a consumer sees.
    // Together they catch the two ways the contract can rot: a constant edited
    // to a new value, and a constant left intact but no longer reaching the
    // layout.

    /// Pumps the field at a fixed width so measurements are deterministic.
    ///
    /// A plain [Text] child rather than a text field: an editable brings its
    /// own intrinsic height and would mask the surface's own sizing.
    Future<void> pumpField(WidgetTester tester) => tester.pumpApp(
      SizedBox(
        width: 300,
        child: FlowinInputField(label: 'Name', child: Text('x')),
      ),
    );

    testWidgets('leaves the spec gap between the label and the surface', (
      tester,
    ) async {
      await pumpField(tester);

      final labelBottom = tester.getRect(find.text('Name')).bottom;
      final surfaceTop = tester.getRect(find.byType(FlowinCard)).top;
      expect(surfaceTop - labelBottom, specInputFieldLabelGap);
    });

    testWidgets('renders the surface at the spec minimum height', (
      tester,
    ) async {
      await pumpField(tester);

      expect(
        tester.getSize(find.byType(FlowinCard)).height,
        specInputFieldSurfaceMinHeight,
      );
    });

    testWidgets('caps the content row at the spec height', (tester) async {
      await pumpField(tester);

      // The surface constrains its content to a fixed row height; a taller
      // child must not grow the field.
      final contentRow = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(FlowinCard),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(contentRow.height, specInputFieldContentRowHeight);
    });

    testWidgets('pads the surface by the spec inner padding', (tester) async {
      await pumpField(tester);

      final card = tester.widget<FlowinCard>(find.byType(FlowinCard));
      expect(card.padding, specInputFieldInnerPadding);
    });
  });
}
