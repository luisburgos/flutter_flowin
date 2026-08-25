import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/fields/input_field_child.dart';
import 'package:flowin_showcase/pages/fields/input_field_config.dart';
import 'package:flowin_showcase/pages/fields/input_field_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// The width the field is previewed at.
///
/// The field stretches to its parent, so at full stage width it renders far
/// wider than any real form gives it — and the label, pinned to the leading
/// edge, drifts away from the content it names.
const _fieldMaxWidth = 380.0;

/// One preset per arrangement the field is actually used in.
const _presets = <PlaygroundPreset<InputFieldConfig>>[
  PlaygroundPreset(
    label: 'Labelled',
    summary: 'Naming a value the user did not type — a picked date, a state.',
    config: InputFieldConfig(),
  ),
  PlaygroundPreset(
    label: 'Wrapping a control',
    summary: 'Giving an interactive child the same chrome as a text input.',
    config: InputFieldConfig(child: InputFieldChild.chipGroup),
  ),
  PlaygroundPreset(
    label: 'Bare',
    summary: 'When the surrounding layout already says what the field is.',
    config: InputFieldConfig(child: InputFieldChild.text, hasLabel: false),
  ),
  PlaygroundPreset(
    label: 'Label only',
    summary: 'When the child draws its own border and a second would double.',
    config: InputFieldConfig(child: InputFieldChild.text, surface: false),
  ),
];

/// A playground for [FlowinInputField], the generic labelled-field primitive.
class InputFieldsPage extends StatefulWidget {
  /// {@macro input_fields_page}
  const InputFieldsPage({super.key});

  @override
  State<InputFieldsPage> createState() => _InputFieldsPageState();
}

class _InputFieldsPageState extends State<InputFieldsPage> {
  InputFieldConfig _config = const InputFieldConfig();

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Input fields',
      dividedAppBar: true,
      body: Playground<InputFieldConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        previewMaxWidth: _fieldMaxWidth,
        // Surface, not the default tint: the field's border is outlineVariant,
        // which is the tint's own colour — on the tinted stage the surface it
        // draws would vanish into the background.
        previewBackground: context.colorScheme.surface,
        previewBuilder: (context, config) => FlowinInputField(
          label: config.hasLabel ? 'Availability' : null,
          surface: config.surface,
          child: InputFieldChildDemo(child: config.child),
        ),
        knobsBuilder: (context, config, onChanged) =>
            InputFieldKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
