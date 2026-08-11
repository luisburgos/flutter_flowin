import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/pages/chips/chip_pager_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The inspector's controls for a [ChipPagerConfig].
class ChipPagerKnobs extends StatelessWidget {
  /// {@macro chip_pager_knobs}
  const ChipPagerKnobs({
    required this.config,
    required this.onChanged,
    super.key,
  });

  /// The configuration the knobs reflect.
  final ChipPagerConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<ChipPagerConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return FlowinPlaygroundKnobGroup(
      title: 'Layout',
      children: [
        FlowinPlaygroundSwitchKnob(
          label: 'Scrollable chips',
          value: config.isScrollable,
          onChanged: (v) => onChanged(config.copyWith(isScrollable: v)),
        ),
        FlowinPlaygroundSwitchKnob(
          label: 'Divider',
          value: config.showDivider,
          onChanged: (v) => onChanged(config.copyWith(showDivider: v)),
        ),
      ],
    );
  }
}
