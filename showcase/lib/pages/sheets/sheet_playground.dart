import 'package:flowin_showcase/pages/sheets/sheet_config.dart';
import 'package:flowin_showcase/pages/sheets/sheet_knobs.dart';
import 'package:flowin_showcase/pages/sheets/sheet_presets.dart';
import 'package:flowin_showcase/pages/sheets/sheet_preview.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// The width the modal clamps itself to on wide viewports.
///
/// Mirrors `showFlowinActionSheet`'s own default so the preview renders at a
/// width the sheet can actually reach.
const _sheetMaxWidth = 480.0;

/// Wires [FlowinActionSheet] into a [Playground].
///
/// Holds the only two things that need state: the current configuration, and
/// the modal presentation, which needs a context to push a route from.
///
/// The header's title-placement rule is why this is interactive rather than a
/// set of static examples: the bar holds one leading element, so switching the
/// icon on displaces the title into the supporting block and off pulls it
/// back. That movement is the rule, and no still frame shows movement.
class SheetPlayground extends StatefulWidget {
  /// {@macro sheet_playground}
  const SheetPlayground({super.key});

  @override
  State<SheetPlayground> createState() => _SheetPlaygroundState();
}

class _SheetPlaygroundState extends State<SheetPlayground> {
  SheetConfig _config = sheetPresets[1].config;

  /// Presents the current configuration as a real modal.
  ///
  /// The scrim, the 480 clamp and the keyboard lift only exist in a modal
  /// presentation, so the inline preview cannot show them however faithful it
  /// is otherwise. This is the only place they are reachable.
  Future<void> _openAsModal() async {
    await showFlowinActionSheet<void>(
      context: context,
      builder: (sheetContext) => SheetPreview.modal(
        _config,
        onAction: () => sheetContext.popFlowinActionSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Playground<SheetConfig>(
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: sheetPresets,
      previewMaxWidth: _sheetMaxWidth,
      previewBuilder: (context, config) => SheetPreview.inline(config),
      knobsBuilder: (context, config, onChanged) =>
          SheetKnobs(config: config, onChanged: onChanged),
      footer: PlaygroundActions(
        actions: [
          PlaygroundAction(
            label: 'Open as modal',
            icon: FDIcons.more.toIcon(size: FlowinDesignIconSize.sm),
            onPressed: _openAsModal,
          ),
        ],
      ),
    );
  }
}
