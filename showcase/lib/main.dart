import 'package:flowin_showcase/app_info/app_version_label.dart';
import 'package:flowin_showcase/pages/buttons_page.dart';
import 'package:flowin_showcase/pages/cards_page.dart';
import 'package:flowin_showcase/pages/chips_page.dart';
import 'package:flowin_showcase/pages/form_page.dart';
import 'package:flowin_showcase/pages/foundations/colors_page.dart';
import 'package:flowin_showcase/pages/foundations/icons/icons_page.dart';
import 'package:flowin_showcase/pages/foundations/radius_page.dart';
import 'package:flowin_showcase/pages/foundations/spacing_page.dart';
import 'package:flowin_showcase/pages/foundations/typography_page.dart';
import 'package:flowin_showcase/pages/navigation_page.dart';
import 'package:flowin_showcase/pages/profile_example_page.dart';
import 'package:flowin_showcase/pages/sheets/sheets_page.dart';
import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

void main() => runApp(const ShowcaseApp());

/// The showcase application root.
///
/// Uses [FlowinTheme] for both brightness modes so every page below renders
/// through the real design system, not an approximation of it.
class ShowcaseApp extends StatefulWidget {
  /// {@macro showcase_app}
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  final _themeMode = ThemeModeController();

  @override
  void dispose() {
    _themeMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The scope sits above MaterialApp so every route — including pushed
    // pages — resolves the same controller.
    return ThemeModeScope(
      notifier: _themeMode,
      child: ListenableBuilder(
        listenable: _themeMode,
        builder: (context, _) => MaterialApp(
          title: 'Flowin Showcase',
          debugShowCheckedModeBanner: false,
          theme: FlowinTheme.light,
          darkTheme: FlowinTheme.dark,
          themeMode: _themeMode.value,
          home: const HomePage(),
        ),
      ),
    );
  }
}

/// A single entry in the showcase index.
class ShowcaseEntry {
  /// {@macro showcase_entry}
  const ShowcaseEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.builder,
  });

  /// The page title.
  final String title;

  /// A one-line description of what the page covers.
  final String subtitle;

  /// The leading semantic icon.
  final FDIcons icon;

  /// Builds the destination page.
  final WidgetBuilder builder;
}

/// The design tokens every component is built from.
///
/// Separated from [componentEntries] because a token is not a widget: these
/// pages answer "what values exist" rather than "what can I place on a
/// screen", and mixing the two makes both harder to scan.
final foundationEntries = <ShowcaseEntry>[
  ShowcaseEntry(
    title: 'Typography',
    subtitle: 'Baseline (Inter) and brand (Supreme) type scales',
    icon: FDIcons.edit,
    builder: (_) => const TypographyPage(),
  ),
  ShowcaseEntry(
    title: 'Colors',
    subtitle: 'The palette mapped onto Material ColorScheme roles',
    icon: FDIcons.paint,
    builder: (_) => const ColorsPage(),
  ),
  ShowcaseEntry(
    title: 'Spacing',
    subtitle: 'Semantic steps read from context.spacing',
    icon: FDIcons.arrowRightLeft,
    builder: (_) => const SpacingPage(),
  ),
  ShowcaseEntry(
    title: 'Radius',
    subtitle: 'The corner-radius scale',
    icon: FDIcons.board,
    builder: (_) => const RadiusPage(),
  ),
  ShowcaseEntry(
    title: 'Icons',
    subtitle: 'The semantic set, at any step of the size scale',
    icon: FDIcons.setNeutral,
    builder: (_) => const IconsPage(),
  ),
];

/// The component catalogue — one entry per widget family.
///
/// Filed by what a thing *is*, not what it is used for, so a reader who arrives
/// with a component name in hand finds it where they expect. Realistic
/// compositions live in [exampleEntries] instead.
final componentEntries = <ShowcaseEntry>[
  ShowcaseEntry(
    title: 'Buttons',
    subtitle: 'Button, IconButton, ItemButton — all variants and sizes',
    icon: FDIcons.done,
    builder: (_) => const ButtonsPage(),
  ),
  ShowcaseEntry(
    title: 'Chips',
    subtitle: 'Chip, ChipGroup, ChipGroupViewPager',
    icon: FDIcons.board,
    builder: (_) => const ChipsPage(),
  ),
  ShowcaseEntry(
    title: 'Fields',
    subtitle: 'InputField, TextField, colour swatches',
    icon: FDIcons.edit,
    builder: (_) => const FormPage(),
  ),
  ShowcaseEntry(
    title: 'Cards & surfaces',
    subtitle: 'Card radii, shadows, dividers, semantic colors',
    icon: FDIcons.timeline,
    builder: (_) => const CardsPage(),
  ),
  ShowcaseEntry(
    title: 'App bars & tabs',
    subtitle: 'AppBar, TabAppBar, Tabs — each in a full-page demo',
    icon: FDIcons.arrowRightLeft,
    builder: (_) => const NavigationPage(),
  ),
  ShowcaseEntry(
    title: 'Action sheets',
    subtitle: 'Modal sheets, headers, footers, confirmation flows',
    icon: FDIcons.more,
    builder: (_) => const SheetsPage(),
  ),
];

