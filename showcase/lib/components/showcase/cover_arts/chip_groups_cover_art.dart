import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Chip groups card art: one chip row running off the frame's edge.
class ChipGroupsCoverArt extends StatelessWidget {
  /// {@macro chip_groups_cover_art}
  const ChipGroupsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          LowframerBox.line(color: palette.fillStrong, width: 28),
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(color: palette.accent, width: 40),
              LowframerBox.pill(color: palette.fill, width: 48),
              // Runs to the frame's edge: the group scrolls, and a clipped
              // last chip is the wireframe shorthand for that.
              Expanded(
                child: LowframerBox.pill(
                  color: palette.fill,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
