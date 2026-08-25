import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/fields/text_field_config.dart';
import 'package:flowin_showcase/pages/fields/text_field_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// The width the field is previewed at.
///
/// A text field stretches to its parent, so at full stage width it renders far
/// wider than any real form gives it.
const _fieldMaxWidth = 380.0;

/// Lines shown when the multiline knob is on.
const _multilineRows = 4;

/// One preset per arrangement, spanning both classes.
///
/// The first three build a [FlowinLabeledTextField]; the last drops the label
/// and so builds a bare [FlowinTextField].
const _presets = <PlaygroundPreset<TextFieldConfig>>[
  PlaygroundPreset(
    label: 'Editing a value',
    summary: 'A form field the user is changing rather than filling in fresh.',
    config: TextFieldConfig(),
  ),
  PlaygroundPreset(
    label: 'Empty with a hint',
    summary: 'When the expected format needs showing — a phone, a code.',
    config: TextFieldConfig(hasInitialValue: false, hasHint: true),
  ),
  PlaygroundPreset(
    label: 'Notes',
    summary: 'Prose the user writes at length, so the field grows to fit.',
    config: TextFieldConfig(multiline: true),
  ),
  PlaygroundPreset(
    label: 'Read only',
    summary: 'A value shown in place rather than moved to a separate view.',
    config: TextFieldConfig(enabled: false),
  ),
];

/// A playground for [FlowinTextField] and its labelled composition,
/// [FlowinLabeledTextField].
class TextFieldsPage extends StatefulWidget {
  /// {@macro text_fields_page}
  const TextFieldsPage({super.key});

  @override
  State<TextFieldsPage> createState() => _TextFieldsPageState();
}

class _TextFieldsPageState extends State<TextFieldsPage> {
  TextFieldConfig _config = const TextFieldConfig();

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Text fields',
      dividedAppBar: true,
      body: Playground<TextFieldConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        previewMaxWidth: _fieldMaxWidth,
        // Surface, not the default tint: the field's fill and outline come
        // from inputDecorationTheme's neutrals, which the tint would swallow.
        previewBackground: context.colorScheme.surface,
        previewBuilder: (context, config) {
          final initialValue = config.hasInitialValue
              ? 'Weekday mornings'
              : null;
          final hintText = config.hasHint ? '+52 55 0000 0000' : null;
          final maxLines = config.multiline ? _multilineRows : 1;

          // `initialValue` seeds the field's own state on first build only, so
          // a knob that changes it would otherwise leave the old text in
          // place. Keying on it rebuilds the field instead of updating it.
          final valueKey = ValueKey('$initialValue-${config.multiline}');

          if (!config.hasLabel) {
            return FlowinTextField(
              key: valueKey,
              initialValue: initialValue,
              hintText: hintText,
              maxLines: maxLines,
              enabled: config.enabled,
            );
          }

          return FlowinLabeledTextField(
            key: valueKey,
            label: 'Availability',
            initialValue: initialValue,
            hintText: hintText,
            maxLines: maxLines,
            enabled: config.enabled,
          );
        },
        knobsBuilder: (context, config, onChanged) =>
            TextFieldKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
