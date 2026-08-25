import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// Dresses every [Playground] in the showcase with flutter_flowin's own chrome.
///
/// playgrounder is design-system-agnostic: its inspector tabs, preset rows and
/// action buttons are stock Material unless a [PlaygroundStyle] overrides them.
/// This style overrides all four points with Flowin widgets, so the showcase's
/// playgrounds are indistinguishable from the hand-built ones they replaced.
///
/// Scoped once at the app root (see `main.dart`), so every page inherits it
/// without wiring it per playground.
class FlowinStyle extends PlaygroundStyle {
  /// Creates the Flowin playground style.
  const FlowinStyle();

  @override
  Widget buildTabs(
    BuildContext context, {
    required TabController controller,
    required List<String> labels,
  }) {
    return FlowinTabs(
      controller: controller,
      tabs: [for (final label in labels) FlowinTabItem(label: label)],
    );
  }

  @override
  Widget buildPresetRow(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return FlowinItemButton.tonal(
      onPressed: onPressed,
      icon: (selected ? FDIcons.done : FDIcons.board).toIcon(),
      label: label,
    );
  }

  @override
  Widget buildActionButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
    Widget? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FlowinButton.tonal(
        onPressed: onPressed,
        size: FlowinButtonSize.md,
        icon: icon,
        label: label,
      ),
    );
  }

  @override
  Color stageBackground(BuildContext context) {
    // The Flowin scheme leaves the container roles at plain surface, so a
    // container tint would vanish. outlineVariant is a real neutral there.
    // See flowin_pm#33.
    return context.colorScheme.outlineVariant;
  }
}
