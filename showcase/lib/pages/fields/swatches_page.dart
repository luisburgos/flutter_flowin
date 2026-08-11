import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/fields/swatch_config.dart';
import 'package:flowin_showcase/pages/fields/swatch_knobs.dart';
import 'package:flowin_showcase/pages/fields/swatch_preview.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The width the picker field is previewed at.
///
/// The field stretches to its parent, and its swatch row scrolls, so at full
/// stage width the row never fills and the scrolling never shows.
const _fieldMaxWidth = 380.0;

/// One preset per way the swatch is reached.
const _presets = <FlowinPlaygroundPreset<SwatchConfig>>[
  FlowinPlaygroundPreset(
    label: 'Picking a colour',
    summary: 'A row of choices where one is currently held.',
    config: SwatchConfig(),
  ),
  FlowinPlaygroundPreset(
    label: 'Nothing picked',
    summary: 'Before a choice is made, so no swatch carries the ring.',
    config: SwatchConfig(selected: false),
  ),
  FlowinPlaygroundPreset(
    label: 'Presets only',
    summary: 'When the palette is fixed and a custom colour is not offered.',
    config: SwatchConfig(showGradient: false),
  ),
  FlowinPlaygroundPreset(
    label: 'In a form',
    summary: 'The composed field, when a colour is one value among several.',
    config: SwatchConfig(subject: SwatchSubject.pickerField),
  ),
];

/// A playground for [FlowinColorRadialButton] and the field that composes it,
/// [FlowinColorPickerField].
class SwatchesPage extends StatefulWidget {
  /// {@macro swatches_page}
  const SwatchesPage({super.key});

  @override
  State<SwatchesPage> createState() => _SwatchesPageState();
}

class _SwatchesPageState extends State<SwatchesPage> {
  SwatchConfig _config = const SwatchConfig();

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Colour swatches',
      dividedAppBar: true,
      body: FlowinPlayground<SwatchConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        previewMaxWidth: _fieldMaxWidth,
        // Surface, not the default tint: the palette includes white and black
        // swatches, and the swatch carves its selection ring by letting the
        // background through — so the stage colour is part of what is on show.
        previewBackground: context.colorScheme.surface,
        previewBuilder: (context, config) => switch (config.subject) {
          SwatchSubject.swatches => SwatchRowDemo(config: config),
          // Keyed so a return to this subject starts from the seeded colour
          // rather than keeping whatever the last visit left selected.
          SwatchSubject.pickerField => FlowinColorPickerField(
            key: const ValueKey('picker-field'),
            label: 'Accent',
            predefinedColors: swatchPalette,
            initialColor: swatchPalette.first,
          ),
        },
        knobsBuilder: (context, config, onChanged) =>
            SwatchKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
