import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/buttons/icon_button_config.dart';
import 'package:flowin_showcase/pages/buttons/icon_button_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// One preset per variant.
const _presets = <PlaygroundPreset<IconButtonConfig>>[
  PlaygroundPreset(
    label: 'Filled',
    summary: 'Solid, high emphasis.',
    config: IconButtonConfig(),
  ),
  PlaygroundPreset(
    label: 'Tonal',
    summary: 'Medium emphasis — the close button on a sheet.',
    config: IconButtonConfig(variant: FlowinIconButtonVariant.tonal),
  ),
  PlaygroundPreset(
    label: 'Text',
    summary: 'Glyph only — an app bar back button.',
    config: IconButtonConfig(variant: FlowinIconButtonVariant.text),
  ),
  PlaygroundPreset(
    label: 'Destructive',
    summary: 'For an action that removes something.',
    config: IconButtonConfig(variant: FlowinIconButtonVariant.destructive),
  ),
];

/// A playground for [FlowinIconButton]: circular, icon-only buttons.
class IconButtonsPage extends StatefulWidget {
  /// {@macro icon_buttons_page}
  const IconButtonsPage({super.key});

  @override
  State<IconButtonsPage> createState() => _IconButtonsPageState();
}

class _IconButtonsPageState extends State<IconButtonsPage> {
  IconButtonConfig _config = const IconButtonConfig();

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Icon buttons',
      dividedAppBar: true,
      body: Playground<IconButtonConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        // Surface, not the default tint: outlineVariant and
        // secondaryContainer resolve to the same value, so a tonal button on
        // the default stage would be invisible.
        previewBackground: context.colorScheme.surface,
        previewBuilder: (context, config) => FlowinIconButton(
          variant: config.variant,
          size: config.size,
          icon: FDIcons.plus.toIcon(),
          onPressed: config.enabled ? () {} : null,
        ),
        knobsBuilder: (context, config, onChanged) =>
            IconButtonKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
