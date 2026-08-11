import 'dart:io';

import 'package:flowin_showcase/catalogue.dart';
import 'package:flowin_showcase/pages/navigation/app_bar_demos.dart';
import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

/// Where a component lives in the catalogue, and how to make it render there.
class _Home {
  const _Home(this.page, {this.prepare});

  /// The page that owns the component — a catalogue entry title, or a key in
  /// [_nestedPages] for the demos an entry routes to.
  final String page;

  /// Drives the page to the state where the component renders, for a subject
  /// reached through a preset rather than built on first frame.
  final Future<void> Function(WidgetTester tester)? prepare;
}

/// Every exported package widget, mapped to the page that owns it.
///
/// The showcase is the only catalogue since the widgetbook was retired
/// (flowin_pm#10). Two properties this map enforces, each closing a hole the
/// previous sweep measurably had:
///
/// - **Ownership, not existence.** The old sweep asked whether a type rendered
///   on *some* page, so deleting the whole Cards entry passed — FlowinCard
///   still rendered in other pages' previews and in the entry tiles. Each
///   component now asserts against the page that owns it, and a missing page
///   fails by name.
/// - **Derived, not hand-trusted.** The companion test resolves the package's
///   export graph and requires every exported widget to appear here or in
///   [_deliberatelyUncatalogued]. A newly exported component fails the suite
///   until it is catalogued or excluded with a reason — the omission the old
///   list could never see. That derivation is what surfaced FDIcon and
///   FDSvgIcon, both public API and both absent from the old pinned list —
///   FDIcon got catalogued, FDSvgIcon retired (flowin_pm#34).
final _homes = <Type, _Home>{
  FlowinAppBar: const _Home('App bars → FlowinAppBar'),
  FlowinTabAppBar: const _Home('App bars → FlowinTabAppBar'),
  FlowinButton: const _Home('Buttons'),
  FlowinIconButton: const _Home('Icon buttons'),
  FlowinItemButton: const _Home('Item buttons'),
  FlowinChip: const _Home('Chips'),
  FlowinChipGroup: const _Home('Chip groups'),
  FlowinChipGroupViewPager: const _Home('Chip view pagers'),
  FlowinInputField: const _Home('Input fields'),
  FlowinTextField: const _Home('Text fields'),
  FlowinLabeledTextField: const _Home('Text fields'),
  FlowinCard: const _Home('Cards & surfaces'),
  FlowinColorRadialButton: const _Home('Colour swatches'),
  FlowinColorPickerField: _Home(
    'Colour swatches',
    // The picker field is a playground subject reached through a preset; the
    // page opens on the primitive. Tapping the preset is the reader's own
    // path to it, so the coupling to the label is the coupling the page has.
    prepare: (tester) async {
      await tester.tap(find.text('In a form'));
      await tester.pumpAndSettle();
    },
  ),
  FlowinTabs: const _Home('Tabs'),
  FlowinTabItem: const _Home('Tabs'),
  FDIcon: const _Home('Icons'),
};

/// Framework widgets the catalogue documents as its own subjects.
///
/// Not package exports, so they sit outside the derivation test — but their
/// pages are catalogue entries all the same, and the old sweep could not see
/// the Dividers entry disappear because `Divider` was never a pinned type.
final _frameworkHomes = <Type, _Home>{
  Divider: const _Home('Dividers'),
  VerticalDivider: const _Home('Dividers'),
};

/// Exported widgets deliberately outside the sweep, each with its reason.
///
/// Listing them means an unexplained omission cannot hide: the derivation test
/// requires every exported widget to be swept or named here with a
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

/// The demo pages an entry routes to rather than builds inline.
///
/// Only the two app bars still need this: they can only be demonstrated as a
/// real Scaffold.appBar, so their entry page routes to them.
final _nestedPages = <String, (String parentEntry, WidgetBuilder builder)>{
  'App bars → FlowinAppBar': ('App bars', (_) => const AppBarDemoPage()),
  'App bars → FlowinTabAppBar': (
    'App bars',
    (_) => const TabAppBarDemoPage(),
  ),
};

