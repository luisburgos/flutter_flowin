import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:showcaser/showcaser.dart';

/// Draws the showcase gallery's tiles with flutter_flowin's own chrome.
///
/// showcaser is design-system-agnostic: its tiles are a stock Material [Card]
/// unless a [ShowcaseTileBuilder] replaces them. This substitutes the tonal
/// item button the catalogue index has always used, so the gallery is
/// indistinguishable from the hand-built one it replaced.
///
/// The sibling of `FlowinStyle` for playgrounder — one seam each, injected the
/// same way, so the two packages are adopted by the same pattern.
class FlowinTileBuilder extends ShowcaseTileBuilder {
  /// Creates the Flowin tile builder.
  const FlowinTileBuilder();

  @override
  Widget buildTile(
    BuildContext context, {
    required ShowcaseEntry entry,
    required Widget content,
    required VoidCallback onPressed,
  }) {
    return FlowinItemButton.tonal(
      onPressed: onPressed,
      child: content,
    );
  }
}
