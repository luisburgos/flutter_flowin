import 'package:flowin_showcase/catalogue.dart';
import 'package:flowin_showcase/pages/navigation_page.dart';
import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

/// Components the showcase must render on some page.
///
/// The showcase is the only catalogue since the widgetbook was retired. This
/// list pins what it currently covers, so a component cannot silently fall out
/// of it — the failure mode that rotted the widgetbook, where `flowin_tab_item`
/// lost its use case and nothing noticed (flowin_pm#10).
///
/// Compares by *type*, not by count. Matching totals are what hid that drift:
/// one use case had been lost and an unrelated one added, so the numbers agreed
/// at 16 vs 16 while the catalogue was wrong.
///
/// **This list is hand-maintained, so it catches regression, not omission.** A
/// newly exported component is simply absent from it, and nothing looks for it
/// — that still relies on review. Closing that gap needs the expected list
/// derived from the package source rather than written by hand.
final _catalogued = <Type>[
  FlowinAppBar,
  FlowinButton,
  FlowinCard,
  FlowinChip,
  FlowinChipGroup,
  FlowinChipGroupViewPager,
  FlowinColorPickerField,
  FlowinColorRadialButton,
  FlowinIconButton,
  FlowinInputField,
  FlowinItemButton,
  FlowinLabeledTextField,
  FlowinTabAppBar,
  FlowinTabItem,
  FlowinTabs,
  FlowinTextField,
];

/// Exported widgets deliberately outside the sweep, each with its reason.
///
/// Listing them means an unexplained omission cannot hide as a silent gap in
/// [_catalogued]: a component is either swept, or named here with a
/// justification a reviewer can disagree with.
const _deliberatelyUncatalogued = <String, String>{
  'FlowinActionSheet':
      'Modal — it exists only after something opens it, so a static sweep '
      'cannot see it. Driving the triggers would couple this test to which '
      'showcase widget opens which sheet. The Action sheets page does '
      'catalogue it, and the package covers the widget directly in '
      'flowin_action_sheet_test.dart (21 tests).',
  'FlowinActionSheetFooter':
      'Rendered inside a modal FlowinActionSheet; same reasoning, same tests.',
  'FlowinActionSheetHeader':
      'Internal to FlowinActionSheet; never built directly by a consumer.',
  'FlowinInlineColorPicker':
      'The row inside FlowinColorPickerField; swept through that widget.',
};

void main() {
  group('catalogue coverage', () {
    testWidgets('every catalogued component renders on some page', (
      tester,
    ) async {
      // Entry pages, plus the nested demo pages they route to. A component
      // catalogued one tap deep is still catalogued, so the sweep reaches them.
      final builders = <WidgetBuilder>[
        for (final entry in [...componentEntries, ...exampleEntries])
          entry.builder,
        (_) => const AppBarDemoPage(),
        (_) => const TabAppBarDemoPage(),
        (_) => const TabsDemoPage(),
      ];

      final seen = <Type>{};

      for (final builder in builders) {
        await tester.pumpWidget(
          ThemeModeScope(
            notifier: ThemeModeController(),
            child: MaterialApp(
              theme: FlowinTheme.light,
              home: Builder(builder: builder),
            ),
          ),
        );
        await tester.pumpAndSettle();

        seen.addAll(
          _catalogued.where((t) => find.byType(t).evaluate().isNotEmpty),
        );
      }

      final missing = _catalogued.where((t) => !seen.contains(t)).toList();

      expect(
        missing,
        isEmpty,
        reason:
            'These exported components appear on no showcase page: $missing. '
            'Add each to the page it belongs on, or record it in '
            '_deliberatelyUncatalogued with a reason.',
      );
    });

    test('the deliberate exclusions carry a stated reason', () {
      for (final entry in _deliberatelyUncatalogued.entries) {
        expect(
          entry.value.trim(),
          isNotEmpty,
          reason: '${entry.key} is excluded without a stated reason',
        );
      }
    });
  });
}
