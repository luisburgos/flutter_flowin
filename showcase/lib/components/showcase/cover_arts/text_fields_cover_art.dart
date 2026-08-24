import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Text fields card art: label lines over field boxes, one focused.
class TextFieldsCoverArt extends StatelessWidget {
  /// {@macro text_fields_cover_art}
  const TextFieldsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          LowframerBox.line(color: palette.fillStrong, width: 28),
          LowframerBox(
            color: palette.background,
            borderColor: palette.accent,
            height: 18,
            radius: 4,
          ),
          const SizedBox(height: 2),
          LowframerBox.line(color: palette.fillStrong, width: 40),
          LowframerBox(color: palette.fill, height: 18, radius: 4),
        ],
      ),
    );
  }
}
