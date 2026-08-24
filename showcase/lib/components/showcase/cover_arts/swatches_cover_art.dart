import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Colour swatches card art: a swatch grid with one selected.
class SwatchesCoverArt extends StatelessWidget {
  /// {@macro swatches_cover_art}
  const SwatchesCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget swatch({bool accent = false, bool outlined = false}) => LowframerBox(
      color: accent ? palette.accent : palette.fill,
      borderColor: outlined ? palette.fillStrong : null,
      width: 20,
      height: 20,
      radius: 5,
    );

    return LowframerWindow(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              swatch(accent: true),
              swatch(),
              swatch(),
              swatch(outlined: true),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [swatch(), swatch(outlined: true), swatch(), swatch()],
          ),
        ],
      ),
    );
  }
}