/// Every public widget class reachable from the package's barrel file.
///
/// Resolved by following `export` directives from lib/flutter_flowin.dart
/// through package-internal files (the foundations barrel re-exports its
/// tokens), then matching public StatelessWidget/StatefulWidget declarations.
/// Public-in-file classes whose file is never exported — the action-sheet
/// header sub-pieces — are correctly invisible, because a consumer cannot
/// reach them either.
///
/// `show`/`hide` combinators are honoured: an edge's filter applies to
/// everything visible through it, including what the child re-exports, which
/// matches how the language resolves them.
Set<String> _exportedWidgetNames() {
  final barrel = File('../lib/flutter_flowin.dart');
  expect(
    barrel.existsSync(),
    isTrue,
    reason: 'expected to run from the showcase package directory',
  );

  final exportRe = RegExp(
    r"^export\s+'([^']+)'\s*(?:(show|hide)\s+([^;]+))?;",
    multiLine: true,
  );
  final classRe = RegExp(
    r'^class\s+(\w+)(?:<[^>]*>)?\s+extends\s+(?:StatelessWidget|StatefulWidget)\b',
    multiLine: true,
  );

  // Everything a file makes visible: its own public widget classes plus what
  // its exports let through. Memoised per file; the in-progress guard turns
  // an export cycle into an empty contribution rather than a hang.
  final memo = <String, Set<String>>{};
  final visiting = <String>{};

  Set<String> visibleFrom(File file) {
    final path = file.uri.normalizePath().toFilePath();
    final cached = memo[path];
    if (cached != null) return cached;
    if (!visiting.add(path)) return const {};

    final source = file.readAsStringSync();
    final names = <String>{};
    for (final match in classRe.allMatches(source)) {
      final name = match.group(1)!;
      if (!name.startsWith('_')) names.add(name);
    }
    for (final match in exportRe.allMatches(source)) {
      final target = match.group(1)!;
      if (target.startsWith('package:')) continue;

      var through = visibleFrom(File('${file.parent.path}/$target'));
      final combinator = match.group(2);
      if (combinator != null) {
        final listed = match
            .group(3)!
            .split(',')
            .map((n) => n.trim())
            .where((n) => n.isNotEmpty)
            .toSet();
        through = combinator == 'show'
            ? through.intersection(listed)
            : through.difference(listed);
      }
      names.addAll(through);
    }

    visiting.remove(path);
    return memo[path] = names;
  }

  return visibleFrom(barrel);
}

void main() {
  group('catalogue coverage', () {
    test('every exported widget is catalogued or excluded with a reason', () {
      final exported = _exportedWidgetNames();
      final catalogued = _homes.keys.map((t) => t.toString()).toSet();
      final excluded = _deliberatelyUncatalogued.keys.toSet();

      expect(
        exported.difference(catalogued.union(excluded)),
        isEmpty,
        reason:
            'These exported widgets are neither catalogued nor excluded. Map '
            'each to its home page in _homes, or record it in '
            '_deliberatelyUncatalogued with a reason.',
      );
      expect(
        catalogued.union(excluded).difference(exported),
        isEmpty,
        reason:
            'These names are pinned or excluded but no longer exported by the '
            'package — remove the stale entries.',
      );
    });

    testWidgets('every component renders on the page that owns it', (
      tester,
    ) async {
      // Wide, so playgrounds split and their preset lists are on screen for
      // the prepare steps.
      await tester.binding.setSurfaceSize(const Size(1400, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final entryPages = <String, WidgetBuilder>{
        for (final entry in [
          ...componentEntries,
          ...foundationEntries,
          ...exampleEntries,
        ])
          entry.title: entry.builder,
      };

      // A nested demo is only reachable through its parent entry, so the
      // parent disappearing orphans it even though the builder still exists.
      for (final nested in _nestedPages.values) {
        expect(
          entryPages,
          contains(nested.$1),
          reason:
              'the ${nested.$1} entry routes to a nested demo and has been '
              'removed from the catalogue',
        );
      }

      for (final entry in {..._homes, ..._frameworkHomes}.entries) {
        final component = entry.key;
        final home = entry.value;
        final builder = entryPages[home.page] ?? _nestedPages[home.page]?.$2;

        expect(
          builder,
          isNotNull,
          reason:
              '$component is catalogued on "${home.page}", which no longer '
              'exists — the entry was removed or renamed without moving its '
              'components',
        );

        await tester.pumpWidget(
          ThemeModeScope(
            notifier: ThemeModeController(),
            child: MaterialApp(
              theme: FlowinTheme.light,
              home: Builder(builder: builder!),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await home.prepare?.call(tester);

        expect(
          find.byType(component).evaluate(),
          isNotEmpty,
          reason:
              '$component no longer renders on "${home.page}", the page that '
              'owns it. Restore it there, or move it and update _homes.',
        );
      }
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
