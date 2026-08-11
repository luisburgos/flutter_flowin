import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/buttons/button_config.dart';
import 'package:flowin_showcase/pages/buttons/button_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// One preset per variant: the axis a reader picks along first.
const _presets = <FlowinPlaygroundPreset<ButtonConfig>>[
  FlowinPlaygroundPreset(
    label: 'Filled',
    summary: 'Solid, high emphasis — the primary action.',
    config: ButtonConfig(),
  ),
  FlowinPlaygroundPreset(
    label: 'Tonal',
    summary: 'Medium emphasis — the secondary action.',
    config: ButtonConfig(variant: FlowinButtonVariant.tonal),
  ),
  FlowinPlaygroundPreset(
    label: 'Outline',
    summary: 'Medium emphasis with a border.',
    config: ButtonConfig(variant: FlowinButtonVariant.outline),
  ),
  FlowinPlaygroundPreset(
    label: 'Text',
    summary: 'Label only, lowest emphasis.',
    config: ButtonConfig(variant: FlowinButtonVariant.text),
  ),
  FlowinPlaygroundPreset(
    label: 'Destructive',
    summary: 'For an action that removes something.',
    config: ButtonConfig(variant: FlowinButtonVariant.destructive),
  ),
];

/// A playground for [FlowinButton] across every variant, size and state.
class ButtonsPage extends StatefulWidget {
  /// {@macro buttons_page}
  const ButtonsPage({super.key});

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  ButtonConfig _config = const ButtonConfig();

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Buttons',
      dividedAppBar: true,
      body: FlowinPlayground<ButtonConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        previewBuilder: (context, config) => FlowinButton(
          variant: config.variant,
          size: config.size,
          icon: config.hasIcon
              ? FDIcons.plus.toIcon(size: FlowinDesignIconSize.sm)
              : null,
          // Disabled is a null callback rather than a flag, which is how the
          // widget itself expresses it.
          onPressed: config.enabled ? () {} : null,
          label: 'Button',
        ),
        knobsBuilder: (context, config, onChanged) =>
            ButtonKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
