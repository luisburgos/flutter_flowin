import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Create profile example art: an avatar and fields feeding a submit.
class ProfileExampleCoverArt extends StatelessWidget {
  /// {@macro profile_example_cover_art}
  const ProfileExampleCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(
                color: palette.fillStrong,
                width: 18,
                height: 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  LowframerBox.line(color: palette.fillStrong, width: 44),
                  LowframerBox.line(color: palette.fill, width: 30),
                ],
              ),
            ],
          ),
          const Spacer(),
          LowframerBox(color: palette.fill, height: 14, radius: 4),
          LowframerBox(color: palette.fill, height: 14, radius: 4),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: LowframerBox.pill(color: palette.accent, width: 48),
          ),
        ],
      ),
    );
  }
}
