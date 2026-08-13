import 'package:flowin_showcase/components/flowin_showcase_dropdown.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_spacing_knob.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_step_knob.dart';
import 'package:flowin_showcase/pages/cards/card_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Display text for each radius choice.
String _radiusLabel(CardRadius radius) => switch (radius) {
  CardRadius.themed => 'From the theme',
  CardRadius.medium => 'Medium (radius400)',
  CardRadius.large => 'Large (radius1000)',
  CardRadius.asymmetric => 'Asymmetric',
};

/// Display text for each height choice.
///
/// The pixel value alongside the name, like the spacing knob: a card pinned to
/// "regular" tells a reader nothing about how tall that is.
String _heightLabel(CardHeight height) =>
    '${height.name} — ${height.value.toInt()}px';

/// Display text for each fill choice.
String _fillLabel(CardFill fill) => switch (fill) {
  CardFill.themed => 'From the theme',
  CardFill.dataDark => 'Data — dark',
  CardFill.dataLight => 'Data — light',
  CardFill.transparent => 'Transparent',
};

/// The inspector's controls for a [CardConfig].
class CardKnobs extends StatelessWidget {
  /// {@macro card_knobs}
  const CardKnobs({required this.config, required this.onChanged, super.key});

  /// The configuration the knobs reflect.
  final CardConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<CardConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    final resolvesAgainstFill = FlowinKnobRelevance.when(
      isRelevant: config.fill != CardFill.transparent,
      reason:
          'a transparent fill is whatever sits behind the card, which the '
          'card cannot see, so it is never resolved against',
    );
    final seedsTheResolver = FlowinKnobRelevance.when(
      isRelevant: config.resolveForeground || config.compareContrast,
      reason:
          'the preference is what the resolver starts from, and nothing '
          'is being resolved',
    );
    final resolverIsChosen = FlowinKnobRelevance.when(
      isRelevant: !config.compareContrast,
      reason:
          'the comparison shows both settings at once, so it drives this '
          'rather than the knob',
    );
    final contentIsInset = FlowinKnobRelevance.when(
      isRelevant: !config.clipChild,
      reason:
          'a clipped child is meant to reach the corners it is clipped to, '
          'so it takes no inset',
    );
    final heightIsPinned = FlowinKnobRelevance.when(
      isRelevant: !config.intrinsicHeight,
      reason: 'the content is deciding the height, so there is none to pin',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        FlowinPlaygroundKnobGroup(
          title: 'Shape',
          children: [
            FlowinShowcaseDropdown<CardRadius>(
              value: config.radius,
              values: CardRadius.values,
              labelOf: _radiusLabel,
              onChanged: (v) => onChanged(config.copyWith(radius: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'Fill',
          children: [
            FlowinShowcaseDropdown<CardFill>(
              value: config.fill,
              values: CardFill.values,
              labelOf: _fillLabel,
              onChanged: (v) => onChanged(config.copyWith(fill: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'Height',
          children: [
            FlowinPlaygroundSwitchKnob(
              label: 'Size to content',
              value: config.intrinsicHeight,
              onChanged: (v) => onChanged(config.copyWith(intrinsicHeight: v)),
            ),
            FlowinPlaygroundStepKnob<CardHeight>(
              label: 'Pinned to',
              value: config.height,
              values: CardHeight.values,
              labelOf: _heightLabel,
              relevantWhen: heightIsPinned,
              onChanged: (v) => onChanged(config.copyWith(height: v)),
            ),
          ],
        ),
        // Padding and margin together: they are the same scale applied on
        // either side of the card's edge, and reading them side by side is
        // what makes the difference obvious.
        FlowinPlaygroundKnobGroup(
          title: 'Spacing',
          children: [
            FlowinPlaygroundSpacingKnob(
              label: 'Padding',
              value: config.padding,
              relevantWhen: contentIsInset,
              onChanged: (v) => onChanged(config.copyWith(padding: v)),
            ),
            FlowinPlaygroundSpacingKnob(
              label: 'Margin',
              value: config.margin,
              onChanged: (v) => onChanged(config.copyWith(margin: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'Surface',
          children: [
            FlowinPlaygroundSwitchKnob(
              label: 'Bordered',
              value: config.bordered,
              onChanged: (v) => onChanged(config.copyWith(bordered: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'Elevated',
              value: config.elevated,
              onChanged: (v) => onChanged(config.copyWith(elevated: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'Clip child',
              value: config.clipChild,
              onChanged: (v) => onChanged(config.copyWith(clipChild: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'Content colour',
          relevantWhen: resolvesAgainstFill,
          children: [
            FlowinPlaygroundSwitchKnob(
              label: 'Compare with inherited',
              value: config.compareContrast,
              onChanged: (v) => onChanged(config.copyWith(compareContrast: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'Resolve against fill',
              value: config.resolveForeground,
              relevantWhen: resolverIsChosen,
              onChanged: (v) =>
                  onChanged(config.copyWith(resolveForeground: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'Prefer cream',
              value: config.preferCream,
              relevantWhen: seedsTheResolver,
              onChanged: (v) => onChanged(config.copyWith(preferCream: v)),
            ),
          ],
        ),
      ],
    );
  }
}
