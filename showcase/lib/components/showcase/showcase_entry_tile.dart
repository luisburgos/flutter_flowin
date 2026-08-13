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
  }
}
