import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Spacing card art: a staircase of lines, each one step further in.
class SpacingCoverArt extends StatelessWidget {
  /// {@macro spacing_cover_art}
  const SpacingCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget step(double indent, {bool accent = false}) => Padding(
      padding: EdgeInsets.only(left: indent),
      child: LowframerBox(
        color: accent ? palette.accent : palette.fill,
        width: 56,
        height: 8,
        radius: 3,
      ),
    );

    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [step(0, accent: true), step(16), step(36), step(64)],
      ),
    );
  }
}
