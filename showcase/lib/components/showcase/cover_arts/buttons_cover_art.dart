import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:lowframer/lowframer.dart';

/// The Buttons card art: a stack of pill silhouettes, one accented.
class ButtonsCoverArt extends StatelessWidget {
  /// {@macro buttons_cover_art}
  const ButtonsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          LowframerBox.pill(color: palette.accent, width: 72, height: 16),
          LowframerBox.pill(color: palette.fill, width: 96, height: 16),
          LowframerBox.pill(
            color: palette.background,
            borderColor: palette.fillStrong,
            width: 56,
            height: 16,
          ),
        ],
      ),
    );
  }
}
