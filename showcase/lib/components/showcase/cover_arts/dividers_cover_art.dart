import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:lowframer/lowframer.dart';

/// The Dividers card art: content lines separated by hairline rules.
class DividersCoverArt extends StatelessWidget {
  /// {@macro dividers_cover_art}
  const DividersCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          LowframerBox.line(color: palette.fill, width: 64),
          LowframerBox(color: palette.fillStrong, height: 1, radius: 0),
          LowframerBox.line(color: palette.fill, width: 48),
          LowframerBox(color: palette.accent, height: 1.5, radius: 0),
          LowframerBox.line(color: palette.fill, width: 56),
        ],
      ),
    );
  }
}
