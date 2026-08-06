import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

const _labels = ['Board', 'Timeline', 'Settings', 'Members'];

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
}
