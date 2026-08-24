import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flowin_showcase/components/lowframer/lowframer_scribble.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Typography card art: the type scale written as scribbles of falling
/// weight — an accent title, a strong subhead, and quiet body lines.
class TypographyCoverArt extends StatelessWidget {
  /// {@macro typography_cover_art}
  const TypographyCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7,
        children: [
          LowframerScribble(
            color: palette.accent,
            width: 76,
            height: 11,
            strokeWidth: 3,
            wavelength: 16,
          ),
          LowframerScribble(
            color: palette.fillStrong,
            width: 100,
            wavelength: 11,
          ),
          LowframerScribble(
            color: palette.fill,
            width: 118,
            height: 5,
            strokeWidth: 1.5,
            wavelength: 7,
          ),
          LowframerScribble(
            color: palette.fill,
            width: 92,
            height: 5,
            strokeWidth: 1.5,
            wavelength: 7,
          ),
        ],
      ),
    );
  }
}
