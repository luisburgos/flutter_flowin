import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

const _labels = ['Board', 'Timeline', 'Settings', 'Members'];

/// The [ShapeDecoration] painted by the chip carrying [label] inside the group.
///
/// Reading `ChipTheme.of(context)` back would pass even if the group stopped
/// deferring to the theme, so these assertions go to the [Ink] the chip
/// actually paints.
ShapeDecoration _paintedDecorationOf(WidgetTester tester, String label) {
  final ink = tester.widget<Ink>(
    find.descendant(
      of: find.ancestor(
        of: find.text(label),
        matching: find.byType(ChoiceChip),
      ),
      matching: find.byType(Ink),
    ),
  );
  return ink.decoration! as ShapeDecoration;
}

Color? _paintedFillOf(WidgetTester tester, String label) =>
    _paintedDecorationOf(tester, label).color;

OutlinedBorder _paintedShapeOf(WidgetTester tester, String label) =>
    _paintedDecorationOf(tester, label).shape as OutlinedBorder;

/// The [TextStyle] the chip's label paragraph is actually rendered with.
TextStyle _renderedLabelStyle(WidgetTester tester, String label) {
  return tester
      .widget<RichText>(
        find.descendant(of: find.text(label), matching: find.byType(RichText)),
      )
      .text
      .style!;
}

/// Hosts a [FlowinChipGroupController] so the group can be driven in tests.
class _ChipGroupHarness extends StatefulWidget {
  const _ChipGroupHarness({required this.controller});

  final FlowinChipGroupController controller;

  @override
  State<_ChipGroupHarness> createState() => _ChipGroupHarnessState();
}

class _ChipGroupHarnessState extends State<_ChipGroupHarness> {
  @override
  Widget build(BuildContext context) {
    return FlowinChipGroup(labels: _labels, controller: widget.controller);
  }
}

/// Hosts a [FlowinChipGroup] whose `labels` and `controller` can be swapped at
/// runtime to exercise [FlowinChipGroup]'s `didUpdateWidget` branches.
class _ReconfigurableHarness extends StatefulWidget {
  const _ReconfigurableHarness({required this.notifier});

  final ValueNotifier<_ChipGroupConfig> notifier;

  @override
  State<_ReconfigurableHarness> createState() => _ReconfigurableHarnessState();
}

class _ChipGroupConfig {
  const _ChipGroupConfig({required this.labels, this.controller});

  final List<String> labels;
  final FlowinChipGroupController? controller;
}

class _ReconfigurableHarnessState extends State<_ReconfigurableHarness> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_ChipGroupConfig>(
      valueListenable: widget.notifier,
      builder: (context, config, _) {
        return FlowinChipGroup(
          labels: config.labels,
          controller: config.controller,
        );
      },
    );
  }
}

