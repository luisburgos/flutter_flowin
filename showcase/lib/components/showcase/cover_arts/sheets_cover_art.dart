import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:lowframer/lowframer.dart';

/// The Action sheets card art: the sheet's real anatomy in miniature —
/// leading icon and close button, title over subtitle, and the
/// cancel/confirm button pair.
class SheetsCoverArt extends StatelessWidget {
  /// {@macro sheets_cover_art}
  const SheetsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        children: [
          const Spacer(),
          LowframerBox(
            color: palette.background,
            borderColor: palette.fillStrong,
            height: 78,
            radius: 8,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // The header's leading icon and trailing close button.
                      LowframerBox(
                        color: palette.background,
                        borderColor: palette.fillStrong,
                        width: 10,
                        height: 10,
                        radius: 3,
                      ),
                      const Spacer(),
                      LowframerBox.pill(
                        color: palette.fill,
                        width: 10,
                        height: 10,
                      ),
                    ],
                  ),
                  const Spacer(),
                  LowframerBox(color: palette.fillStrong, width: 48, height: 5),
                  const SizedBox(height: 4),
                  LowframerBox.line(color: palette.fill, width: 78),
                  const Spacer(),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: LowframerBox.pill(
                          color: palette.fill,
                          width: double.infinity,
                        ),
                      ),
                      Expanded(
                        child: LowframerBox.pill(
                          color: palette.accent,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
