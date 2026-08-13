// Standing tests for the stepped-slider knobs and the spacing scale they
// step along. Shared infrastructure, not a demo — see the note in
// flowin_playground_knobs_test.dart.
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_spacing_knob.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_step_knob.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, [ThemeData? theme]) => MaterialApp(
  theme: theme ?? FlowinTheme.light,
  home: Scaffold(body: child),
);

void main() {
  group('FlowinPlaygroundStepKnob', () {
    testWidgets('detents count intervals, not positions', (tester) async {
      await tester.pumpWidget(
        _host(
          FlowinPlaygroundStepKnob<int>(
            label: 'Steps',
            value: 20,
            values: const [10, 20, 30, 40],
            labelOf: (v) => '$v',
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(
        slider.divisions,
        3,
        reason: 'four positions have three intervals between them',
      );
      expect(slider.max, 3.0);
      expect(slider.value, 1.0, reason: 'the index of 20 in [10,20,30,40]');
    });

    testWidgets('dragging snaps to a step of the scale, never between', (
      tester,
    ) async {
      final picked = <int>[];
      await tester.pumpWidget(
        _host(
          FlowinPlaygroundStepKnob<int>(
            label: 'Steps',
            value: 10,
            values: const [10, 20, 30, 40],
            labelOf: (v) => '$v',
            onChanged: picked.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.byType(Slider), const Offset(600, 0));
      await tester.pumpAndSettle();

      expect(picked, isNotEmpty);
      expect(
        picked.last,
        40,
        reason: 'dragging to the far end picks the last step',
      );
      for (final value in picked) {
        expect(
          [10, 20, 30, 40],
          contains(value),
          reason: 'a stepped knob must never emit a value off the scale',
        );
      }
    });

    testWidgets('shows the readout labelOf renders for the current step', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          FlowinPlaygroundStepKnob<int>(
            label: 'Steps',
            value: 30,
            values: const [10, 20, 30, 40],
            labelOf: (v) => 'step-$v',
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('step-30'), findsOneWidget);
    });

    testWidgets('an irrelevant knob renders nothing', (tester) async {
      await tester.pumpWidget(
        _host(
          FlowinPlaygroundStepKnob<int>(
            label: 'Steps',
            value: 10,
            values: const [10, 20],
            labelOf: (v) => '$v',
            relevantWhen: const FlowinKnobRelevance.when(
              isRelevant: false,
              reason: 'nothing to step',
            ),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsNothing);
      expect(find.text('Steps'), findsNothing);
    });
  });

  group('SpacingStep', () {
    testWidgets('resolves each step from the theme, strictly ascending', (
      tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        _host(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final values = [
        for (final step in SpacingStep.values) step.resolve(ctx),
      ];

      expect(values.first, 0, reason: 'none must be zero');
      // A flat spot would make two slider detents indistinguishable.
      for (var i = 1; i < values.length; i++) {
        expect(
          values[i],
          greaterThan(values[i - 1]),
          reason: '${SpacingStep.values[i].name} must exceed its predecessor',
        );
      }
    });

    testWidgets('resolve follows the theme, not hardcoded pixels', (
      tester,
    ) async {
      // A theme with a moved scale must move the resolved value; a knob that
      // quoted 16 would report the same number either way.
      late BuildContext ctx;
      final base = FlowinTheme.light;
      final moved = base.copyWith(
        extensions: [
          base.extension<FlowinTokens>()!.copyWith(
            spacing: const FlowinSpacing(md: 32),
          ),
        ],
      );

      await tester.pumpWidget(
        _host(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
          moved,
        ),
      );
      expect(SpacingStep.md.resolve(ctx), 32);
    });

    testWidgets('all() is the resolved step on every side', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        _host(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(
        SpacingStep.md.all(ctx),
        EdgeInsets.all(SpacingStep.md.resolve(ctx)),
      );
    });
  });

  group('FlowinPlaygroundSpacingKnob', () {
    testWidgets('reads out the token name beside its resolved pixels', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          FlowinPlaygroundSpacingKnob(
            label: 'Padding',
            value: SpacingStep.md,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Padding'), findsOneWidget);
      expect(
        find.text('md — 16px'),
        findsOneWidget,
        reason:
            'the name alone does not say how big md is, and the number alone '
            'does not say which step a caller would write',
      );
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('the readout follows the theme', (tester) async {
      final base = FlowinTheme.light;
      final moved = base.copyWith(
        extensions: [
          base.extension<FlowinTokens>()!.copyWith(
            spacing: const FlowinSpacing(md: 32),
          ),
        ],
      );

      await tester.pumpWidget(
        _host(
          FlowinPlaygroundSpacingKnob(
            label: 'Padding',
            value: SpacingStep.md,
            onChanged: (_) {},
          ),
          moved,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('md — 32px'), findsOneWidget);
    });

    testWidgets('steps the full scale', (tester) async {
      SpacingStep? picked;
      await tester.pumpWidget(
        _host(
          FlowinPlaygroundSpacingKnob(
            label: 'Padding',
            value: SpacingStep.none,
            onChanged: (v) => picked = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.byType(Slider), const Offset(800, 0));
      await tester.pumpAndSettle();
      expect(picked, SpacingStep.xxl);
    });
  });
}