void main() {
  group('FlowinChipGroup', () {
    testWidgets('renders one chip per label', (tester) async {
      await tester.pumpApp(FlowinChipGroup(labels: _labels));
      expect(find.byType(ChoiceChip), findsNWidgets(_labels.length));
      for (final label in _labels) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('uncontrolled: tapping a chip reports its index', (
      tester,
    ) async {
      int? selectedIndex;
      await tester.pumpApp(
        FlowinChipGroup(
          labels: _labels,
          onSelected: (index) => selectedIndex = index,
        ),
      );

      await tester.tap(find.text('Settings'));
      await tester.pump();

      expect(selectedIndex, 2);
      final chip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.text('Settings'),
          matching: find.byType(ChoiceChip),
        ),
      );
      expect(chip.selected, isTrue);
    });

    testWidgets('controlled: setting controller.index updates selection', (
      tester,
    ) async {
      final controller = FlowinChipGroupController();
      addTearDown(controller.dispose);

      await tester.pumpApp(_ChipGroupHarness(controller: controller));

      controller.index = 3;
      await tester.pump();

      final chip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.text('Members'),
          matching: find.byType(ChoiceChip),
        ),
      );
      expect(chip.selected, isTrue);
    });

    testWidgets('initialSelectedIndex selects that chip when uncontrolled', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinChipGroup(labels: _labels, initialSelectedIndex: 1),
      );

      final chip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.text('Timeline'),
          matching: find.byType(ChoiceChip),
        ),
      );
      expect(chip.selected, isTrue);
    });

    testWidgets('non-scrollable lays the chips out in a Wrap', (tester) async {
      await tester.pumpApp(
        FlowinChipGroup(labels: _labels, isScrollable: false),
      );

      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(ChoiceChip), findsNWidgets(_labels.length));
    });

    testWidgets('non-scrollable run spacing defaults to the chip spacing', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinChipGroup(labels: _labels, isScrollable: false, chipSpacing: 20),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.spacing, 20);
      expect(wrap.runSpacing, 20);
    });

    testWidgets('non-scrollable honours explicit run spacing and alignment', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinChipGroup(
          labels: _labels,
          isScrollable: false,
          chipRunSpacing: 30,
          wrapAlignment: WrapAlignment.center,
        ),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.runSpacing, 30);
      expect(wrap.alignment, WrapAlignment.center);
    });

    testWidgets('non-scrollable: tapping a chip selects it', (tester) async {
      await tester.pumpApp(
        FlowinChipGroup(labels: _labels, isScrollable: false),
      );

      await tester.tap(find.text('Settings'));
      await tester.pump();

      final chip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.text('Settings'),
          matching: find.byType(ChoiceChip),
        ),
      );
      expect(chip.selected, isTrue);
    });

    testWidgets(
      'swapping in an external controller reattaches and disposes the owned '
      'one',
      (tester) async {
        final notifier = ValueNotifier<_ChipGroupConfig>(
          const _ChipGroupConfig(labels: _labels),
        );
        addTearDown(notifier.dispose);

        final controller = FlowinChipGroupController(initialIndex: 2);
        addTearDown(controller.dispose);

        await tester.pumpApp(_ReconfigurableHarness(notifier: notifier));

        // Initially uncontrolled (the group owns a controller, index 0).
        var chip = tester.widget<ChoiceChip>(
          find.ancestor(
            of: find.text('Board'),
            matching: find.byType(ChoiceChip),
          ),
        );
        expect(chip.selected, isTrue);

        // Swap to the external controller — triggers didUpdateWidget's
        // controller-changed branch and disposes the previously owned one.
        notifier.value = _ChipGroupConfig(
          labels: _labels,
          controller: controller,
        );
        await tester.pump();

        chip = tester.widget<ChoiceChip>(
          find.ancestor(
            of: find.text('Settings'),
            matching: find.byType(ChoiceChip),
          ),
        );
        expect(chip.selected, isTrue);

        // The newly attached controller still drives selection.
        controller.index = 3;
        await tester.pump();

        chip = tester.widget<ChoiceChip>(
          find.ancestor(
            of: find.text('Members'),
            matching: find.byType(ChoiceChip),
          ),
        );
        expect(chip.selected, isTrue);
      },
    );

    testWidgets('shrinking the labels clamps the selection to the last chip', (
      tester,
    ) async {
      final notifier = ValueNotifier<_ChipGroupConfig>(
        const _ChipGroupConfig(labels: _labels),
      );
      addTearDown(notifier.dispose);

      final controller = FlowinChipGroupController(initialIndex: 3);
      addTearDown(controller.dispose);

      await tester.pumpApp(
        _ReconfigurableHarness(notifier: notifier),
      );

      // Replace the controller-less config with one carrying our controller,
      // then shrink the label list so the selected index is out of range.
      notifier.value = _ChipGroupConfig(
        labels: _labels,
        controller: controller,
      );
      await tester.pump();
      expect(controller.index, 3);

      notifier.value = _ChipGroupConfig(
        labels: const ['Board', 'Timeline'],
        controller: controller,
      );
      await tester.pump();

      // didUpdateWidget clamps the index down to maxIndex (1).
      expect(controller.index, 1);
      final chip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.text('Timeline'),
          matching: find.byType(ChoiceChip),
        ),
      );
      expect(chip.selected, isTrue);
    });
  });

  // The group builds its own chips, so it is the layer most likely to grow a
  // styling shortcut — passing a colour or a TextStyle down to FlowinChip
  // instead of leaving the chipTheme to do it. These render the *group* and
  // assert on the chip that comes out, which is the only way to catch that.
  group('FlowinChipGroup theme-only styling', () {
    testWidgets('selected fill comes from the chip theme, not the group', (
      tester,
    ) async {
      const customSelected = Color(0xFF112233);
      final theme = FlowinTheme.light.copyWith(
        chipTheme: FlowinTheme.light.chipTheme.copyWith(
          selectedColor: customSelected,
        ),
      );

      await tester.pumpApp(
        FlowinChipGroup(labels: _labels, initialSelectedIndex: 1),
        theme: theme,
      );

      expect(_paintedFillOf(tester, 'Timeline'), customSelected);
    });

    testWidgets('unselected fill comes from the chip theme, not the group', (
      tester,
    ) async {
      // The unselected slot is a separate binding from selectedColor: a group
      // that hardcoded a background would still pass the selected-fill test.
      const customBackground = Color(0xFF203040);
      final theme = FlowinTheme.light.copyWith(
        chipTheme: FlowinTheme.light.chipTheme.copyWith(
          backgroundColor: customBackground,
        ),
      );

      await tester.pumpApp(
        FlowinChipGroup(labels: _labels, initialSelectedIndex: 1),
        theme: theme,
      );

      expect(_paintedFillOf(tester, 'Board'), customBackground);
    });

    testWidgets('border side comes from the chip theme, not the group', (
      tester,
    ) async {
      const customBorder = Color(0xFF445566);
      final theme = FlowinTheme.light.copyWith(
        chipTheme: FlowinTheme.light.chipTheme.copyWith(
          side: const BorderSide(color: customBorder, width: 3),
        ),
      );

      await tester.pumpApp(FlowinChipGroup(labels: _labels), theme: theme);

      final shape = _paintedShapeOf(tester, 'Timeline');
      expect(shape.side.color, customBorder);
      expect(shape.side.width, 3);
    });

    testWidgets('pill shape comes from the chip theme, not the group', (
      tester,
    ) async {
      final theme = FlowinTheme.light.copyWith(
        chipTheme: FlowinTheme.light.chipTheme.copyWith(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
        ),
      );

      await tester.pumpApp(FlowinChipGroup(labels: _labels), theme: theme);

      expect(
        _paintedShapeOf(tester, 'Timeline'),
        isA<RoundedRectangleBorder>().having(
          (shape) => shape.borderRadius,
          'borderRadius',
          const BorderRadius.all(Radius.circular(3)),
        ),
      );
    });

    testWidgets('label style comes from the chip theme, not the group', (
      tester,
    ) async {
      const customStyle = TextStyle(fontSize: 27, letterSpacing: 4);
      final theme = FlowinTheme.light.copyWith(
        chipTheme: FlowinTheme.light.chipTheme.copyWith(
          labelStyle: customStyle,
        ),
      );

      await tester.pumpApp(FlowinChipGroup(labels: _labels), theme: theme);

      // 'Timeline' is unselected, so this exercises labelStyle rather than
      // the secondaryLabelStyle a selected chip resolves.
      final rendered = _renderedLabelStyle(tester, 'Timeline');
      expect(rendered.fontSize, 27);
      expect(rendered.letterSpacing, 4);
    });
  });

  group('FlowinChipGroup API parity (#14)', () {
    testWidgets('onSelectedLabel reports the selected label', (tester) async {
      String? selectedLabel;
      await tester.pumpApp(
        FlowinChipGroup(
          labels: _labels,
          onSelectedLabel: (label) => selectedLabel = label,
        ),
      );

      await tester.tap(find.text('Settings'));
      await tester.pump();
      expect(selectedLabel, 'Settings');
    });

    testWidgets('onLongPress reports the long-pressed index', (tester) async {
      int? longPressedIndex;
      await tester.pumpApp(
        FlowinChipGroup(
          labels: _labels,
          onLongPress: (index) => longPressedIndex = index,
        ),
      );

      await tester.longPress(find.text('Timeline'));
      await tester.pump();
      expect(longPressedIndex, 1);
    });

    testWidgets('chipBuilder overrides default chip rendering', (tester) async {
      await tester.pumpApp(
        FlowinChipGroup(
          labels: _labels,
          chipBuilder: (index, label, isSelected, onSelected) => FlowinChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [const Icon(Icons.tag), Text(label)],
            ),
            variant: isSelected
                ? FlowinChipVariant.selected
                : FlowinChipVariant.unselected,
            onSelected: onSelected,
          ),
        ),
      );

      // Custom content rendered for every chip.
      expect(find.byIcon(Icons.tag), findsNWidgets(_labels.length));
      // Selection still flows through the provided onSelected.
      await tester.tap(find.text('Members'));
      await tester.pump();
      final chip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.text('Members'),
          matching: find.byType(ChoiceChip),
        ),
      );
      expect(chip.selected, isTrue);
    });
  });

  group('FlowinChipGroupController', () {
    test('index setter notifies listeners only when the value changes', () {
      final controller = FlowinChipGroupController();
      addTearDown(controller.dispose);

      var notifications = 0;
      controller
        ..addListener(() => notifications++)
        ..index = 0;
      expect(notifications, 0);

      controller.index = 2;
      expect(notifications, 1);
    });
  });

  group('scrollable padding wraps the chips instead of eating them', () {
    // The ListView applies padding inside the row's box, and a horizontal
    // list hands its children the cross extent minus the vertical inset — so
    // at a fixed height every pixel of vertical padding came out of the
    // chips, crushing them below their content until the border drew through
    // the labels. The row grows by the inset instead.
    testWidgets('vertical padding grows the row box', (tester) async {
      await tester.pumpApp(
        FlowinChipGroup(
          labels: _labels,
          padding: const EdgeInsets.all(FlowinDesignSpace.space300),
        ),
      );

      final box = tester.getSize(find.byType(FlowinChipGroup));
      expect(
        box.height,
        FlowinDesignSpace.space1200 + 2 * FlowinDesignSpace.space300,
      );
    });

    testWidgets('the chips keep their height under vertical padding', (
      tester,
    ) async {
      await tester.pumpApp(FlowinChipGroup(labels: _labels));
      final unpadded = tester.getSize(find.byType(ChoiceChip).first).height;

      await tester.pumpApp(
        FlowinChipGroup(
          labels: _labels,
          padding: const EdgeInsets.all(FlowinDesignSpace.space600),
        ),
      );
      final padded = tester.getSize(find.byType(ChoiceChip).first).height;

      expect(
        padded,
        unpadded,
        reason: 'the inset must wrap the chips, not shrink them',
      );
    });

    testWidgets('horizontal-only padding leaves the row at its height', (
      tester,
    ) async {
      // The default callers all pass horizontal-only padding; their rows must
      // not move.
      await tester.pumpApp(
        FlowinChipGroup(
          labels: _labels,
          padding: const EdgeInsets.symmetric(
            horizontal: FlowinDesignSpace.space400,
          ),
        ),
      );

      final box = tester.getSize(find.byType(FlowinChipGroup));
      expect(box.height, FlowinDesignSpace.space1200);
    });

    testWidgets('an explicit height grows by the inset too', (tester) async {
      await tester.pumpApp(
        FlowinChipGroup(
          labels: _labels,
          height: FlowinDesignSpace.space1600,
          padding: const EdgeInsets.all(FlowinDesignSpace.space200),
        ),
      );

      final box = tester.getSize(find.byType(FlowinChipGroup));
      expect(
        box.height,
        FlowinDesignSpace.space1600 + 2 * FlowinDesignSpace.space200,
      );
    });
  });
}
