import 'package:flowin_showcase/components/flowin_showcase_dropdown.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/pages/sheets/sheet_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The inspector's controls for a [SheetConfig].
///
/// Two groups on two axes: the switches toggle whether a header element is
/// there at all, the dropdowns pick what fills a slot.
class SheetKnobs extends StatelessWidget {
  /// {@macro sheet_knobs}
  const SheetKnobs({
    required this.config,
    required this.onChanged,
    super.key,
  });

  /// The configuration the knobs reflect.
  final SheetConfig config;

  /// Called with the configuration a knob produces.
  final ValueChanged<SheetConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        FlowinPlaygroundKnobGroup(
          title: 'Visibility',
          children: [
            FlowinPlaygroundSwitchKnob(
              label: 'Show icon',
              value: config.hasIcon,
              onChanged: (v) => onChanged(config.copyWith(hasIcon: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'Show subtitle',
              value: config.hasSubtitle,
              onChanged: (v) => onChanged(config.copyWith(hasSubtitle: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'Show close',
              value: config.hasClose,
              onChanged: (v) => onChanged(config.copyWith(hasClose: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'Body',
          children: [
            FlowinShowcaseDropdown<BodyChoice>(
              value: config.body,
              values: BodyChoice.values,
              labelOf: (v) => v.label,
              onChanged: (v) => onChanged(config.copyWith(body: v)),
            ),
          ],
        ),
        FlowinPlaygroundKnobGroup(
          title: 'Footer',
          children: [
            FlowinShowcaseDropdown<FooterChoice>(
              value: config.footer,
              values: FooterChoice.values,
              labelOf: (v) => v.label,
              onChanged: (v) => onChanged(config.copyWith(footer: v)),
            ),
          ],
        ),
      ],
    );
  }
}
