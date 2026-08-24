import 'package:flowin_showcase/app_info/app_version_label.dart';
import 'package:flowin_showcase/catalogue.dart';
import 'package:flowin_showcase/components/showcase/showcase_entry_list.dart';
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
          title: 'Flowin UI',
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

/// The widest the tab content may lay out.
///
/// Four columns at the list's minimum tile width, plus gaps and padding, land
/// just under this; anything wider only stretches the tiles, and a stretched
/// tile distorts its fixed-height cover art. The app bar and version label
/// stay full-width — it is the content that caps, not the chrome.
const double _kContentMaxWidth = 1200;

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
            // Centered under a max width so an ultrawide window widens the
            // margins instead of the cards. The chip row lives inside the
            // pager, so it caps and centers together with the lists.
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: _kContentMaxWidth,
                ),
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    const _LibraryTab(),
                    ShowcaseEntryList(entries: exampleEntries),
                  ],
                ),
              ),
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
          label: 'Components',
          child: ShowcaseEntryList(entries: componentEntries),
        ),
        FlowinChipGroupViewPage.child(
          label: 'Foundations',
          child: ShowcaseEntryList(entries: foundationEntries),
        ),
      ],
    );
  }
}
