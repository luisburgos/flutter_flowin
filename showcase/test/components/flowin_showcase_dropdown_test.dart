// Standing tests for the shared dropdown scaffolding.
import 'package:flowin_showcase/components/flowin_showcase_dropdown.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MaterialApp(
  theme: FlowinTheme.light,
  home: Scaffold(body: child),
);

void main() {
  group('FlowinShowcaseDropdown', () {
    testWidgets('shows the selected choice and reports a pick', (
      tester,
    ) async {
      String? picked;
      await tester.pumpWidget(
        _host(
          FlowinShowcaseDropdown<String>(
            value: 'alpha',
            values: const ['alpha', 'bravo'],
            labelOf: (v) => 'label-$v',
            onChanged: (v) => picked = v,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('label-alpha'), findsOneWidget);

      await tester.tap(find.text('label-alpha'));
      await tester.pumpAndSettle();
      // The open menu renders its own copies; the last is the menu item.
      await tester.tap(find.text('label-bravo').last);
      await tester.pumpAndSettle();

      expect(picked, 'bravo');
    });

    testWidgets('an irrelevant dropdown renders nothing', (tester) async {
      await tester.pumpWidget(
        _host(
          FlowinShowcaseDropdown<String>(
            value: 'alpha',
            values: const ['alpha', 'bravo'],
            labelOf: (v) => 'label-$v',
            relevantWhen: const FlowinKnobRelevance.when(
              isRelevant: false,
              reason: 'nothing to choose',
            ),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(DropdownButton<String>), findsNothing);
    });
  });
}
