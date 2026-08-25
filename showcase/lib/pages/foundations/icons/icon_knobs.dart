import 'package:flowin_showcase/pages/foundations/icons/icon_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// The inspector's controls for an [IconConfig].
class IconKnobs extends StatelessWidget {
  /// {@macro icon_knobs}
  const IconKnobs({required this.config, required this.onChanged, super.key});

  /// The configuration the knobs reflect.
  final IconConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<IconConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        KnobGroup(
          title: 'Size',
          children: [
            // A slider, not a dropdown: the size scale is ordered, and sweeping
            // it is how a reader finds the step where a glyph stops being
            // legible. The whole grid resizes at once, so the sweep reads as a
            // single continuous change rather than six separate choices.
            StepKnob<FlowinDesignIconSize>(
              label: 'Icon size',
              value: config.size,
              values: FlowinDesignIconSize.values,
              // The pixel value is the fact a reader needs; the token name
              // alone does not say how big md actually is.
              labelOf: (v) => '${v.name} — ${v.value.toInt()}px',
              onChanged: (v) => onChanged(config.copyWith(size: v)),
            ),
          ],
        ),
        KnobGroup(
          title: 'Labels',
          children: [
            SwitchKnob(
              label: 'Show names',
              value: config.showLabels,
              onChanged: (v) => onChanged(config.copyWith(showLabels: v)),
            ),
          ],
        ),
      ],
    );
  }
}
