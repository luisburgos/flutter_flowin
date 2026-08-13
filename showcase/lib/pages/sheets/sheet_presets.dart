import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/pages/sheets/sheet_config.dart';

/// The five shapes from the design reference.
///
/// Each was a separate demo trigger before. As presets they do the same
/// teaching, but the settings that produce a shape are visible and can be
/// mutated from, which a fixed example cannot offer.
const sheetPresets = <FlowinPlaygroundPreset<SheetConfig>>[
  FlowinPlaygroundPreset(
    label: 'Simple',
    summary: 'Title, subtitle, close.',
    config: SheetConfig(hasSubtitle: true),
  ),
  FlowinPlaygroundPreset(
    label: 'Confirmation',
    summary: 'Icon and two actions.',
    config: SheetConfig(
      hasIcon: true,
      hasSubtitle: true,
      footer: FooterChoice.pair,
    ),
  ),
  FlowinPlaygroundPreset(
    label: 'Form',
    summary: 'A text field and a single action.',
    config: SheetConfig(
      hasIcon: true,
      body: BodyChoice.form,
      footer: FooterChoice.single,
    ),
  ),
  FlowinPlaygroundPreset(
    label: 'Action menu',
    summary: 'Item buttons, no footer.',
    config: SheetConfig(body: BodyChoice.list),
  ),
  FlowinPlaygroundPreset(
    label: 'Share',
    summary: 'A full-bleed panel and one action.',
    config: SheetConfig(
      body: BodyChoice.fullBleed,
      footer: FooterChoice.single,
    ),
  ),
];
