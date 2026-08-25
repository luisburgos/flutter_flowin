import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:lowframer/lowframer.dart';

/// The Chip view pagers card art: a chip row over a page with dots below.
class ChipPagersCoverArt extends StatelessWidget {
  /// {@macro chip_pagers_cover_art}
  const ChipPagersCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 7,
        children: [
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(color: palette.accent, width: 36),
              LowframerBox.pill(color: palette.fill, width: 36),
            ],
          ),
          Expanded(
            child: LowframerBox(
              color: palette.fill,
              height: double.infinity,
              radius: 5,
            ),
          ),
        ],
      ),
    );
  }
}
