import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

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
          const SizedBox(height: 2),
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
