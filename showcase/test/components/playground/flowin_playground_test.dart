// Standing tests for the playground shell: the preset/knob round trip, the
// split-versus-stacked layout, and the preview stage's clamp and background.
// Driven with an int config — ints carry the value equality the playground's
// preset detection requires, with none of a demo page's baggage.
import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/playground/preview/flowin_playground_preview.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

/// A playground over an int config, with a knob that increments it.
class _IntPlaygroundHost extends StatefulWidget {
  const _IntPlaygroundHost({this.presets = const [], this.previewMaxWidth});

  final List<FlowinPlaygroundPreset<int>> presets;
  final double? previewMaxWidth;

  @override
  State<_IntPlaygroundHost> createState() => _IntPlaygroundHostState();
}

class _IntPlaygroundHostState extends State<_IntPlaygroundHost> {
  int _config = 1;

  @override
  Widget build(BuildContext context) {
    return FlowinPlayground<int>(
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: widget.presets,
      previewMaxWidth: widget.previewMaxWidth,
      previewBuilder: (context, config) => Text('value:$config'),
      knobsBuilder: (context, config, onChanged) => TextButton(
        onPressed: () => onChanged(config + 1),
        child: const Text('increment'),
      ),
    );
  }
}

const _presets = <FlowinPlaygroundPreset<int>>[
  FlowinPlaygroundPreset(label: 'One', summary: 'the first', config: 1),
  FlowinPlaygroundPreset(label: 'Two', summary: 'the second', config: 2),
];

Future<void> _pumpAt(WidgetTester tester, Size size, Widget child) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: FlowinTheme.light,
      home: Scaffold(body: child),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('presets and knobs drive one config', () {
    testWidgets('picking a preset updates the preview', (tester) async {
      await _pumpAt(
        tester,
        const Size(1400, 900),
        const _IntPlaygroundHost(presets: _presets),
      );
      expect(find.text('value:1'), findsOneWidget);

      await tester.tap(find.text('Two'));
      await tester.pumpAndSettle();
      expect(find.text('value:2'), findsOneWidget);
    });

    testWidgets('the inspector opens on Presets; knobs live under Custom', (
      tester,
    ) async {
      await _pumpAt(
        tester,
        const Size(1400, 900),
        const _IntPlaygroundHost(presets: _presets),
      );

      expect(find.text('increment'), findsNothing);

      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();
      expect(find.text('increment'), findsOneWidget);

      await tester.tap(find.text('increment'));
      await tester.pumpAndSettle();
      expect(find.text('value:2'), findsOneWidget);
    });

    testWidgets('empty presets hide the tabs and show the knobs directly', (
      tester,
    ) async {
      await _pumpAt(
        tester,
        const Size(1400, 900),
        const _IntPlaygroundHost(),
      );

      expect(find.text('Presets'), findsNothing);
      expect(find.text('Custom'), findsNothing);
      expect(
        find.text('increment'),
        findsOneWidget,
        reason: 'with nothing to tab between, the knobs need no tab',
      );
    });
  });

  group('layout follows the width it is given', () {
    testWidgets('wide: the inspector docks beside the preview', (
      tester,
    ) async {
      await _pumpAt(
        tester,
        const Size(1400, 900),
        const _IntPlaygroundHost(presets: _presets),
      );

      final subject = tester.getCenter(find.text('value:1'));
      final tabs = tester.getCenter(find.text('Presets'));

      expect(
        tabs.dx,
        greaterThan(subject.dx),
        reason: 'the inspector docks to the right of the preview',
      );
      expect(
        tabs.dx,
        greaterThan(1400 - 301),
        reason: 'the docked inspector is a fixed 300 wide',
      );
    });

    testWidgets('narrow: the inspector stacks below the preview', (
      tester,
    ) async {
      await _pumpAt(
        tester,
        const Size(600, 900),
        const _IntPlaygroundHost(presets: _presets),
      );

      final subject = tester.getCenter(find.text('value:1'));
      final tabs = tester.getCenter(find.text('Presets'));

      expect(
        tabs.dy,
        greaterThan(subject.dy),
        reason: 'below the split breakpoint the two stack instead',
      );
    });
  });

  group('the preview stage', () {
    testWidgets('clamps the subject to previewMaxWidth', (tester) async {
      await _pumpAt(
        tester,
        const Size(1400, 900),
        // A subject that stretches, clamped well under the pane width.
        const _IntPlaygroundHost(presets: _presets, previewMaxWidth: 300),
      );

      final constrained = tester.widget<ConstrainedBox>(
        find
            .descendant(
              of: find.byType(FlowinPlaygroundPreview),
              matching: find.byType(ConstrainedBox),
            )
            .first,
      );
      expect(
        constrained.constraints.maxWidth,
        300,
        reason:
            'showing a subject wider than any real caller gives it would '
            'misinform the eye the stage exists to inform',
      );
    });

    testWidgets('the stage tint defaults to outlineVariant', (tester) async {
      await _pumpAt(
        tester,
        const Size(1400, 900),
        const _IntPlaygroundHost(presets: _presets),
      );

      final stage = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(FlowinPlaygroundPreview),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final context = tester.element(find.byType(FlowinPlaygroundPreview));
      expect(
        (stage.decoration as BoxDecoration).color,
        Theme.of(context).colorScheme.outlineVariant,
      );
    });

    testWidgets('a passed background overrides the tint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: FlowinTheme.light,
          home: const Scaffold(
            body: FlowinPlaygroundPreview(
              background: Color(0xFF123456),
              child: Text('subject'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final stage = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(FlowinPlaygroundPreview),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(
        (stage.decoration as BoxDecoration).color,
        const Color(0xFF123456),
      );
    });
  });
}
