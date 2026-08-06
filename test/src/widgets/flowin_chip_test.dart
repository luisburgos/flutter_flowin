// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FlowinChip', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpApp(FlowinChip(label: Text('Tag')));
      expect(find.text('Tag'), findsOneWidget);
    });

    testWidgets('reports selection when tapped', (tester) async {
      bool? selectedValue;
      await tester.pumpApp(
        FlowinChip(
          label: Text('Tag'),
          onSelected: (value) => selectedValue = value,
        ),
      );
      await tester.tap(find.byType(ChoiceChip));
      expect(selectedValue, isTrue);
    });

    testWidgets('selected variant marks the ChoiceChip selected', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinChip(
          label: Text('Tag'),
          variant: FlowinChipVariant.selected,
          onSelected: (_) {},
        ),
      );
      final chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
      expect(chip.selected, isTrue);
    });

    testWidgets('fires onLongPress without changing selection', (tester) async {
      var longPressed = false;
      bool? selectedValue;
      await tester.pumpApp(
        FlowinChip(
          label: Text('Tag'),
          onSelected: (value) => selectedValue = value,
          onLongPress: () => longPressed = true,
        ),
      );
      await tester.longPress(find.byType(ChoiceChip));
      expect(longPressed, isTrue);
      expect(selectedValue, isNull); // long-press does not toggle selection
    });

    testWidgets('onLongPress claims the gesture, suppressing selection', (
      tester,
    ) async {
      // With a long-press handler the wrapper claims the gesture; without one,
      // a long-press falls through to the chip and resolves as a tap (Material
      // behavior). This asserts the difference the handler makes.
      bool? withHandlerSelection;
      var longPressed = false;
      await tester.pumpApp(
        FlowinChip(
          label: Text('Tag'),
          onSelected: (value) => withHandlerSelection = value,
          onLongPress: () => longPressed = true,
        ),
      );
      await tester.longPress(find.byType(ChoiceChip));
      expect(longPressed, isTrue);
      expect(withHandlerSelection, isNull);

      bool? withoutHandlerSelection;
      await tester.pumpApp(
        FlowinChip(
          label: Text('Tag'),
          onSelected: (value) => withoutHandlerSelection = value,
        ),
      );
      await tester.longPress(find.byType(ChoiceChip));
      expect(withoutHandlerSelection, isTrue);
    });

    testWidgets('accepts composite (non-text) label content', (tester) async {
      await tester.pumpApp(
        FlowinChip(
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.star), Text('Starred')],
          ),
          onSelected: (_) {},
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Starred'), findsOneWidget);
    });

    testWidgets('dimmed variant applies reduced opacity', (tester) async {
      await tester.pumpApp(
        FlowinChip(
          label: Text('Tag'),
          variant: FlowinChipVariant.unselectedDimmed,
          onSelected: (_) {},
        ),
      );
      final opacity = tester.widget<Opacity>(
        find.ancestor(
          of: find.byType(ChoiceChip),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, 0.5);
    });

    testWidgets(
      'selected color comes from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        const customSelected = Color(0xFF112233);
        final theme = FlowinTheme.light.copyWith(
          chipTheme: FlowinTheme.light.chipTheme.copyWith(
            selectedColor: customSelected,
          ),
        );

        await tester.pumpApp(
          FlowinChip(
            label: Text('Tag'),
            variant: FlowinChipVariant.selected,
            onSelected: (_) {},
          ),
          theme: theme,
        );

        expect(
          ChipTheme.of(
            tester.element(find.byType(ChoiceChip)),
          ).selectedColor,
          customSelected,
        );
      },
    );

    testWidgets(
      'unselected border binds to the subtle-border role (outlineVariant), '
      'not the secondary-surface role',
      (tester) async {
        await tester.pumpApp(
          FlowinChip(label: Text('Tag'), onSelected: (_) {}),
        );
        final context = tester.element(find.byType(ChoiceChip));
        final scheme = Theme.of(context).colorScheme;
        final side = ChipTheme.of(context).side;
        expect(
          side?.color,
          scheme.outlineVariant,
          reason:
              'spec chip.md: unselected border side color = borderSubtle '
              '(Flutter outlineVariant), not surfaceSecondary',
        );
        // Guard against re-binding to the secondary-surface role: only assert
        // inequality once the palette actually distinguishes them (today the
        // placeholder ramp makes outlineVariant == secondaryContainer).
        if (scheme.outlineVariant != scheme.secondaryContainer) {
          expect(side?.color, isNot(scheme.secondaryContainer));
        }
      },
    );

    testWidgets(
      'border side comes from the theme, not the widget (theme-only styling)',
      (tester) async {
        const customBorder = Color(0xFF445566);
        final theme = FlowinTheme.light.copyWith(
          chipTheme: FlowinTheme.light.chipTheme.copyWith(
            side: const BorderSide(color: customBorder),
          ),
        );
        await tester.pumpApp(
          FlowinChip(label: Text('Tag'), onSelected: (_) {}),
          theme: theme,
        );
        expect(
          ChipTheme.of(tester.element(find.byType(ChoiceChip))).side?.color,
          customBorder,
        );
      },
    );

    testWidgets(
      'selected label binds to the on-secondary-surface role',
      (tester) async {
        await tester.pumpApp(
          FlowinChip(
            label: Text('Tag'),
            variant: FlowinChipVariant.selected,
            onSelected: (_) {},
          ),
        );
        final context = tester.element(find.byType(ChoiceChip));
        final secondaryLabel = ChipTheme.of(context).secondaryLabelStyle;
        expect(
          secondaryLabel?.color,
          Theme.of(context).colorScheme.onSecondaryContainer,
          reason:
              'spec chip.md: selected label foreground = '
              'onSurfaceSecondary (Flutter onSecondaryContainer)',
        );
      },
    );
  });

  group('FlowinChipVariant', () {
    test('isSelected is true only for selected', () {
      expect(FlowinChipVariant.selected.isSelected, isTrue);
      expect(FlowinChipVariant.unselected.isSelected, isFalse);
      expect(FlowinChipVariant.unselectedDimmed.isSelected, isFalse);
    });

    test('opacity is 0.5 only for dimmed', () {
      expect(FlowinChipVariant.selected.opacity, 1);
      expect(FlowinChipVariant.unselected.opacity, 1);
      expect(FlowinChipVariant.unselectedDimmed.opacity, 0.5);
    });
  });

  group('constraints', () {
    testWidgets('a minimum makes short and long labels the same size', (
      tester,
    ) async {
      const minimum = BoxConstraints(minWidth: 160, minHeight: 48);

      await tester.pumpApp(
        const Column(
          children: [
            FlowinChip(label: Text('A'), constraints: minimum),
            FlowinChip(
              label: Text('A much longer label'),
              constraints: minimum,
            ),
          ],
        ),
      );

      final short = tester.getSize(find.byType(FlowinChip).first);
      final long = tester.getSize(find.byType(FlowinChip).last);

      // Both reach the floor; without the constraint the short one collapses
      // to its content width and the pair renders ragged.
      expect(short.width, greaterThanOrEqualTo(160));
      expect(short.height, greaterThanOrEqualTo(48));
      expect(long.height, greaterThanOrEqualTo(48));
    });

    testWidgets('sizes to content when no constraints are given', (
      tester,
    ) async {
      await tester.pumpApp(
        const Column(
          children: [
            FlowinChip(label: Text('A')),
            FlowinChip(label: Text('A much longer label')),
          ],
        ),
      );

      final short = tester.getSize(find.byType(FlowinChip).first);
      final long = tester.getSize(find.byType(FlowinChip).last);

      expect(short.width, lessThan(long.width));
    });
  });

  group('leading spacing', () {
    testWidgets('a leading widget gets a gap before the label', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinChip(
          label: const Text('SET 1'),
          leading: const Icon(Icons.circle, size: 12),
        ),
      );

      final leadingRight = tester.getRect(find.byType(Icon)).right;
      final labelLeft = tester.getRect(find.text('SET 1')).left;

      // The theme zeroes labelPadding for label-only chips; without the
      // widget-level inset the icon sits flush against the text.
      expect(
        labelLeft - leadingRight,
        closeTo(FlowinDesignSpace.space100, 0.5),
      );
    });

    testWidgets('a label-only chip keeps the theme zero labelPadding', (
      tester,
    ) async {
      await tester.pumpApp(FlowinChip(label: const Text('Chip')));

      final chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
      // Null defers to the theme, which pins EdgeInsets.zero. Anything else
      // would re-inflate every label-only chip past its oracle width.
      expect(chip.labelPadding, isNull);
    });
  });
}
