import 'package:flowin_showcase/components/showcase/showcase_section.dart';
import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_flowin/flutter_flowin.dart';

/// The shared page chrome for every showcase page.
///
/// Owns the back-navigating [FlowinAppBar] and the [ThemeModeToggle] in its
/// trailing slot, so the toggle is reachable from every page rather than only
/// the index.
///
/// Chrome and body are separate concerns here. The default constructor takes
/// an arbitrary body, so a page that lays itself out — a playground running
/// edge to edge, a demo owning its own scrolling — still gets the chrome
/// instead of hand-rolling an app bar. [ShowcaseScaffold.stacked] and
/// [ShowcaseScaffold.paged] add the two body layouts most pages want.
class ShowcaseScaffold extends StatelessWidget {
  /// Chrome around a body the page lays out itself.
  ///
  /// Pass [dividedAppBar] when the body runs edge to edge: with no padding
  /// between it and the bar, the bar needs its own hairline to separate them.
  const ShowcaseScaffold({
    required this.title,
    required this.body,
    this.appBar,
    this.dividedAppBar = false,
    super.key,
  }) : children = const [],
       sections = null;

  /// A page whose content is stacked in one padded, scrolling column.
  const ShowcaseScaffold.stacked({
    required this.title,
    required this.children,
    this.appBar,
    super.key,
  }) : body = null,
       sections = null,
       dividedAppBar = false;

  /// A page whose sections are browsed one at a time through a
  /// [FlowinChipGroupViewPager] instead of stacked in one long scroll.
  ///
  /// Each section becomes a chip (labelled by `chipLabel`, falling back to
  /// `title`) and a page. The section keeps its own descriptive heading inside
  /// the page, so the terse chip and the full title complement rather than
  /// duplicate each other.
  const ShowcaseScaffold.paged({
    required this.title,
    required List<ShowcaseSection> this.sections,
    this.appBar,
    super.key,
  }) : body = null,
       children = const [],
       dividedAppBar = false;

  /// The page title rendered in the app bar.
  final String title;

  /// A body the page lays out itself, or null in the stacked and paged modes.
  final Widget? body;

  /// The page content, laid out in a scrolling column.
  ///
  /// Empty outside the stacked mode.
  final List<Widget> children;

  /// The sections to page through, or null outside the paged mode.
  final List<ShowcaseSection>? sections;

  /// Replaces the default app bar (used by the navigation demos).
  final PreferredSizeWidget? appBar;

  /// Whether the default app bar draws a hairline below itself.
  ///
  /// Only meaningful for a self-laid-out body: the stacked and paged modes
  /// pad their content away from the bar, so a rule there would float.
  final bool dividedAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBar ??
          FlowinAppBar(
            height: dividedAppBar
                ? kFlowinAppBarHeight + context.spacing.xxs
                : kFlowinAppBarHeight,
            leading: FlowinIconButton.text(
              icon: FDIcons.back.toIcon(),
              onPressed: () => Navigator.of(context).pop(),
            ),
            trailing: const ThemeModeToggle(),
            primary: !kIsWeb,
            footer: dividedAppBar
                ? Padding(
                    padding: EdgeInsets.only(top: context.spacing.xxs),
                    child: const Divider(
                      height: FlowinDesignBorders.regular,
                      thickness: FlowinDesignBorders.regular,
                    ),
                  )
                : null,
            child: Text(title, style: context.textTheme.titleMedium),
          ),
      body: switch ((body, sections)) {
        (final Widget body, _) => body,
        (_, final List<ShowcaseSection> sections) => _paged(context, sections),
        _ => _stacked(context),
      },
    );
  }

  Widget _stacked(BuildContext context) {
    return ListView(padding: _bodyPadding(context), children: children);
  }

  Widget _paged(BuildContext context, List<ShowcaseSection> sections) {
    return FlowinChipGroupViewPager(
      // Wrap layout: every section stays visible instead of scrolling out of
      // reach horizontally.
      isScrollable: false,
      // Leading alignment and the wrapped-row gap are the component's own
      // defaults — nothing to override here.
      chipsPadding: EdgeInsets.symmetric(horizontal: context.spacing.md),
      items: [
        for (final section in sections)
          FlowinChipGroupViewPage.child(
            label: section.chipLabel ?? section.title,
            // Each page scrolls on its own — sections vary from a few rows to
            // the full icon set.
            child: ListView(
              // Tighter on top than the stacked pages (the chip row already
              // separates the body from the app bar) and wider at the sides.
              padding: EdgeInsets.fromLTRB(
                context.spacing.lg,
                context.spacing.xxs,
                context.spacing.lg,
                context.spacing.xxl,
              ),
              children: [section.withLeadingGap(leadingGap: false)],
            ),
          ),
      ],
    );
  }

  EdgeInsets _bodyPadding(BuildContext context) => EdgeInsets.fromLTRB(
    context.spacing.md,
    context.spacing.xs,
    context.spacing.md,
    context.spacing.xxl,
  );
}
