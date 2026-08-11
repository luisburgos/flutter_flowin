import 'package:flowin_showcase/pages/showcase_scaffold.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Demonstrates the modal action sheet in several real configurations.
class SheetsPage extends StatefulWidget {
  /// {@macro sheets_page}
  const SheetsPage({super.key});

  @override
  State<SheetsPage> createState() => _SheetsPageState();
}

class _SheetsPageState extends State<SheetsPage> {
  String _result = '—';

  void _record(String value) => setState(() => _result = value);

  Future<void> _showSimple(BuildContext context) async {
    await showFlowinActionSheet<void>(
      context: context,
      builder: (sheetContext) => const FlowinActionSheet(
        title: 'Just a title',
        subtitle: 'A minimal sheet with a close button and nothing else.',
      ),
    );
    _record('simple sheet dismissed');
  }

  Future<void> _showConfirm(BuildContext context) async {
    final confirmed = await showFlowinActionSheet<bool>(
      context: context,
      builder: (sheetContext) => FlowinActionSheet(
        title: 'Delete workspace?',
        subtitle: 'This removes every board and cannot be undone.',
        headerIcon: FDIcons.trash.toIcon(size: FlowinDesignIconSize.xl),
        footer: FlowinActionSheetFooter(
          left: FlowinButton.tonal(
            size: FlowinButtonSize.md,
            onPressed: () => Navigator.of(sheetContext).pop(false),
            label: 'Cancel',
          ),
          right: FlowinButton.destructive(
            size: FlowinButtonSize.md,
            onPressed: () => Navigator.of(sheetContext).pop(true),
            label: 'Delete',
          ),
        ),
      ),
    );
    _record(confirmed ?? false ? 'confirmed delete' : 'cancelled delete');
  }

