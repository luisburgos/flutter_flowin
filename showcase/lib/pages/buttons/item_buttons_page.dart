import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/buttons/item_button_config.dart';
import 'package:flowin_showcase/pages/buttons/item_button_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The width a list row is previewed at.
///
/// Item buttons stretch to their parent, so an unclamped preview would show
/// one running the full width of the stage — a width no real list gives it.
const _rowMaxWidth = 420.0;

/// One preset per variant.
const _presets = <FlowinPlaygroundPreset<ItemButtonConfig>>[
  FlowinPlaygroundPreset(
    label: 'Tonal',
    summary: 'The default — a menu or settings row.',
    config: ItemButtonConfig(),
  ),
  FlowinPlaygroundPreset(
    label: 'Filled',
    summary: 'Solid, for the row that is the point of the list.',
    config: ItemButtonConfig(variant: FlowinItemButtonVariant.filled),
  ),
  FlowinPlaygroundPreset(
    label: 'Outline',
    summary: 'Bordered, medium emphasis.',
    config: ItemButtonConfig(variant: FlowinItemButtonVariant.outline),
  ),
  FlowinPlaygroundPreset(
    label: 'Text',
    summary: 'Unfilled — a row in a dense list.',
    config: ItemButtonConfig(variant: FlowinItemButtonVariant.text),
  ),
];

/// A playground for [FlowinItemButton]: full-width, left-aligned list rows.
class ItemButtonsPage extends StatefulWidget {
  /// {@macro item_buttons_page}
  const ItemButtonsPage({super.key});

  @override
  State<ItemButtonsPage> createState() => _ItemButtonsPageState();
}

class _ItemButtonsPageState extends State<ItemButtonsPage> {
  ItemButtonConfig _config = const ItemButtonConfig();

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Item buttons',
      dividedAppBar: true,
      body: FlowinPlayground<ItemButtonConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        previewMaxWidth: _rowMaxWidth,
        previewBuilder: (context, config) => FlowinItemButton(
          variant: config.variant,
          icon: config.hasIcon ? FDIcons.timer.toIcon() : null,
          onPressed: config.enabled ? () {} : null,
          label: 'Session settings',
        ),
        knobsBuilder: (context, config, onChanged) =>
            ItemButtonKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
