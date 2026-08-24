import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Chips card art: two wrapped rows of chip silhouettes, one accented.
class ChipsCoverArt extends StatelessWidget {
  /// {@macro chips_cover_art}
  const ChipsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(color: palette.accent, width: 40),
              LowframerBox.pill(color: palette.fill, width: 52),
            ],
          ),
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(color: palette.fill, width: 56),
              LowframerBox.pill(color: palette.fill, width: 36),
            ],
          ),
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(color: palette.fill, width: 44),
              LowframerBox.pill(color: palette.fill, width: 60),
            ],
          ),
        ],
      ),
    );
  }
}
