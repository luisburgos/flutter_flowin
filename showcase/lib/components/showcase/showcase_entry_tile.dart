import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flowin_showcase/components/showcase/showcase_entry.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// One [ShowcaseEntry] as a tappable tile, routing to its page.
class ShowcaseEntryTile extends StatelessWidget {
  /// {@macro showcase_entry_tile}
  const ShowcaseEntryTile(this.entry, {super.key});

  /// The entry to render.
  final ShowcaseEntry entry;

  @override
  Widget build(BuildContext context) {
    final coverArt = entry.coverArt;

    return FlowinItemButton.tonal(
      // The art replaces the icon rather than joining it: with an
      // illustration on the card a second pictogram is redundant weight.
      icon: coverArt == null ? entry.icon.toIcon() : null,
      onPressed: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: entry.builder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (coverArt != null) ...[
            // The cover panel spans the card and centers the art itself;
            // the text below stays left-aligned as a scannable label.
            LowframerCover(child: coverArt(context)),
            SizedBox(height: context.spacing.sm),
          ],
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
  }
}
