import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:lowframer/lowframer.dart';

/// The Icon buttons card art: a row of circles, one accented.
class IconButtonsCoverArt extends StatelessWidget {
  /// {@macro icon_buttons_cover_art}
  const IconButtonsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          LowframerBox.pill(color: palette.accent, width: 22, height: 22),
          LowframerBox.pill(color: palette.fill, width: 22, height: 22),
          LowframerBox.pill(
            color: palette.background,
            borderColor: palette.fillStrong,
            width: 22,
            height: 22,
          ),
          LowframerBox.pill(color: palette.fill, width: 22, height: 22),
        ],
      ),
    );
  }
}
