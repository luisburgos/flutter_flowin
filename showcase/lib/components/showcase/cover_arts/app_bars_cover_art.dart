import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:lowframer/lowframer.dart';

/// The App bars card art: leading and trailing controls around a title,
/// over quiet page content.
class AppBarsCoverArt extends StatelessWidget {
  /// {@macro app_bars_cover_art}
  const AppBarsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              LowframerBox.pill(color: palette.fill, width: 12),
              const Spacer(),
              LowframerBox.line(color: palette.fillStrong, width: 40),
              const Spacer(),
              LowframerBox.pill(color: palette.accent, width: 12),
            ],
          ),
          LowframerBox(color: palette.fillStrong, height: 1, radius: 0),
          LowframerBox.line(color: palette.fill, width: 90),
          LowframerBox.line(color: palette.fill, width: 70),
        ],
      ),
    );
  }
}