/// Realistic screens assembled from the catalogue above.
///
/// An example earns a place here when the *composition* is the point — state
/// flowing between components, or a layout only visible at screen scale. It
/// reuses catalogued components rather than introducing new ones.
final exampleEntries = <ShowcaseEntry>[
  ShowcaseEntry(
    title: 'Create profile',
    subtitle: 'Labelled fields feeding a live preview, with a submit action',
    icon: FDIcons.scanFace,
    builder: (_) => const ProfileExamplePage(),
  ),
];

/// The showcase index: a component catalogue and a set of realistic examples,
/// split across two tabs.
///
/// The split is the organising principle made visible. Filing everything by
/// component family keeps lookup predictable, but the compositions worth seeing
/// — state flowing between widgets, screen-scale layout — have no home in a
/// catalogue, so they get their own tab rather than being filed under whichever
/// component they happen to use most.
class HomePage extends StatefulWidget {
  /// {@macro home_page}
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlowinTabAppBar(
        primary: !kIsWeb,
        controller: _tabs,
        leading: FDIcons.scanFace.toIcon(),
        trailing: const ThemeModeToggle(),
        tabs: const [
          FlowinTabItem(label: 'Library'),
          FlowinTabItem(label: 'Examples'),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                const _LibraryTab(),
                _EntryList(entries: exampleEntries),
              ],
            ),
          ),
          // Below the tabs rather than inside them: the version belongs to the
          // app, not to either list, and a bug filed from any page should be
          // able to quote it.
          const SafeArea(top: false, child: AppVersionLabel()),
        ],
      ),
    );
  }
}

/// The Library tab: foundations and components, paged by chip.
///
/// Two lists rather than one, because a token and a widget answer different
/// questions — "what values exist" versus "what can I place on a screen" — and
/// a reader is usually after one or the other, not both.
class _LibraryTab extends StatelessWidget {
  const _LibraryTab();

  @override
  Widget build(BuildContext context) {
    return FlowinChipGroupViewPager(
      // Wrap layout: two chips always fit, so nothing scrolls out of reach.
      isScrollable: false,
      // The tab bar above already draws a hairline, so the pager's own would
      // be a second rule a few pixels below the first.
      showDivider: false,
      // Top padding only, unlike the paged scaffold: there the chips sit below
      // an app bar that already gives them room, while here they butt straight
      // against the tab bar. Nothing on the bottom — the pager adds its own
      // gap below the chip row, and the list its own padding above the first
      // entry, so a third would read as a trough.
      chipsPadding: EdgeInsets.only(
        left: context.spacing.md,
        right: context.spacing.md,
        top: context.spacing.sm,
      ),
      items: [
        FlowinChipGroupViewPage.child(
          label: 'Foundations',
          child: _EntryList(entries: foundationEntries),
        ),
        FlowinChipGroupViewPage.child(
          label: 'Components',
          child: _EntryList(entries: componentEntries),
        ),
      ],
    );
  }
}

/// A list of showcase entries routing to their pages.
class _EntryList extends StatelessWidget {
  const _EntryList({required this.entries});

  final List<ShowcaseEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // Tighter on top: whatever sits above the list — a chip row on Library,
      // the tab bar on Examples — already supplies its own gap, so a full step
      // here would double it.
      padding: EdgeInsets.fromLTRB(
        context.spacing.md,
        context.spacing.xs,
        context.spacing.md,
        context.spacing.md,
      ),
      itemCount: entries.length,
      separatorBuilder: (_, _) => SizedBox(height: context.spacing.xs),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return FlowinItemButton.tonal(
          icon: entry.icon.toIcon(),
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: entry.builder)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(entry.title, style: context.textTheme.titleSmall),
              Text(
                entry.subtitle,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
