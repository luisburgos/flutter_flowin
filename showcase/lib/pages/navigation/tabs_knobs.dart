import 'package:flowin_showcase/pages/navigation/tabs_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

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
        KnobGroup(
          title: 'Layout',
          children: [
            SwitchKnob(
              label: 'Scrollable',
              value: config.isScrollable,
              onChanged: (v) => onChanged(config.copyWith(isScrollable: v)),
            ),
          ],
        ),
        KnobGroup(
          title: 'Tabs',
          children: [
            DropdownKnob<TabCount>(
              label: 'Count',
              value: config.count,
              values: TabCount.values,
              labelOf: _countLabel,
              onChanged: (v) => onChanged(config.copyWith(count: v)),
            ),
            SwitchKnob(
              label: 'Show icons',
              value: config.hasIcons,
              onChanged: (v) => onChanged(config.copyWith(hasIcons: v)),
            ),
            SwitchKnob(
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
