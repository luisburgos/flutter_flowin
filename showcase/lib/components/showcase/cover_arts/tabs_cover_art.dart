import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:lowframer/lowframer.dart';

/// The Tabs card art: labels with an accent underline, over page content.
class TabsCoverArt extends StatelessWidget {
  /// {@macro tabs_cover_art}
  const TabsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            spacing: 12,
            // Top-aligned so every label sits on the same line; the selected
            // tab's underline hangs below without pushing its label off axis.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                spacing: 4,
                children: [
                  LowframerBox.line(color: palette.fillStrong, width: 30),
                  LowframerBox(
                    color: palette.accent,
                    width: 30,
                    height: 2,
                    radius: 1,
                  ),
                ],
              ),
              LowframerBox.line(color: palette.fill, width: 30),
              LowframerBox.line(color: palette.fill, width: 30),
            ],
          ),
          Expanded(
            child: LowframerBox(
              color: palette.fill,
              height: double.infinity,
              radius: 5,
            ),
          ),
        ],
      ),
    );
  }
}
