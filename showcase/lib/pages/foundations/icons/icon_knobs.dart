import 'package:flowin_showcase/components/flowin_showcase_dropdown.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/pages/foundations/icons/icon_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

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
        FlowinPlaygroundKnobGroup(
          title: 'Size',
          children: [
            FlowinShowcaseDropdown<FlowinDesignIconSize>(
              value: config.size,
              values: FlowinDesignIconSize.values,
              // The pixel value is the fact a reader needs; the token name
              // alone does not say how big md actually is.
              labelOf: (v) => '${v.name} — ${v.value.toInt()}px',
              onChanged: (v) => onChanged(config.copyWith(size: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'Labels',
          children: [
            FlowinPlaygroundSwitchKnob(
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
