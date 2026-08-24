import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flowin_showcase/components/lowframer/lowframer_scribble.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Typography card art: the type scale as lines of falling weight, mixed
/// with scribbles — typeset text and written text side by side.
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
        spacing: 6,
        children: [
          Row(
            spacing: 6,
            children: [
              LowframerBox(
                color: palette.accent,
                width: 64,
                height: 10,
                radius: 3,
              ),
              LowframerScribble(
                color: palette.accent,
                width: 56,
                height: 10,
                strokeWidth: 2.5,
                wavelength: 14,
              ),
            ],
          ),
          Row(
            spacing: 6,
            children: [
              LowframerBox(color: palette.fillStrong, width: 66, height: 6),
              LowframerScribble(
                color: palette.fillStrong,
                width: 54,
                height: 7,
                strokeWidth: 1.8,
              ),
            ],
          ),
          LowframerBox.line(color: palette.fill, width: 110),
          LowframerScribble(
            color: palette.fill,
            width: 96,
            height: 5,
            strokeWidth: 1.4,
            wavelength: 7,
          ),
        ],
      ),
    );
  }
}
