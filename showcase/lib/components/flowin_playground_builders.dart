import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

// Dresses every Playground in the showcase with flutter_flowin's own chrome.
//
// playgrounder is design-system-agnostic: its inspector tabs, preset rows and
// action buttons are stock Material unless a builder replaces them. These
// replace all three with Flowin widgets, so the showcase's playgrounds are
// indistinguishable from the hand-built ones they replaced.
//
// Top-level functions rather than closures: a playground theme compares its
// builders by identity, so a hoisted function keeps two equal themes equal and
// stops the chrome rebuilding for nothing.
//
// Wired once at the app root (see main.dart), so every page inherits them
// without repeating the theme per playground.

/// Builds the inspector's Presets/Custom tabs as [FlowinTabs].
Widget flowinPlaygroundTabs(
  BuildContext context,
  PlaygroundTabsDetails details,
) {
  return FlowinTabs(
    controller: details.controller,
    tabs: [for (final label in details.labels) FlowinTabItem(label: label)],
  );
}

/// Builds one preset row as a tonal [FlowinItemButton].
Widget flowinPlaygroundPresetRow(
  BuildContext context,
  PlaygroundPresetRowDetails details,
) {
  return FlowinItemButton.tonal(
    onPressed: details.onPressed,
    icon: (details.selected ? FDIcons.done : FDIcons.board).toIcon(),
    label: details.label,
  );
}

/// Builds one pinned action as a full-width tonal [FlowinButton].
Widget flowinPlaygroundActionButton(
  BuildContext context,
  PlaygroundActionDetails details,
) {
  return SizedBox(
    width: double.infinity,
    child: FlowinButton.tonal(
      onPressed: details.onPressed,
      size: FlowinButtonSize.md,
      icon: details.icon,
      label: details.label,
    ),
  );
}

/// The tint the preview stage paints behind a subject.
///
/// The Flowin scheme leaves the container roles at plain surface, so a
/// container tint would vanish. outlineVariant is a real neutral there.
/// See flowin_pm#33.
Color flowinPlaygroundStage(BuildContext context) =>
    context.colorScheme.outlineVariant;
