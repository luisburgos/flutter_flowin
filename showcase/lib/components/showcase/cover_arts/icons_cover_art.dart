import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:lowframer/lowframer.dart';

/// The Icons card art: a glyph grid, one accented.
class IconsCoverArt extends StatelessWidget {
  /// {@macro icons_cover_art}
  const IconsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget glyph({bool accent = false}) => LowframerBox.pill(
      color: accent ? palette.accent : palette.fill,
      width: 14,
      height: 14,
    );

    Widget row(List<Widget> glyphs) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: glyphs,
    );

    return LowframerWindow(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          row([glyph(), glyph(), glyph(), glyph()]),
          row([glyph(), glyph(accent: true), glyph(), glyph()]),
          row([glyph(), glyph(), glyph(), glyph()]),
        ],
      ),
    );
  }
}
