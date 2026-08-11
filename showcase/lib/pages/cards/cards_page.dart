import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_spacing_knob.dart';
import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/cards/card_config.dart';
import 'package:flowin_showcase/pages/cards/card_knobs.dart';
import 'package:flowin_showcase/pages/cards/card_preview.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The width the card is previewed at.
///
/// A card stretches to its parent, so at full stage width it renders wider
/// than any real caller gives it and the corner treatment stops being legible
/// against the card's own length.
const _cardMaxWidth = 420.0;

/// One preset per job a card is actually doing.
const _presets = <FlowinPlaygroundPreset<CardConfig>>[
  FlowinPlaygroundPreset(
    label: 'Grouping content',
    summary: 'The default surface, when a block needs to read as one thing.',
    config: CardConfig(),
  ),
  FlowinPlaygroundPreset(
    label: 'Outlined',
    summary: 'A boundary without a fill, when the page already sets the tone.',
    config: CardConfig(fill: CardFill.transparent, bordered: true),
  ),
  FlowinPlaygroundPreset(
    label: 'Raised',
    summary: 'Lifted off the page, for something overlaying what is behind.',
    config: CardConfig(elevated: true),
  ),
  FlowinPlaygroundPreset(
    label: 'Filled from data',
    summary: 'A colour the theme cannot see, kept readable by the card.',
    config: CardConfig(fill: CardFill.dataDark, bordered: true),
  ),
  FlowinPlaygroundPreset(
    label: 'Contrast',
    summary: 'What the resolver buys: the same fill, resolved and inherited.',
    config: CardConfig(
      fill: CardFill.dataDark,
      bordered: true,
      compareContrast: true,
    ),
  ),
  FlowinPlaygroundPreset(
    label: 'Dense',
    summary: 'A tight inset, for a card repeated down a list.',
    config: CardConfig(padding: SpacingStep.xs),
  ),
  FlowinPlaygroundPreset(
    label: 'Inset in a list',
    summary: 'Held off its neighbours, for a card among other cards.',
    config: CardConfig(margin: SpacingStep.md),
  ),
  FlowinPlaygroundPreset(
    label: 'Sized to content',
    summary: 'No pinned height, which is how most callers use a card.',
    config: CardConfig(intrinsicHeight: true),
  ),
  FlowinPlaygroundPreset(
    label: 'Media',
    summary: 'Content painted to the edges, held inside the smooth corners.',
    config: CardConfig(radius: CardRadius.large, clipChild: true),
  ),
];

/// A playground for [FlowinCard].
class CardsPage extends StatefulWidget {
  /// {@macro cards_page}
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  CardConfig _config = const CardConfig();

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Cards & surfaces',
      dividedAppBar: true,
      body: FlowinPlayground<CardConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        previewMaxWidth: _cardMaxWidth,
        // Surface, not the default tint: the tint is outlineVariant, which is
        // both the card's own themed fill and the colour its border is drawn
        // in, so a themed or outlined card would vanish into the stage.
        previewBackground: context.colorScheme.surface,
        // Bounded so the margin knob has something to push against: margin is
        // space outside the card, so without a visible edge it would look
        // identical to the card simply getting smaller.
        previewBuilder: (context, config) => CardMarginBounds(
          child: config.compareContrast
              ? CardContrastDemo(config: config)
              : CardDemo(config: config),
        ),
        knobsBuilder: (context, config, onChanged) =>
            CardKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
