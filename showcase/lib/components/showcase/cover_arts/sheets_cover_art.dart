import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Action sheets card art: a sheet rising over dimmed page content,
/// grab handle on top.
class SheetsCoverArt extends StatelessWidget {
  /// {@macro sheets_cover_art}
  const SheetsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        children: [
          LowframerBox.line(color: palette.fill, width: 80),
          const Spacer(),
          LowframerBox(
            color: palette.background,
            borderColor: palette.fillStrong,
            height: 62,
            radius: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                LowframerBox.pill(
                  color: palette.fillStrong,
                  width: 20,
                  height: 3,
                ),
                LowframerBox.line(color: palette.fill, width: 60),
                LowframerBox.pill(color: palette.accent, width: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
