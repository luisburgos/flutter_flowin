import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:showcaser/showcaser.dart';

/// Dresses the showcase gallery with flutter_flowin's own chrome.
///
/// showcaser is design-system-agnostic: its entry tiles are a stock Material
/// [Card] unless a [ShowcaseStyle] overrides them. This style substitutes the
/// tonal item button the catalogue index has always used, so the gallery is
/// indistinguishable from the hand-built one it replaced.
///
/// The sibling of `FlowinStyle` for playgrounder — one seam each, injected
/// the same way, so the two packages are adopted by the same pattern.
class FlowinShowcaseStyle extends ShowcaseStyle {
  /// Creates the Flowin gallery style.
  const FlowinShowcaseStyle();

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
