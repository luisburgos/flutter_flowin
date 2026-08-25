import 'package:flowin_showcase/pages/sheets/sheet_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

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
        KnobGroup(
          title: 'Visibility',
          children: [
            SwitchKnob(
              label: 'Show icon',
              value: config.hasIcon,
              onChanged: (v) => onChanged(config.copyWith(hasIcon: v)),
            ),
            SwitchKnob(
              label: 'Show subtitle',
              value: config.hasSubtitle,
              onChanged: (v) => onChanged(config.copyWith(hasSubtitle: v)),
            ),
            SwitchKnob(
              label: 'Show close',
              value: config.hasClose,
              onChanged: (v) => onChanged(config.copyWith(hasClose: v)),
            ),
          ],
        ),
        DropdownKnob<BodyChoice>(
          label: 'Body',
          value: config.body,
          values: BodyChoice.values,
          labelOf: (v) => v.label,
          onChanged: (v) => onChanged(config.copyWith(body: v)),
        ),
        DropdownKnob<FooterChoice>(
          label: 'Footer',
          value: config.footer,
          values: FooterChoice.values,
          labelOf: (v) => v.label,
          onChanged: (v) => onChanged(config.copyWith(footer: v)),
        ),
      ],
    );
  }
}
