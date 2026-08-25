import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:lowframer/lowframer.dart';

/// The Input fields card art: a label over one large bordered surface.
class InputFieldsCoverArt extends StatelessWidget {
  /// {@macro input_fields_cover_art}
  const InputFieldsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [
          LowframerBox.line(color: palette.fillStrong, width: 34),
          LowframerBox(
            color: palette.background,
            borderColor: palette.accent,
            height: 52,
            radius: 6,
          ),
        ],
      ),
    );
  }
}
