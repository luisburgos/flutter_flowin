import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart'
    show ShowcaseScaffold;
import 'package:flutter_flowin/flutter_flowin.dart';

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
