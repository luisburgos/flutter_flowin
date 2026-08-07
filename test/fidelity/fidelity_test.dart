// Fidelity tests: flutter_flowin rendered styles vs the production
// flowin_design package (Archive/flowin_design @ fidelity-oracle-0.3.0).
//
// Every expectation here comes from `oracle_fixtures.dart`, which pins the
// values production actually resolves. A FAILING test in this file is a
// fidelity deviation from production — not necessarily a bug to auto-fix:
// each red result goes to the manual-validation gate, where it is either
// fixed in flutter_flowin or accepted as an intentional (documented)
// deviation.

import 'package:flutter/rendering.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';
import 'oracle_fixtures.dart';

void main() {
  final light = FlowinTheme.light;
  final scheme = light.colorScheme;

  group('fidelity: FlowinButton', () {
    final sizes = {
      FlowinButtonSize.xs: oracleButtonXs,
      FlowinButtonSize.sm: oracleButtonSm,
      FlowinButtonSize.md: oracleButtonMd,
    };

    testWidgets(
      'every variant is a pill like production, which set no shape and so '
      "inherited Material's StadiumBorder (fd_button.dart:161)",
      (tester) async {
        // Asserting StadiumBorder rather than a radius value: a fixed radius
        // only looks like a pill at one height. radius400 (16) was a rounded
        // rectangle on anything taller than 32, which is every size here.
        // Each variant renders a different Material button, so the concrete
        // type has to be paired with it — ButtonStyleButton is abstract and
        // find.byType would match nothing.
        final variants = <String, (Widget, Type)>{
          'filled': (
            FlowinButton(onPressed: () {}, label: 'Go'),
            FilledButton,
          ),
          'tonal': (
            FlowinButton.tonal(onPressed: () {}, label: 'Go'),
            FilledButton,
          ),
          'outline': (
            FlowinButton.outline(onPressed: () {}, label: 'Go'),
            OutlinedButton,
          ),
          'text': (
            FlowinButton.text(onPressed: () {}, label: 'Go'),
            TextButton,
          ),
          'destructive': (
            FlowinButton.destructive(onPressed: () {}, label: 'Go'),
            FilledButton,
          ),
        };

        for (final entry in variants.entries) {
          final (widget, type) = entry.value;
          await tester.pumpApp(widget);
          final shape = (tester.widget(find.byType(type)) as ButtonStyleButton)
              .style
              ?.shape
              ?.resolve({});
          // A null shape means the widget defers to the theme, which defers
          // to Material — whose default is StadiumBorder.
          expect(
            shape ?? const StadiumBorder(),
            isA<StadiumBorder>(),
            reason:
                '${entry.key} must be a pill at every size, not a fixed radius',
          );
        }
      },
    );

    testWidgets(
      'the theme itself pins no button shape, so the pill survives a '
      'resize at any height',
      (tester) async {
        for (final style in [
          light.filledButtonTheme.style,
          light.outlinedButtonTheme.style,
          light.textButtonTheme.style,
        ]) {
          expect(
            style!.shape?.resolve({}),
            isNull,
            reason: 'setting a fixed radius here is what broke the pill',
          );
        }
      },
    );

    for (final entry in sizes.entries) {
      final size = entry.key;
      final oracle = entry.value;

      testWidgets('$size min height matches production', (tester) async {
        await tester.pumpApp(
          FlowinButton(onPressed: () {}, label: 'Go', size: size),
        );
        final style = tester
            .widget<FilledButton>(find.byType(FilledButton))
            .style!;
        expect(
          style.minimumSize!.resolve({}),
          Size(0, oracle.fixedSize),
        );
      });

      testWidgets('$size inner padding matches production', (tester) async {
        await tester.pumpApp(
          FlowinButton(onPressed: () {}, label: 'Go', size: size),
        );
        final style = tester
            .widget<FilledButton>(find.byType(FilledButton))
            .style!;
        expect(style.padding!.resolve({}), oracle.innerPadding);
      });

      testWidgets('$size icon size matches production', (tester) async {
        await tester.pumpApp(
          FlowinButton(onPressed: () {}, label: 'Go', size: size),
        );
        final style = tester
            .widget<FilledButton>(find.byType(FilledButton))
            .style!;
        expect(style.iconSize!.resolve({}), oracle.iconSize);
      });

      testWidgets(
        '$size outer padding is vertical-only in production '
        '(fd_button.dart:129 EdgeInsets.symmetric(vertical: size.padding))',
        (tester) async {
          await tester.pumpApp(
            FlowinButton(onPressed: () {}, label: 'Go', size: size),
          );
          final button = find.byType(FilledButton);
          final wrapper = find.ancestor(
            of: button,
            matching: find.byType(Padding),
          );
          final effective = wrapper.evaluate().isEmpty
              ? EdgeInsets.zero
              : (tester.widget<Padding>(wrapper.first).padding as EdgeInsets);
          expect(
            effective,
            EdgeInsets.symmetric(vertical: oracle.outerPadding),
          );
        },
      );
    }

    testWidgets('destructive colors match production error roles', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinButton.destructive(onPressed: () {}, label: 'Delete'),
      );
      final style = tester
          .widget<FilledButton>(find.byType(FilledButton))
          .style!;
      expect(style.backgroundColor!.resolve({}), scheme.errorContainer);
      expect(style.foregroundColor!.resolve({}), scheme.onErrorContainer);
    });

    test('per-size label styles match production mapping', () {
      final textTheme = light.textTheme;
      expect(
        FlowinButtonSize.xs.textStyle(textTheme),
        textTheme.labelSmall,
      );
      expect(
        FlowinButtonSize.sm.textStyle(textTheme),
        textTheme.labelMedium,
      );
      expect(
        FlowinButtonSize.md.textStyle(textTheme),
        textTheme.labelLarge,
      );
    });
  });

  group('fidelity: FlowinIconButton', () {
    final sizes = {
      FlowinButtonSize.xs: oracleButtonXs,
      FlowinButtonSize.sm: oracleButtonSm,
      FlowinButtonSize.md: oracleButtonMd,
    };

    for (final entry in sizes.entries) {
      final size = entry.key;
      final oracle = entry.value;

      testWidgets(
        '$size outer padding is ALL-SIDES in production '
        '(fd_icon_button.dart:74 — unlike FlowinButton, which is '
        'vertical-only)',
        (tester) async {
          await tester.pumpApp(
            FlowinIconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
              size: size,
            ),
          );

          final wrapper = find.ancestor(
            of: find.byType(IconButton),
            matching: find.byType(Padding),
          );
          final effective = wrapper.evaluate().isEmpty
              ? EdgeInsets.zero
              : (tester.widget<Padding>(wrapper.first).padding as EdgeInsets);

          expect(effective, oracleIconButtonOuterPadding(oracle.outerPadding));
        },
      );

      testWidgets('$size is a square of fixedSize with zero inner padding', (
        tester,
      ) async {
        await tester.pumpApp(
          FlowinIconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
            size: size,
          ),
        );

        final style = tester.widget<IconButton>(find.byType(IconButton)).style!;
        expect(style.fixedSize!.resolve({}), Size.square(oracle.fixedSize));
        expect(style.minimumSize!.resolve({}), Size.square(oracle.fixedSize));
        expect(style.padding!.resolve({}), oracleIconButtonInnerPadding);
      });

      testWidgets('$size icon size matches production', (tester) async {
        await tester.pumpApp(
          FlowinIconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
            size: size,
          ),
        );

        final button = tester.widget<IconButton>(find.byType(IconButton));
        expect(button.iconSize, oracle.iconSize);
      });
    }

    testWidgets('variant colors match production role bindings', (
      tester,
    ) async {
      final expected = {
        FlowinIconButtonVariant.filled: (
          scheme.primary,
          scheme.onPrimary,
        ),
        FlowinIconButtonVariant.tonal: (
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
        ),
        FlowinIconButtonVariant.text: (
          Colors.transparent,
          scheme.primary,
        ),
        FlowinIconButtonVariant.destructive: (
          scheme.errorContainer,
          scheme.onErrorContainer,
        ),
      };

      for (final entry in expected.entries) {
        await tester.pumpApp(
          FlowinIconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
            variant: entry.key,
          ),
        );

        final style = tester.widget<IconButton>(find.byType(IconButton)).style!;
        expect(
          style.backgroundColor!.resolve({}),
          entry.value.$1,
          reason: '${entry.key} background',
        );
        expect(
          style.foregroundColor!.resolve({}),
          entry.value.$2,
          reason: '${entry.key} foreground',
        );
      }
    });
  });

  group('fidelity: FlowinItemButton', () {
    testWidgets('content padding is uniform 16 like production', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: () {}, label: 'Row'),
      );
      final style = tester
          .widget<FilledButton>(find.byType(FilledButton))
          .style!;
      expect(style.padding!.resolve({}), oracleItemButtonPadding);
    });

    testWidgets('min height matches production (md fixedSize 56)', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: () {}, label: 'Row'),
      );
      final style = tester
          .widget<FilledButton>(find.byType(FilledButton))
          .style!;
      expect(
        style.minimumSize!.resolve({})!.height,
        oracleItemButtonMinHeight,
      );
    });

    testWidgets('content aligns center-left like production', (tester) async {
      await tester.pumpApp(
        FlowinItemButton(onPressed: () {}, label: 'Row'),
      );
      final style = tester
          .widget<FilledButton>(find.byType(FilledButton))
          .style!;
      expect(style.alignment, oracleItemButtonAlignment);
    });

    testWidgets(
      'shape and text style resolve to radius400 + labelLarge like production '
      '(fd_item_button.dart:65,72)',
      (tester) async {
        await tester.pumpApp(
          FlowinItemButton(onPressed: () {}, label: 'Row'),
        );

        // The radius is pinned on the widget, not the theme: every other
        // Flowin button is a pill, and a 56-tall row inheriting that would
        // have 28-radius ends. Read it off the rendered button so the test
        // fails if the widget stops overriding the theme's stadium default.
        final rendered = tester
            .widget<FilledButton>(find.byType(FilledButton))
            .style!;
        final shape = rendered.shape!.resolve({})! as RoundedRectangleBorder;
        expect(
          shape.borderRadius,
          BorderRadius.circular(oracleItemButtonRadius),
        );
        expect(
          light.filledButtonTheme.style!.textStyle!.resolve({})!.fontSize,
          light.textTheme.labelLarge!.fontSize,
        );
      },
    );

    testWidgets(
      'ACCEPTED DEVIATION: the row icon binds to {iconSize.md} (20), not '
      "production's 24 (which came from routing through the BUTTON size "
      'scale: md → lg) — see specItemButtonIconSize',
      (tester) async {
        await tester.pumpApp(
          FlowinItemButton(
            onPressed: () {},
            label: 'Row',
            icon: const Icon(Icons.add),
          ),
        );
        final iconSize = tester
            .renderObject<RenderParagraph>(
              find.descendant(
                of: find.byIcon(Icons.add),
                matching: find.byType(RichText),
              ),
            )
            .text
            .style!
            .fontSize;
        expect(iconSize, specItemButtonIconSize);
        // The shipped literal is the {iconSize.md} token — the widget spells
        // it out only because enum getters are not const-evaluable.
        expect(specItemButtonIconSize, FlowinDesignIconSize.md.value);
        // The divergence from production is deliberate, not drift.
        expect(specItemButtonIconSize, isNot(oracleItemButtonIconSize));
      },
    );

    testWidgets(
      'the row min height is the {size.control.md} token, not a loose literal',
      (tester) async {
        // Same guard as the icon size above, for the same reason: the widget
        // spells 56 out because enum getters are not const-evaluable, so the
        // literal needs a pin tying it back to the token it stands for.
        // Without this, a spec change to the control scale would leave the
        // row's height silently behind.
        await tester.pumpApp(
          FlowinItemButton(onPressed: () {}, label: 'Row'),
        );

        final minHeight = tester
            .widget<FilledButton>(find.byType(FilledButton))
            .style!
            .minimumSize!
            .resolve({})!
            .height;

        expect(minHeight, FlowinDesignControlSize.md.value);
      },
    );
  });

  group('fidelity: FlowinChip', () {
    testWidgets(
      'content padding is EdgeInsets.all(16) in production '
      '(fd_chip.dart:103) — theme currently uses h16/v8',
      (tester) async {
        await tester.pumpApp(
          FlowinChip(label: const Text('Chip'), onSelected: (_) {}),
        );
        final chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
        final effective = chip.padding ?? light.chipTheme.padding;
        expect(effective, oracleChipPadding);
      },
    );

    testWidgets(
      'unselected border binds to secondaryContainer in production '
      '(fd_chip.dart:88 — CONFLICTS with spec/outlineVariant; '
      'flowin_pm C1 recorded the reverse)',
      (tester) async {
        await tester.pumpApp(
          FlowinChip(label: const Text('Chip'), onSelected: (_) {}),
        );
        final chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
        final side = chip.side ?? light.chipTheme.side;
        expect(side!.color, scheme.secondaryContainer);
      },
    );

    testWidgets(
      'a selected chip shows NO checkmark, like production '
      '(fd_chip.dart renders the label straight into a Container with no '
      'leading slot; Material would insert one)',
      (tester) async {
        await tester.pumpApp(
          FlowinChip(
            label: const Text('Chip'),
            variant: FlowinChipVariant.selected,
            onSelected: (_) {},
          ),
        );

        final chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
        expect(
          chip.showCheckmark ?? light.chipTheme.showCheckmark,
          oracleChipShowsCheckmark,
        );
        // Nothing renders in the leading slot.
        expect(find.byIcon(Icons.check), findsNothing);
      },
    );

    testWidgets('selected background binds to secondaryContainer', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinChip(
          label: const Text('Chip'),
          variant: FlowinChipVariant.selected,
          onSelected: (_) {},
        ),
      );
      final chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
      final selectedColor = chip.selectedColor ?? light.chipTheme.selectedColor;
      expect(selectedColor, scheme.secondaryContainer);
    });

    testWidgets(
      'label uses labelSmall + onSecondaryContainer in production '
      '(fd_chip_label.dart) — theme currently uses labelMedium + onSurface',
      (tester) async {
        await tester.pumpApp(
          FlowinChip(label: const Text('Chip'), onSelected: (_) {}),
        );
        final text = tester.widget<Text>(find.text('Chip'));
        final labelStyle = text.style ?? light.chipTheme.labelStyle;
        final oracleStyle = light.textTheme.labelSmall!.copyWith(
          color: scheme.onSecondaryContainer,
        );
        expect(labelStyle?.fontSize, oracleStyle.fontSize);
        expect(labelStyle?.color, oracleStyle.color);
      },
    );

    test('dimmed variant opacity matches production', () {
      expect(
        FlowinChipVariant.unselectedDimmed.opacity,
        oracleChipDimmedOpacity,
      );
    });

    testWidgets(
      'theme neutralizes Material chip extras production does not have '
      '(labelPadding zero, no tap-target inflation) — see '
      'oracleChipBoxTolerance',
      (tester) async {
        expect(light.chipTheme.labelPadding, EdgeInsets.zero);

        // ChipThemeData cannot express these two, so they live on the widget.
        await tester.pumpApp(
          FlowinChip(label: const Text('Chip'), onSelected: (_) {}),
        );
        final chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
        expect(
          chip.materialTapTargetSize,
          MaterialTapTargetSize.shrinkWrap,
        );
        expect(chip.visualDensity, VisualDensity.standard);
      },
    );

    testWidgets(
      'rendered box matches production within the border-geometry tolerance '
      '(fd_chip.dart: label + all-16 padding + 1px outside border)',
      (tester) async {
        await tester.pumpApp(
          Center(
            child: FlowinChip(label: const Text('Chip'), onSelected: (_) {}),
          ),
        );

        final labelSize = tester.getSize(find.text('Chip'));
        final box = tester.getSize(find.byType(ChoiceChip));
        expect(
          box.height,
          closeTo(
            oracleChipBoxHeight(labelSize.height),
            oracleChipBoxTolerance,
          ),
        );
        expect(
          box.width,
          closeTo(oracleChipBoxWidth(labelSize.width), oracleChipBoxTolerance),
        );
      },
    );
  });

  group('fidelity: FlowinChipGroup', () {
    testWidgets('row height is 48 like production (fd_chip_group.dart:183)', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinChipGroup(
          labels: const ['a', 'b'],
          onSelected: (_) {},
        ),
      );
      final box = tester.getSize(find.byType(FlowinChipGroup));
      expect(box.height, oracleChipGroupHeight);
    });

    testWidgets(
      'scrollable row padding and chip spacing match production '
      '(fd_chip_group.dart:39-42 — h space300, gap space200)',
      (tester) async {
        await tester.pumpApp(
          FlowinChipGroup(labels: const ['a', 'b'], onSelected: (_) {}),
        );
        final list = tester.widget<ListView>(find.byType(ListView));
        expect(list.padding, oracleChipGroupPadding);

        final separator = find.descendant(
          of: find.byType(ListView),
          matching: find.byWidgetPredicate(
            (w) =>
                w is SizedBox &&
                w.width == oracleChipGroupSpacing &&
                w.child == null,
          ),
        );
        expect(separator, findsOneWidget);
      },
    );

    testWidgets(
      'non-scrollable layout matches production: a center-aligned Wrap with '
      'the same padding and spacing (fd_chip_group.dart:196-202)',
      (tester) async {
        await tester.pumpApp(
          FlowinChipGroup(
            labels: const ['a', 'b'],
            isScrollable: false,
            onSelected: (_) {},
          ),
        );
        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        // ACCEPTED DEVIATION: production centres its wrapped rows, which leaves
        // a partial last row out of line. See flowinChipGroupWrapAlignment.
        expect(wrap.alignment, flowinChipGroupWrapAlignment);
        expect(
          flowinChipGroupWrapAlignment,
          isNot(oracleChipGroupWrapAlignment),
        );
        expect(wrap.spacing, oracleChipGroupSpacing);
        // ACCEPTED DEVIATION: production never sets runSpacing, so its wrapped
        // rows touch (Flutter's default 0). See flowinChipGroupRunSpacing.
        expect(wrap.runSpacing, flowinChipGroupRunSpacing);
        expect(flowinChipGroupRunSpacing, isNot(oracleChipGroupRunSpacing));

        final wrapper = tester.widget<Padding>(
          find
              .ancestor(of: find.byType(Wrap), matching: find.byType(Padding))
              .first,
        );
        expect(wrapper.padding, oracleChipGroupPadding);
      },
    );
  });

  group('fidelity: FlowinChipGroupViewPager', () {
    final pages = [
      FlowinChipGroupViewPage.child(label: 'One', child: const Text('P1')),
      FlowinChipGroupViewPage.child(label: 'Two', child: const Text('P2')),
    ];

    testWidgets(
      'column spacing is space300 like production '
      '(fd_chip_group_view_pager.dart:183)',
      (tester) async {
        await tester.pumpApp(FlowinChipGroupViewPager(items: pages));
        final column = tester.widget<Column>(
          find
              .descendant(
                of: find.byType(FlowinChipGroupViewPager),
                matching: find.byType(Column),
              )
              .first,
        );
        expect(column.spacing, oracleViewPagerColumnSpacing);
      },
    );

    testWidgets(
      'chip-row defaults match production '
      '(fd_chip_group_view_pager.dart:38-41)',
      (tester) async {
        await tester.pumpApp(FlowinChipGroupViewPager(items: pages));
        final chipGroup = tester.widget<FlowinChipGroup>(
          find.byType(FlowinChipGroup),
        );
        expect(chipGroup.padding, oracleViewPagerChipsPadding);
        expect(chipGroup.chipSpacing, oracleViewPagerChipSpacing);
      },
    );

    testWidgets(
      'separates the chip row from the pages with a divider like production '
      '(fd_chip_group_view_pager.dart FDDivider)',
      (tester) async {
        await tester.pumpApp(FlowinChipGroupViewPager(items: pages));
        expect(
          find.descendant(
            of: find.byType(FlowinChipGroupViewPager),
            matching: find.byType(Divider),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'page-turn animation defaults match production '
      '(fd_chip_group_view_pager.dart:47-49)',
      (tester) async {
        await tester.pumpApp(FlowinChipGroupViewPager(items: pages));
        final pager = tester.widget<FlowinChipGroupViewPager>(
          find.byType(FlowinChipGroupViewPager),
        );
        expect(pager.animateDuration, oracleViewPagerAnimateDuration);
        expect(pager.animateCurve, oracleViewPagerAnimateCurve);
      },
    );
  });

  group('fidelity: dividers', () {
    testWidgets('divider extent and color match production', (tester) async {
      await tester.pumpApp(const Divider());
      final divider = tester.widget<Divider>(find.byType(Divider));
      final theme = light.dividerTheme;
      expect(divider.height ?? theme.space, oracleDividerExtent);
      expect(theme.color, scheme.outlineVariant);
      expect(theme.thickness, oracleTabAppBarDividerThickness);
    });
  });

  group('fidelity: FlowinTabs / FlowinTabItem', () {
    test('tab row height matches production', () {
      expect(kFlowinTabsHeight, oracleTabItemHeight);
    });

    testWidgets(
      'icon-to-label gap is 4 in production (fd_tab_item.dart) — '
      'flutter_flowin currently uses space200 (8)',
      (tester) async {
        await tester.pumpApp(
          const FlowinTabItem(label: 'Tab', icon: Icon(Icons.circle)),
        );
        final gap = tester.widget<SizedBox>(
          find
              .descendant(
                of: find.byType(Row),
                matching: find.byWidgetPredicate(
                  (w) => w is SizedBox && w.width != null && w.child == null,
                ),
              )
              .first,
        );
        expect(gap.width, oracleTabItemIconGap);
      },
    );

    testWidgets(
      'ACCEPTED DEVIATION: the label weight is the type scale (w600), not '
      "production's hardcoded w500 — see specTabLabelFontWeight",
      (tester) async {
        // Rendered inside a bar because the weight now arrives through the
        // tab theme; a standalone item has nothing to inherit from.
        final controller = TabController(length: 1, vsync: tester);
        addTearDown(controller.dispose);
        await tester.pumpApp(
          FlowinTabs(
            controller: controller,
            tabs: const [FlowinTabItem(label: 'Tab', icon: Icon(Icons.circle))],
          ),
        );

        final style = tester
            .renderObject<RenderParagraph>(find.text('Tab'))
            .text
            .style!;
        expect(style.fontSize, oracleTabLabelFontSize);
        expect(style.fontWeight, specTabLabelFontWeight);
        // The divergence from production is deliberate, not drift.
        expect(specTabLabelFontWeight, isNot(oracleTabLabelFontWeight));
      },
    );

    test(
      'ACCEPTED DEVIATION: labelPadding is tightened to space100 per side, '
      'unlike production (which inherits Material kTabLabelPadding 16) — see '
      'oracleTabLabelPaddingPerSide',
      () {
        expect(oracleTabLabelPaddingPerSide, 16.0);
        expect(
          light.tabBarTheme.labelPadding,
          const EdgeInsets.symmetric(
            horizontal: flowinTabLabelPaddingPerSide,
          ),
        );
      },
    );

    testWidgets(
      'the tightened padding recovers label width at the showcase size: '
      '"Board" fits a 328pt 3-tab bar (test-font width 70pt vs the 49.3pt '
      'production leaves; 73.3pt after the fix)',
      (tester) async {
        await tester.pumpApp(
          DefaultTabController(
            length: 3,
            child: Builder(
              builder: (context) => Center(
                child: SizedBox(
                  width: 328,
                  child: FlowinTabs(
                    controller: DefaultTabController.of(context),
                    tabs: const [
                      FlowinTabItem(label: 'Home', icon: Icon(Icons.circle)),
                      FlowinTabItem(label: 'Board', icon: Icon(Icons.circle)),
                      FlowinTabItem(
                        label: 'Settings',
                        icon: Icon(Icons.circle),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        // The test font renders glyphs at fontSize width, so "Board" needs
        // 5 × 14 = 70pt — more than production's 49.3pt, within the 73.3pt
        // the tightened padding recovers. (Red with kTabLabelPadding.)
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text('Board'),
        );
        expect(paragraph.didExceedMaxLines, isFalse);
      },
    );

    testWidgets(
      'ACCEPTED DEVIATION: tabs pass through unchanged, unlike production '
      '(FDTabs rebuilds each item to inject height and label style) — see '
      'oracleTabsRebuildTheirItems',
      (tester) async {
        expect(oracleTabsRebuildTheirItems, isTrue);

        const tab = FlowinTabItem(label: 'Tab', icon: Icon(Icons.circle));
        await tester.pumpApp(
          DefaultTabController(
            length: 1,
            child: Builder(
              builder: (context) => FlowinTabs(
                controller: DefaultTabController.of(context),
                tabs: const [tab],
              ),
            ),
          ),
        );
        expect(
          tester.widget<FlowinTabItem>(find.byType(FlowinTabItem)),
          same(tab),
        );
      },
    );
  });

  group('fidelity: FlowinAppBar', () {
    test('bar metrics match production', () {
      expect(kFlowinAppBarHeight, oracleAppBarHeight);
      expect(kFlowinAppBarContentSize, oracleAppBarContentMin);
      expect(kFlowinAppBarPadding, oracleAppBarPadding);
    });

    testWidgets(
      'ACCEPTED DEVIATION: the bar owns its status-bar inset, unlike '
      'production (which delegates it to the app) — see '
      'oracleAppBarOwnsStatusBarInset',
      (tester) async {
        // Production behavior, still reachable via primary: false.
        expect(oracleAppBarOwnsStatusBarInset, isFalse);

        const inset = 59.0;
        await tester.pumpWidget(
          const MediaQuery(
            data: MediaQueryData(padding: EdgeInsets.only(top: inset)),
            child: MaterialApp(
              home: Scaffold(appBar: FlowinAppBar(child: Text('T'))),
            ),
          ),
        );

        // flutter_flowin's default: inset applied by the widget...
        expect(tester.getRect(find.text('T')).top, greaterThanOrEqualTo(inset));
        // ...while preferredSize stays production's height, so Scaffold's own
        // inset is not double-counted.
        const bar = FlowinAppBar(child: Text('T'));
        expect(bar.preferredSize.height, oracleAppBarHeight);
      },
    );

    testWidgets(
      'footer pins to the bar bottom like production '
      '(fd_app_bar.dart Positioned(bottom: 0))',
      (tester) async {
        await tester.pumpApp(
          const FlowinAppBar(
            footer: SizedBox(height: 2, key: Key('footer')),
            child: Text('T'),
          ),
        );
        final barRect = tester.getRect(find.byType(FlowinAppBar));
        final footerRect = tester.getRect(find.byKey(const Key('footer')));
        expect(footerRect.bottom, barRect.bottom);
        expect(footerRect.left, barRect.left);
        expect(footerRect.right, barRect.right);
      },
    );

    testWidgets(
      'leading/trailing slots reserve a square space1200 minimum like '
      'production (_AppBarSquareContainer)',
      (tester) async {
        await tester.pumpApp(
          const FlowinAppBar(
            leading: SizedBox.square(dimension: 4, key: Key('lead')),
            trailing: SizedBox.square(dimension: 4, key: Key('trail')),
            child: Text('T'),
          ),
        );
        for (final key in const [Key('lead'), Key('trail')]) {
          final slot = tester.getSize(
            find
                .ancestor(
                  of: find.byKey(key),
                  matching: find.byType(ConstrainedBox),
                )
                .first,
          );
          expect(slot.width, greaterThanOrEqualTo(oracleAppBarContentMin));
          expect(slot.height, greaterThanOrEqualTo(oracleAppBarContentMin));
        }
      },
    );

    testWidgets(
      'center child expands to fill the space between the slots like '
      'production (Expanded vs Spacer)',
      (tester) async {
        await tester.pumpApp(
          const FlowinAppBar(
            leading: Icon(Icons.menu),
            trailing: Icon(Icons.add),
            child: ColoredBox(color: Colors.transparent, key: Key('center')),
          ),
        );
        final barRect = tester.getRect(find.byType(FlowinAppBar));
        final centerRect = tester.getRect(find.byKey(const Key('center')));
        // Bar width − side padding (space200 × 2) − two space1200 slots.
        expect(
          centerRect.width,
          barRect.width - 2 * kFlowinAppBarPadding - 2 * oracleAppBarContentMin,
        );
      },
    );
  });

  group('fidelity: FlowinTabAppBar', () {
    Widget buildBar() => DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) => FlowinTabAppBar(
          controller: DefaultTabController.of(context),
          tabs: const [
            Tab(text: 'A'),
            Tab(text: 'B'),
          ],
        ),
      ),
    );

    testWidgets(
      'footer divider is a 1px hairline like production '
      '(fd_tab_app_bar.dart:33-42, height == thickness == borders.regular)',
      (tester) async {
        await tester.pumpApp(buildBar());
        final divider = tester.widget<Divider>(find.byType(Divider));
        expect(divider.height, oracleTabAppBarDividerThickness);
        expect(divider.thickness, oracleTabAppBarDividerThickness);
      },
    );

    testWidgets(
      'divider color resolves to outlineVariant like production '
      '(fd_tab_app_bar.dart:34 — here via the divider theme fallback)',
      (tester) async {
        await tester.pumpApp(buildBar());
        final divider = tester.widget<Divider>(find.byType(Divider));
        expect(
          divider.color ?? light.dividerTheme.color,
          scheme.outlineVariant,
        );
      },
    );

    testWidgets('preferredSize matches the production bar height', (
      tester,
    ) async {
      await tester.pumpApp(buildBar());
      final bar = tester.widget<FlowinTabAppBar>(find.byType(FlowinTabAppBar));
      expect(bar.preferredSize.height, oracleAppBarHeight);
    });
  });

  group('fidelity: input fields', () {
    test('container metrics match production', () {
      expect(kFlowinInputFieldMinHeight, oracleInputFieldHeight);
      expect(
        kFlowinInputFieldContentMaxHeight,
        oracleInputFieldContentMaxHeight,
      );
    });

    testWidgets('text field hint binds bodyLarge + onSurfaceVariant', (
      tester,
    ) async {
      await tester.pumpApp(
        const FlowinTextField(hintText: 'Hint'),
      );
      final hintStyle = light.inputDecorationTheme.hintStyle!;
      expect(hintStyle.fontSize, light.textTheme.bodyLarge!.fontSize);
      expect(hintStyle.color, scheme.onSurfaceVariant);
    });

    testWidgets(
      'text field defaults to a single line like production '
      '(fd_text_field.dart maxLines: 1)',
      (tester) async {
        await tester.pumpApp(const FlowinTextField(hintText: 'Hint'));
        const field = FlowinTextField(hintText: 'Hint');
        expect(field.maxLines, oracleTextFieldMaxLines);
        expect(
          tester.widget<TextField>(find.byType(TextField)).maxLines,
          oracleTextFieldMaxLines,
        );
      },
    );
  });

  // Production's FDInputField is the STACKED labelled field, so its
  // counterpart is FlowinLabeledTextField — see oracleLabeledTextFieldGap.
  group('fidelity: FlowinLabeledTextField (= production FDInputField)', () {
    testWidgets('stacks the label above the field like production', (
      tester,
    ) async {
      await tester.pumpApp(
        const FlowinLabeledTextField(label: 'Name', hintText: 'h'),
      );

      final labelBottom = tester.getRect(find.text('Name')).bottom;
      final fieldTop = tester.getRect(find.byType(FlowinTextField)).top;
      expect(fieldTop, greaterThanOrEqualTo(labelBottom));
    });

    testWidgets('label→field gap matches production spacing (space200)', (
      tester,
    ) async {
      await tester.pumpApp(
        const FlowinLabeledTextField(label: 'Name', hintText: 'h'),
      );

      final gap = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(FlowinLabeledTextField),
              matching: find.byWidgetPredicate(
                (w) => w is SizedBox && w.height != null && w.child == null,
              ),
            )
            .first,
      );
      expect(gap.height, oracleLabeledTextFieldGap);
    });

    testWidgets('label binds labelMedium + onSurface like production', (
      tester,
    ) async {
      await tester.pumpApp(
        const FlowinLabeledTextField(label: 'Name', hintText: 'h'),
      );

      final style = tester.widget<Text>(find.text('Name')).style;
      expect(style?.fontSize, light.textTheme.labelMedium!.fontSize);
      expect(style?.color, scheme.onSurface);
    });
  });

  // SPEC-ONLY: the stacked generic primitive has no production predecessor
  // (production's FDInputField is the SIDEBAR field, retired 2026-08-04), so
  // these pin the v1 contract (design/components/input-field.md) instead.
  group('fidelity: FlowinInputField (spec-only stacked primitive)', () {
    testWidgets('stacks the label above the child, not beside it', (
      tester,
    ) async {
      await tester.pumpApp(
        const FlowinInputField(
          label: 'Email',
          child: FlowinTextField(hintText: 'h'),
        ),
      );

      final labelRect = tester.getRect(find.text('Email'));
      final childRect = tester.getRect(find.byType(FlowinTextField));
      // Stacked: the child sits wholly below the label.
      expect(childRect.top, greaterThanOrEqualTo(labelRect.bottom));
    });

    test('dimensional contract matches the v1 spec', () {
      expect(kFlowinInputFieldMinHeight, specInputFieldSurfaceMinHeight);
      expect(kFlowinInputFieldContentMaxHeight, specInputFieldContentRowHeight);
      expect(kFlowinInputFieldLabelGap, specInputFieldLabelGap);
    });

    testWidgets(
      'ACCEPTED DEVIATION: no sidebar — the label column and vertical divider '
      'are gone (see specInputFieldSidebarRetired)',
      (tester) async {
        expect(specInputFieldSidebarRetired, isTrue);

        await tester.pumpApp(
          const FlowinInputField(
            label: 'Email',
            child: FlowinTextField(hintText: 'h'),
          ),
        );

        expect(find.byType(VerticalDivider), findsNothing);
      },
    );

    testWidgets('border resolves from the global subtle-border role', (
      tester,
    ) async {
      const overridden = Color(0xFF00FF00);
      await tester.pumpApp(
        const FlowinInputField(
          label: 'Email',
          child: FlowinTextField(hintText: 'h'),
        ),
        theme: FlowinTheme.light.copyWith(
          colorScheme: FlowinTheme.light.colorScheme.copyWith(
            outlineVariant: overridden,
          ),
        ),
      );

      final card = tester.widget<FlowinCard>(find.byType(FlowinCard).first);
      expect(card.borderSide.color, overridden);
    });
  });

  group('fidelity: FlowinActionSheet', () {
    testWidgets('sheet card metrics match production', (tester) async {
      await tester.pumpApp(
        const FlowinActionSheet(title: 'Sheet'),
      );
      final card = tester.widget<FlowinCard>(find.byType(FlowinCard).first);
      expect(card.margin, oracleSheetMargin);
      expect(card.backgroundColor, scheme.surface);
      expect(card.padding!.vertical, oracleSheetBottomPadding);
      // The sheet pins its own radius rather than inheriting the card's
      // theme-resolved one, so this is non-null by construction.
      expect(card.borderRadius!.topLeft, oracleSheetRadius);
      expect(card.borderRadius!.bottomRight, oracleSheetRadius);
    });

    testWidgets(
      'header/body/footer share the space600 content inset like production '
      '(fd_action_sheet.dart:72-103)',
      (tester) async {
        await tester.pumpApp(
          const FlowinActionSheet(
            title: 'Sheet',
            body: Text('Body'),
            footer: Text('Footer'),
          ),
        );
        final sheet = find.byType(FlowinActionSheet);
        Finder padded(EdgeInsets insets) => find.descendant(
          of: sheet,
          matching: find.byWidgetPredicate(
            (w) => w is Padding && w.padding == insets,
          ),
        );

        // Header: top/left/right; body and footer: horizontal.
        expect(
          padded(
            const EdgeInsets.only(
              top: oracleSheetContentInset,
              left: oracleSheetContentInset,
              right: oracleSheetContentInset,
            ),
          ),
          findsOneWidget,
        );
        expect(
          padded(
            const EdgeInsets.symmetric(horizontal: oracleSheetContentInset),
          ),
          findsNWidgets(2),
        );
      },
    );

    testWidgets('column spacing matches production (space400)', (
      tester,
    ) async {
      await tester.pumpApp(
        const FlowinActionSheet(title: 'Sheet', body: Text('Body')),
      );
      final column = tester.widget<Column>(
        find
            .descendant(
              of: find.byType(FlowinActionSheet),
              matching: find.byType(Column),
            )
            .first,
      );
      expect(column.spacing, oracleSheetColumnSpacing);
    });

    testWidgets('footer row gap matches production (space300)', (
      tester,
    ) async {
      await tester.pumpApp(
        FlowinActionSheetFooter(
          left: FlowinButton(onPressed: () {}, label: 'A'),
          right: FlowinButton(onPressed: () {}, label: 'B'),
        ),
      );
      final row = tester.widget<Row>(
        find
            .descendant(
              of: find.byType(FlowinActionSheetFooter),
              matching: find.byType(Row),
            )
            .first,
      );
      expect(row.spacing, oracleSheetFooterSpacing);
    });

    testWidgets(
      'close button is a tonal xs (32) icon button with an sm (16) icon like '
      'production (fd_action_sheet_header.dart:52-58)',
      (tester) async {
        await tester.pumpApp(const FlowinActionSheet(title: 'Sheet'));
        final style = tester.widget<IconButton>(find.byType(IconButton)).style!;
        expect(
          style.fixedSize!.resolve({}),
          const Size.square(oracleSheetCloseButtonSize),
        );
        final button = tester.widget<IconButton>(find.byType(IconButton));
        expect(button.iconSize, oracleSheetCloseIconSize);
      },
    );

    testWidgets(
      'modal clamps to 480 on wide viewports like production '
      '(fd_action_sheet_utils.dart:26-36) and fills narrow ones',
      (tester) async {
        tester.view.physicalSize = const Size(800, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        Widget host() => MaterialApp(
          theme: light,
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: FlowinButton(
                  label: 'Open',
                  onPressed: () => showFlowinActionSheet<void>(
                    context: context,
                    builder: (_) => const FlowinActionSheet(title: 'Sheet'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpWidget(host());
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byType(FlowinActionSheet)).width,
          oracleSheetMaxWidth,
        );

        // Narrow viewport: the sheet fills the width instead.
        tester.view.physicalSize = const Size(400, 600);
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(host());
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(tester.getSize(find.byType(FlowinActionSheet)).width, 400);
      },
    );

    testWidgets(
      'ACCEPTED DEVIATION: the subtitle renders without a header icon, which '
      'production drops (fd_action_sheet_header.dart:89-93 gates the whole '
      'title/subtitle block on hasIcon)',
      (tester) async {
        // Production accepts a subtitle and an icon independently, but only
        // ever renders the subtitle inside the block it shows when an icon is
        // present. A sheet given a subtitle and no icon therefore renders
        // nothing for it — the caller's text vanishes with no error.
        //
        // Treated as a defect in the oracle rather than a contract to port:
        // the showcase's own "Title & subtitle only" demo hits exactly this
        // case. A conformance pass comparing against the legacy package WILL
        // find this difference; it is intended.
        await tester.pumpApp(
          const FlowinActionSheet(title: 'Title', subtitle: 'Subtitle'),
        );
        expect(find.text('Subtitle'), findsOneWidget);
      },
    );
  });

  group('fidelity: FlowinCard', () {
    test('squircle smoothing matches production iOSSmooth', () {
      final radius = const FlowinCardBorderRadius.all(
        16,
      ).toSmoothBorderRadius();
      expect(radius.topLeft.cornerSmoothing, oracleCardCornerSmoothing);
    });

    testWidgets('default background binds to secondaryContainer', (
      tester,
    ) async {
      await tester.pumpApp(
        Theme(
          data: light.copyWith(cardTheme: const CardThemeData()),
          child: const FlowinCard(child: SizedBox()),
        ),
      );
      final decorated = tester.widget<Container>(
        find.descendant(
          of: find.byType(FlowinCard),
          matching: find.byType(Container),
        ),
      );
      final decoration = decorated.decoration! as ShapeDecoration;
      expect(decoration.color, scheme.secondaryContainer);
    });
  });

  group('fidelity: FlowinColorRadialButton', () {
    testWidgets(
      'default swatch diameter is space700 (28) like production '
      '(fd_color_radial_button.dart:9)',
      (tester) async {
        await tester.pumpApp(
          const FlowinColorRadialButton(color: Colors.red),
        );
        expect(
          tester.getSize(find.byType(FlowinColorRadialButton)),
          const Size.square(oracleColorRadialSize),
        );
      },
    );

    test('ring geometry defaults match production tokens', () {
      const button = FlowinColorRadialButton(color: Colors.red);
      expect(button.size, oracleColorRadialSize);
      expect(button.borderWidth, oracleColorRadialBorderWidth);
      expect(button.gapWidth, oracleColorRadialGapWidth);
    });

    testWidgets(
      'selected ring leaves a borderWidth-wide colored ring, with the gap '
      'carved out rather than painted (fd_color_radial_button.dart:11-13)',
      (tester) async {
        await tester.pumpApp(
          const FlowinColorRadialButton(color: Colors.red, selected: true),
        );

        // The oracle painted the gap in `surface`, which is why a swatch that
        // matched the surface lost its ring. The geometry it specified still
        // holds — the gap's outer edge sits borderWidth in from the swatch
        // edge — but the gap is now carved out, so the background shows
        // through instead of a painted circle. Nothing may paint over the
        // swatch to fake it.
        final painted = find.descendant(
          of: find.byType(FlowinColorRadialButton),
          matching: find.byWidgetPredicate(
            (w) =>
                w is DecoratedBox &&
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).color == scheme.surface,
          ),
        );
        expect(painted, findsNothing);

        expect(
          tester.getSize(find.byType(FlowinColorRadialButton)),
          const Size.square(oracleColorRadialSize),
        );
      },
    );
  });

  group('fidelity: FlowinColorPickerField / FlowinInlineColorPicker', () {
    const colors = [Colors.red, Colors.green, Colors.blue];

    Widget buildPicker() => FlowinInlineColorPicker(
      predefinedColors: colors,
      onCustomColorTap: () {},
      onPredefinedColorTap: (_) {},
    );

    testWidgets(
      'row height is space1000 (40) like production '
      '(fd_color_picker_field.dart:151)',
      (tester) async {
        await tester.pumpApp(buildPicker());
        expect(
          tester.getSize(find.byType(FlowinInlineColorPicker)).height,
          oracleColorPickerRowHeight,
        );
      },
    );

    testWidgets(
      'swatch gap is space400 (16) like production, both in the row and '
      'between predefined swatches (fd_color_picker_field.dart:153-161)',
      (tester) async {
        await tester.pumpApp(buildPicker());
        final row = tester.widget<Row>(
          find
              .descendant(
                of: find.byType(FlowinInlineColorPicker),
                matching: find.byType(Row),
              )
              .first,
        );
        expect(row.spacing, oracleColorPickerRowSpacing);

        final separator = find.descendant(
          of: find.byType(FlowinInlineColorPicker),
          matching: find.byWidgetPredicate(
            (w) =>
                w is SizedBox &&
                w.width == oracleColorPickerRowSpacing &&
                w.child == null,
          ),
        );
        expect(separator, findsWidgets);
      },
    );

    ShapeDecoration? swatchShadowDecoration(WidgetTester tester) {
      final decorated = find.descendant(
        of: find.byType(FlowinInlineColorPicker),
        matching: find.byWidgetPredicate(
          (w) =>
              w is Container &&
              w.decoration is ShapeDecoration &&
              (w.decoration! as ShapeDecoration).shadows != null,
        ),
      );
      if (decorated.evaluate().isEmpty) return null;
      return tester.widget<Container>(decorated.first).decoration!
          as ShapeDecoration;
    }

    testWidgets(
      'predefined swatches carry the shadow10 hairline in light themes like '
      'production (fd_color_picker_field.dart:146-149 — neutral200 @ '
      'spreadRadius 1)',
      (tester) async {
        await tester.pumpApp(buildPicker());
        final decoration = swatchShadowDecoration(tester);
        expect(decoration, isNotNull, reason: 'no shadowed swatch wrapper');
        final shadow = decoration!.shadows!.single;
        expect(shadow.color, FlowinDesignColors.neutral200);
        expect(shadow.spreadRadius, oracleSwatchShadowSpread);
      },
    );

    testWidgets(
      'swatch shadow resolves to outlineVariant in dark themes like '
      'production (themedShadow10)',
      (tester) async {
        await tester.pumpApp(buildPicker(), theme: FlowinTheme.dark);
        final decoration = swatchShadowDecoration(tester);
        expect(decoration, isNotNull, reason: 'no shadowed swatch wrapper');
        final shadow = decoration!.shadows!.single;
        expect(shadow.color, FlowinTheme.dark.colorScheme.outlineVariant);
        expect(shadow.spreadRadius, oracleSwatchShadowSpread);
      },
    );
  });
}
