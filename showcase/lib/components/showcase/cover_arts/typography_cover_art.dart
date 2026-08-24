import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Typography card art: the type scale as lines of falling weight.
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
          LowframerBox(color: palette.accent, width: 64, height: 10, radius: 3),
          LowframerBox(color: palette.fillStrong, width: 88, height: 6),
          LowframerBox.line(color: palette.fill, width: 110),
          LowframerBox.line(color: palette.fill, width: 96),
        ],
      ),
    );
  }
}
