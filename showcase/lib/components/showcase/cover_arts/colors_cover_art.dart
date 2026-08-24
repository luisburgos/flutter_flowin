import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Colors card art: large role tiles, one accented, one outlined.
class ColorsCoverArt extends StatelessWidget {
  /// {@macro colors_cover_art}
  const ColorsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget tile({bool accent = false, bool outlined = false}) => Expanded(
      child: LowframerBox(
        color: accent
            ? palette.accent
            : outlined
            ? palette.background
            : palette.fill,
        borderColor: outlined ? palette.fillStrong : null,
        height: double.infinity,
        radius: 5,
      ),
    );

    return LowframerWindow(
      child: Column(
        spacing: 6,
        children: [
          Expanded(
            child: Row(
              spacing: 6,
              children: [tile(accent: true), tile(), tile()],
            ),
          ),
          Expanded(
            child: Row(
              spacing: 6,
              children: [tile(), tile(outlined: true), tile()],
            ),
          ),
        ],
      ),
    );
  }
}
