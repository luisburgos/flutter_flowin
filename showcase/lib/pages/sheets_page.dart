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
        body: Column(
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
            ),
          ],
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

  Future<void> _showMenu(BuildContext context) async {
    final choice = await showFlowinActionSheet<String>(
      context: context,
      builder: (sheetContext) => FlowinActionSheet(
        title: 'Board actions',
        body: Column(
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
              'bottom sheet, clamped to 480px on wide viewports. Each sheet '
              'reports what it returned into the card below.',
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
          chipLabel: 'Inline',
          title: 'FlowinActionSheet — inline',
          description: 'The same widget rendered inline, without the modal.',
          children: [_InlineSheetDemo()],
        ),
      ],
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
