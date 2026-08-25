import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:lowframer/lowframer.dart';

/// The Colour swatches card art: a grid of colour circles, the selected one
/// ringed with a gap around its inner disc — the radial button's silhouette.
class SwatchesCoverArt extends StatelessWidget {
  /// {@macro swatches_cover_art}
  const SwatchesCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget swatch({bool selected = false}) {
      if (!selected) {
        return LowframerBox.pill(color: palette.fill, width: 20, height: 20);
      }
      // The selected swatch is a ring: an accent border, a background-colored
      // gap, and the accent disc inside — matching FlowinColorRadialButton.
      return LowframerBox.pill(
        color: palette.background,
        borderColor: palette.accent,
        width: 20,
        height: 20,
        child: Center(
          child: LowframerBox.pill(color: palette.accent, width: 12),
        ),
      );
    }

    return LowframerWindow(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [swatch(selected: true), swatch(), swatch(), swatch()],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [swatch(), swatch(), swatch(), swatch()],
          ),
        ],
      ),
    );
  }
}