  Future<void> _showForm(BuildContext context) async {
    var name = '';
    final saved = await showFlowinActionSheet<String>(
      context: context,
      builder: (sheetContext) => FlowinActionSheet(
        title: 'Rename board',
        headerIcon: FDIcons.edit.toIcon(size: FlowinDesignIconSize.lg),
        body: Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            vertical: FlowinDesignSpace.space200,
            horizontal: FlowinDesignSpace.space800,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: FlowinDesignSpace.space300,
            children: [
              FlowinLabeledTextField(
                label: 'Board name',
                hintText: 'Q3 roadmap',
                autofocus: true,
                onChanged: (v) => name = v,
              ),
              FlowinChipGroup(
                labels: const ['Personal', 'Team', 'Public'],
                initialSelectedIndex: 1,
                onSelected: (_) {},
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        footer: FlowinActionSheetFooter(
          right: FlowinButton.filled(
            size: FlowinButtonSize.md,
            onPressed: () => Navigator.of(sheetContext).pop(name),
            label: 'Save',
          ),
        ),
      ),
    );
    if (saved != null && saved.isNotEmpty) {
      _record('renamed to "$saved"');
    } else {
      _record('rename dismissed');
    }
  }

  Future<void> _showFullBleed(BuildContext context) async {
    await showFlowinActionSheet<void>(
      context: context,
      builder: (sheetContext) => FlowinActionSheet(
        title: 'Share score',
        // No Padding around the body: the sheet insets nothing, so a body that
        // should reach the card edge simply does not wrap itself. The card
        // clips it to the corner radius.
        body: const _ScorePanel(),
        footer: FlowinActionSheetFooter(
          right: FlowinButton.filled(
            size: FlowinButtonSize.md,
            icon: FDIcons.share.toIcon(size: FlowinDesignIconSize.sm),
            onPressed: () => Navigator.of(sheetContext).pop(),
            label: 'Share',
          ),
        ),
      ),
    );
    _record('share sheet dismissed');
  }

  Future<void> _showMenu(BuildContext context) async {
    final choice = await showFlowinActionSheet<String>(
      context: context,
      builder: (sheetContext) => FlowinActionSheet(
        title: 'Board actions',
        body: Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            horizontal: FlowinDesignSpace.space600,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: FlowinDesignSpace.space200,
            children: [
              for (final action in const [
                ('Edit', FDIcons.edit),
                ('Share', FDIcons.share),
                ('Duplicate', FDIcons.arrowDownUp),
              ])
                FlowinItemButton.tonal(
                  icon: action.$2.toIcon(),
                  onPressed: () => Navigator.of(sheetContext).pop(action.$1),
                  label: action.$1,
                ),
              FlowinItemButton.destructive(
                icon: FDIcons.trash.toIcon(),
                onPressed: () => Navigator.of(sheetContext).pop('Delete'),
                label: 'Delete',
              ),
            ],
          ),
        ),
      ),
    );
    _record(choice == null ? 'menu dismissed' : 'selected "$choice"');
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold.paged(
      title: 'Action sheets',
      sections: [
        ShowcaseSection(
          chipLabel: 'Modal',
          title: 'Modal sheets',
          description:
              'showFlowinActionSheet presents a Flowin-styled modal '
              'bottom sheet, clamped to 480px on wide viewports. The footer '
              'stretches a lone action to full width, so omitting the left '
              'one is how a single-action sheet is built. Each sheet reports '
              'what it returned into the card below.',
          children: [
            FlowinItemButton.tonal(
              icon: FDIcons.board.toIcon(),
              onPressed: () => _showSimple(context),
              label: 'Title & subtitle only',
            ),
            SizedBox(height: context.spacing.xs),
            FlowinItemButton.tonal(
              icon: FDIcons.done.toIcon(),
              onPressed: () => _showConfirm(context),
              label: 'Destructive confirmation',
            ),
            SizedBox(height: context.spacing.xs),
            FlowinItemButton.tonal(
              icon: FDIcons.edit.toIcon(),
              onPressed: () => _showForm(context),
              label: 'Sheet with a form body',
            ),
            SizedBox(height: context.spacing.xs),
            FlowinItemButton.tonal(
              icon: FDIcons.share.toIcon(),
              onPressed: () => _showFullBleed(context),
              label: 'Sheet with a full-bleed body',
            ),
            SizedBox(height: context.spacing.xs),
            FlowinItemButton.tonal(
              icon: FDIcons.more.toIcon(),
              onPressed: () => _showMenu(context),
              label: 'Action menu',
            ),
            SizedBox(height: context.spacing.sm),
            // Separates the triggers above from the result they report into.
            const Divider(),
            SizedBox(height: context.spacing.sm),
            ShowcaseRow(
              label: 'Result',
              child: FlowinCard(
                padding: EdgeInsets.all(context.spacing.md),
                child: Row(
                  spacing: FlowinDesignSpace.space300,
                  children: [
                    FDIcons.done.toIcon(size: FlowinDesignIconSize.sm),
                    Expanded(
                      child: Text(_result, style: context.textTheme.bodyLarge),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const ShowcaseSection(
          chipLabel: 'Header',
          title: 'Title placement',
          description:
              'The title is always adjacent to its subtitle. The bar holds one '
              'leading element, so an icon takes it and pushes the title into '
              'the supporting block below. Toggle the icon to watch the title '
              'move.',
          children: [_TitlePlacementDemo()],
        ),
        const ShowcaseSection(
          chipLabel: 'Inline',
          title: 'FlowinActionSheet — inline',
          description: 'The same widget rendered inline, without the modal.',
          children: [_InlineSheetDemo()],
        ),
      ],
    );
  }
}

/// The header's title-placement rule, driven by two toggles.
///
/// The title is always adjacent to its subtitle. The bar has one leading slot,
/// so an icon takes it and displaces the title into the supporting block
/// below; without an icon the title keeps the slot. Toggling the icon moves
/// the title between the two regions in place, which is the point of showing
/// this live rather than as four separate sheets.
class _TitlePlacementDemo extends StatefulWidget {
  const _TitlePlacementDemo();

  @override
  State<_TitlePlacementDemo> createState() => _TitlePlacementDemoState();
}

class _TitlePlacementDemoState extends State<_TitlePlacementDemo> {
  bool _hasIcon = false;
  bool _hasSubtitle = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: FlowinDesignSpace.space200,
          children: [
            FlowinChip(
              label: const Text('Icon'),
              variant: _hasIcon
                  ? FlowinChipVariant.selected
                  : FlowinChipVariant.unselected,
              onSelected: (v) => setState(() => _hasIcon = v),
            ),
            FlowinChip(
              label: const Text('Subtitle'),
              variant: _hasSubtitle
                  ? FlowinChipVariant.selected
                  : FlowinChipVariant.unselected,
              onSelected: (v) => setState(() => _hasSubtitle = v),
            ),
          ],
        ),
        SizedBox(height: context.spacing.sm),
        FlowinActionSheet(
          title: 'Descriptive title',
          subtitle: _hasSubtitle
              ? 'Write something in here that gives clear directions.'
              : null,
          headerIcon: _hasIcon
              ? FDIcons.board.toIcon(size: FlowinDesignIconSize.xl)
              : null,
          displayClose: false,
          margin: EdgeInsets.zero,
        ),
        SizedBox(height: context.spacing.sm),
        ShowcaseRow(
          label: 'Title sits in',
          child: FlowinCard(
            padding: EdgeInsets.all(context.spacing.md),
            child: Row(
              spacing: FlowinDesignSpace.space300,
              children: [
                FDIcons.done.toIcon(size: FlowinDesignIconSize.sm),
                Expanded(
                  child: Text(
                    _hasIcon
                        ? 'the supporting block — the icon took the bar'
                        : 'the bar — no icon to displace it',
                    style: context.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A full-bleed body: a dark panel spanning the card corner to corner.
///
/// Deliberately carries no horizontal inset of its own. That is the whole
/// point of the demo — the sheet insets nothing, so reaching the card edge is
/// the body's own choice rather than something it has to undo.
class _ScorePanel extends StatelessWidget {
  const _ScorePanel();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      color: scheme.inverseSurface,
      height: FlowinDesignSpace.space1400 * 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: FlowinDesignSpace.space600,
          horizontal: FlowinDesignSpace.space800,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final score in ['2', '2'])
              Text(
                score,
                style: context.textTheme.displaySmall?.copyWith(
                  color: scheme.onInverseSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The inline action sheet plus its own result card.
///
/// Owns its result locally so its footer actions report where they can be
/// seen, rather than writing into the modal section's card on another page.
class _InlineSheetDemo extends StatefulWidget {
  const _InlineSheetDemo();

  @override
  State<_InlineSheetDemo> createState() => _InlineSheetDemoState();
}

class _InlineSheetDemoState extends State<_InlineSheetDemo> {
  String _result = '—';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlowinActionSheet(
          title: 'Inline sheet',
          subtitle: 'Useful for embedding the sheet layout in a page.',
          displayClose: false,
          margin: EdgeInsets.zero,
          body: const Text(
            'The body slot accepts any widget, and the footer keeps its '
            'two-action row.',
          ),
          footer: FlowinActionSheetFooter(
            left: FlowinButton.text(
              size: FlowinButtonSize.md,
              onPressed: () => setState(() => _result = 'Later'),
              label: 'Later',
            ),
            right: FlowinButton.filled(
              size: FlowinButtonSize.md,
              onPressed: () => setState(() => _result = 'Got it'),
              label: 'Got it',
            ),
          ),
        ),
        SizedBox(height: context.spacing.sm),
        const Divider(),
        SizedBox(height: context.spacing.sm),
        ShowcaseRow(
          label: 'Result',
          child: FlowinCard(
            padding: EdgeInsets.all(context.spacing.md),
            child: Row(
              spacing: FlowinDesignSpace.space300,
              children: [
                FDIcons.done.toIcon(size: FlowinDesignIconSize.sm),
                Expanded(
                  child: Text(_result, style: context.textTheme.bodyLarge),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
