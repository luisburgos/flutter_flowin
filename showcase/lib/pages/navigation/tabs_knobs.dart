import 'package:flowin_showcase/components/flowin_showcase_dropdown.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/pages/navigation/tabs_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Display text for each count choice.
String _countLabel(TabCount count) => switch (count) {
  TabCount.few => 'Three',
  TabCount.many => 'Eight',
};

/// The inspector's controls for a [TabsConfig].
class TabsKnobs extends StatelessWidget {
  /// {@macro tabs_knobs}
  const TabsKnobs({required this.config, required this.onChanged, super.key});

  /// The configuration the knobs reflect.
  final TabsConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<TabsConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        FlowinPlaygroundKnobGroup(
          title: 'Layout',
          children: [
            FlowinPlaygroundSwitchKnob(
              label: 'Scrollable',
              value: config.isScrollable,
              onChanged: (v) => onChanged(config.copyWith(isScrollable: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'Tabs',
          children: [
            FlowinShowcaseDropdown<TabCount>(
              value: config.count,
              values: TabCount.values,
              labelOf: _countLabel,
              onChanged: (v) => onChanged(config.copyWith(count: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'Show icons',
              value: config.hasIcons,
              onChanged: (v) => onChanged(config.copyWith(hasIcons: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'One long label',
              value: config.longLabel,
              onChanged: (v) => onChanged(config.copyWith(longLabel: v)),
            ),
          ],
        ),
      ],
    );
  }
}
