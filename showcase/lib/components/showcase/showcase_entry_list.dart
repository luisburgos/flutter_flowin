import 'package:flowin_showcase/components/showcase/showcase_entry.dart';
import 'package:flowin_showcase/components/showcase/showcase_entry_tile.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The narrowest a tile may be laid out at.
///
/// Below this a subtitle starts wrapping past two lines and the column stops
/// reading as a scannable list, so the grid drops a column rather than
/// squeezing one further. The longest subtitles in the catalogue run to about
/// 60 characters and do take two lines at this width — the tile is sized to
/// stay readable there, not to keep every subtitle on one line.
const _minTileWidth = 280.0;

/// The most columns the grid will use.
///
/// Capped rather than left to divide the available width: without a ceiling an
/// ultrawide window would spread the catalogue into one thin line of tiles,
/// and a row scanned by title stops being scannable once it reads as a
/// paragraph.
const _maxColumns = 4;

/// A list of showcase entries, each routing to its page.
///
/// One column on a phone, up to [_maxColumns] on a desktop. The layout is
/// driven by the width the list is actually given rather than the window's, so
/// it still lays out correctly inside a padded or inset parent.
class ShowcaseEntryList extends StatelessWidget {
  /// {@macro showcase_entry_list}
  const ShowcaseEntryList({required this.entries, super.key});

  /// The entries to list, in order.
  final List<ShowcaseEntry> entries;

  /// How many columns fit in [availableWidth], between one and [_maxColumns].
  ///
  /// Counts the gaps as well as the tiles: n columns carry n - 1 gaps between
  /// them, and ignoring those overestimates what fits by a whole gap per
  /// column, which is what pushes the last tile of a row under its minimum.
  int _columnsFor(double availableWidth, double gap) {
    final fitting = (availableWidth + gap) ~/ (_minTileWidth + gap);
    return fitting.clamp(1, _maxColumns);
  }

  @override
  Widget build(BuildContext context) {
    final gap = context.spacing.xs;

    // Tighter on top: whatever sits above the list — a chip row on Library,
    // the tab bar on Examples — already supplies its own gap, so a full step
    // here would double it.
    final padding = EdgeInsets.fromLTRB(
      context.spacing.md,
      context.spacing.xs,
      context.spacing.md,
      context.spacing.md,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _columnsFor(
          constraints.maxWidth - padding.horizontal,
          gap,
        );

        // One column is the list it has always been. Kept as a ListView rather
        // than a one-column grid so the phone case stays lazily built and
        // free-height, which is what lets a tile grow to its own content.
        if (columns == 1) {
          return ListView.separated(
            padding: padding,
            itemCount: entries.length,
            separatorBuilder: (_, _) => SizedBox(height: gap),
            itemBuilder: (context, index) => ShowcaseEntryTile(entries[index]),
          );
        }

        // Rows rather than a GridView: a grid wants a fixed extent or aspect
        // ratio for every cell, which would either clip the longest subtitle
        // or pad out every other tile to match it. A Row of Expanded tiles in
        // an IntrinsicHeight lets each row size to its own tallest tile, so a
        // two-line subtitle costs height only in the row that has one.
        return ListView.separated(
          padding: padding,
          itemCount: (entries.length / columns).ceil(),
          separatorBuilder: (_, _) => SizedBox(height: gap),
          itemBuilder: (context, rowIndex) {
            final start = rowIndex * columns;
            final rowEntries = entries.skip(start).take(columns).toList();

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: gap,
                children: [
                  for (final entry in rowEntries)
                    Expanded(child: ShowcaseEntryTile(entry)),
                  // A short final row keeps its tiles at column width instead
                  // of stretching them across the gap the missing ones left.
                  for (var i = rowEntries.length; i < columns; i++)
                    const Expanded(child: SizedBox.shrink()),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
