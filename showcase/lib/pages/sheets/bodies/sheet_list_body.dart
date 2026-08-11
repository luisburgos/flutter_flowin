import 'package:flutter_flowin/flutter_flowin.dart';

/// A body holding a column of item buttons, the last one destructive.
class SheetListBody extends StatelessWidget {
  /// {@macro sheet_list_body}
  const SheetListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FlowinDesignSpace.space600,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: FlowinDesignSpace.space200,
        children: [
          for (final action in const [
            ('Edit', FDIcons.edit),
            ('Share', FDIcons.share),
          ])
            FlowinItemButton.tonal(
              icon: action.$2.toIcon(),
              onPressed: () {},
              label: action.$1,
            ),
          FlowinItemButton.destructive(
            icon: FDIcons.trash.toIcon(),
            onPressed: () {},
            label: 'Delete',
          ),
        ],
      ),
    );
  }
}
