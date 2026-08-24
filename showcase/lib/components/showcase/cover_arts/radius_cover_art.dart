import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Radius card art: the same square at each step of the corner scale.
class RadiusCoverArt extends StatelessWidget {
  /// {@macro radius_cover_art}
  const RadiusCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget corner(double radius, {bool accent = false}) => LowframerBox(
      color: accent ? palette.accent : palette.fill,
      width: 34,
      height: 34,
      radius: radius,
    );

    return LowframerWindow(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [corner(2), corner(8), corner(999, accent: true)],
      ),
    );
  }
}
