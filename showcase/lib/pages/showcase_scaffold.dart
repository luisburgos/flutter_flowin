import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_flowin/flutter_flowin.dart';

/// The shared page chrome for every showcase page.
///
/// Owns the back-navigating [FlowinAppBar], the [ThemeModeToggle] in its
/// trailing slot, and the scrolling body padding, so individual pages only
/// declare their content. Putting the toggle here is what makes it reachable
/// from every page rather than only the index.
class ShowcaseScaffold extends StatelessWidget {
  /// {@macro showcase_scaffold}
  const ShowcaseScaffold({
    required this.title,
    required this.children,
    this.appBar,
    super.key,
  }) : sections = null;

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
  }) : children = const [];

  /// The page title rendered in the app bar.
  final String title;

  /// The page content, laid out in a scrolling column.
  ///
  /// Empty in paged mode — see [sections].
  final List<Widget> children;

  /// The sections to page through, or null in the default stacked mode.
  final List<ShowcaseSection>? sections;

  /// Replaces the default app bar (used by the navigation demos).
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBar ??
          FlowinAppBar(
            leading: FlowinIconButton.text(
              icon: FDIcons.back.toIcon(),
              onPressed: () => Navigator.of(context).pop(),
            ),
            trailing: const ThemeModeToggle(),
            primary: !kIsWeb,
            child: Text(title, style: context.textTheme.titleMedium),
          ),
      body: sections == null ? _stacked(context) : _paged(context),
    );
  }

  Widget _stacked(BuildContext context) {
    return ListView(padding: _bodyPadding(context), children: children);
  }

  Widget _paged(BuildContext context) {
    return FlowinChipGroupViewPager(
      // Wrap layout: every section stays visible instead of scrolling out of
      // reach horizontally.
      isScrollable: false,
      // Leading alignment and the wrapped-row gap are the component's own
      // defaults — nothing to override here.
      chipsPadding: EdgeInsets.symmetric(horizontal: context.spacing.md),
      items: [
        for (final section in sections!)
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

/// A titled group of demo widgets, separated from its neighbours by a divider.
class ShowcaseSection extends StatelessWidget {
  /// {@macro showcase_section}
  const ShowcaseSection({
    required this.title,
    required this.children,
    this.chipLabel,
    this.description,
    this.leadingGap = true,
    super.key,
  });

  /// Whether to reserve space above the heading.
  ///
  /// True when sections are stacked (it separates neighbours); set false by
  /// [ShowcaseScaffold.paged], where the section is alone on its page.
  final bool leadingGap;

  /// This section with [leadingGap] overridden.
  ShowcaseSection withLeadingGap({required bool leadingGap}) => ShowcaseSection(
    title: title,
    chipLabel: chipLabel,
    description: description,
    leadingGap: leadingGap,
    key: key,
    children: children,
  );

  /// The section heading.
  final String title;

  /// A short label for this section's chip in [ShowcaseScaffold.paged].
  ///
  /// The chip row needs terse labels ("Spacing"), while the section itself
  /// keeps the descriptive heading ("Spacing scale"). Falls back to [title]
  /// when omitted. Unused outside paged mode.
  final String? chipLabel;

  /// Optional explanatory copy under the heading.
  final String? description;

  /// The demo widgets.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Breathing room between the demo widgets themselves; the explicit
      // SizedBox below tunes the header block on top of this.
      spacing: context.spacing.xxs,
      children: [
        // Separates this section from the one above it when sections are
        // stacked; unwanted when the section is alone on its own page.
        if (leadingGap) SizedBox(height: context.spacing.lg),
        Text(title, style: context.textTheme.titleMedium),
        if (description != null)
          Text(
            description!,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        SizedBox(height: context.spacing.sm),
        ...children,
      ],
    );
  }
}

/// A labelled row used to caption an individual demo widget.
class ShowcaseRow extends StatelessWidget {
  /// {@macro showcase_row}
  const ShowcaseRow({required this.label, required this.child, super.key});

  /// The caption shown above [child].
  final String label;

  /// The demo widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.spacing.xxs),
          child,
        ],
      ),
    );
  }
}
