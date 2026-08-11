import 'package:flowin_showcase/components/showcase/showcase_entry.dart';
import 'package:flowin_showcase/components/showcase/showcase_entry_tile.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// A list of showcase entries, each routing to its page.
class ShowcaseEntryList extends StatelessWidget {
  /// {@macro showcase_entry_list}
  const ShowcaseEntryList({required this.entries, super.key});

  /// The entries to list, in order.
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
      itemBuilder: (context, index) => ShowcaseEntryTile(entries[index]),
    );
  }
}
