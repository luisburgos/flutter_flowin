import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Item buttons card art: full-width stacked rows, one accented.
class ItemButtonsCoverArt extends StatelessWidget {
  /// {@macro item_buttons_cover_art}
  const ItemButtonsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [
          LowframerBox(color: palette.accent, height: 18, radius: 5),
          LowframerBox(color: palette.fill, height: 18, radius: 5),
          LowframerBox(color: palette.fill, height: 18, radius: 5),
        ],
      ),
    );
  }
}
