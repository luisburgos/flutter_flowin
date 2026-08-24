import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Cards & surfaces card art: a filled and an outlined surface, side
/// by side, each with its caption line.
class CardsCoverArt extends StatelessWidget {
  /// {@macro cards_cover_art}
  const CardsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                LowframerBox(color: palette.fill, height: 46, radius: 6),
                LowframerBox.line(color: palette.fillStrong, width: 30),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                LowframerBox(
                  color: palette.background,
                  borderColor: palette.fillStrong,
                  height: 46,
                  radius: 6,
                ),
                LowframerBox.line(color: palette.fill, width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
