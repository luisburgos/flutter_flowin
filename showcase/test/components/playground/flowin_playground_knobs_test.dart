// Standing tests for the knob primitives.
//
// The showcase's demo pages are deliberately not test-driven (see
// catalogue_coverage_test.dart), but these are not demos: they are shared
// infrastructure every playground builds on, and a regression here breaks
// every page at once. Synthetic content throughout, so demo pages can evolve
// without touching this file.
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MaterialApp(
  theme: FlowinTheme.light,
  home: Scaffold(body: child),
);

void main() {
  group('FlowinKnobRelevance', () {
    test('always() is relevant and carries no reason', () {
      const relevance = FlowinKnobRelevance.always();
      expect(relevance.isRelevant, isTrue);
      expect(relevance.reason, isEmpty);
    });

    test('when() carries the verdict and the reason together', () {
      const relevance = FlowinKnobRelevance.when(
        isRelevant: false,
        reason: 'the subject exposes no such option',
      );
      expect(relevance.isRelevant, isFalse);
      expect(relevance.reason, isNotEmpty);
    });
  });

  group('FlowinPlaygroundKnobGroup', () {
    testWidgets('renders its heading in caps above its children', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const FlowinPlaygroundKnobGroup(
            title: 'Shape',
            children: [Text('inner knob')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('SHAPE'), findsOneWidget);
      expect(find.text('inner knob'), findsOneWidget);
    });

    testWidgets('an irrelevant group renders nothing at all', (tester) async {
      await tester.pumpWidget(
        _host(
          const FlowinPlaygroundKnobGroup(
            title: 'Shape',
            relevantWhen: FlowinKnobRelevance.when(
              isRelevant: false,
              reason: 'nothing to shape',
            ),
            children: [Text('inner knob')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('SHAPE'), findsNothing);
      expect(
        find.text('inner knob'),
        findsNothing,
        reason: 'hiding a group must hide its children too',
      );
    });
  });

  group('FlowinPlaygroundSwitchKnob', () {
    testWidgets('renders a switch beside its label and reports toggles', (
      tester,
    ) async {
      bool? received;
      await tester.pumpWidget(
        _host(
          FlowinPlaygroundSwitchKnob(
            label: 'Bordered',
            value: false,
            onChanged: (v) => received = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bordered'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(received, isTrue);
    });

    testWidgets('relevant by default', (tester) async {
      await tester.pumpWidget(
        _host(
          FlowinPlaygroundSwitchKnob(
            label: 'Bordered',
            value: false,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('an irrelevant knob renders nothing', (tester) async {
      await tester.pumpWidget(
        _host(
          FlowinPlaygroundSwitchKnob(
            label: 'Bordered',
            value: true,
            relevantWhen: const FlowinKnobRelevance.when(
              isRelevant: false,
              reason: 'nothing to border',
            ),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bordered'), findsNothing);
      expect(find.byType(Switch), findsNothing);
    });
  });
}
