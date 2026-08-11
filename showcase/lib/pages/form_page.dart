import 'package:flowin_showcase/components/showcase/showcase_row.dart';
import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/components/showcase/showcase_section.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The field components: the generic input field, text-field states, and the
/// colour-swatch primitive.
///
/// The realistic form that composes them lives under Examples → Profile.
class FormPage extends StatefulWidget {
  /// {@macro form_page}
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Color _accent = _palette.first;

  /// A demo palette of visually distinct colours.
  ///
  /// Deliberately NOT primary/secondary/tertiary: those three brand ramps are
  /// byte-identical neutrals in the Flowin palette (every step, `#7A7A7A` at
  /// 500), so sampling them here rendered three identical grey swatches. Only
  /// the semantic ramps carry hue, so the palette walks their steps instead —
  /// a picker demo needs colours a viewer can tell apart.
  /// Hues alternate rather than grouping by ramp, so any prefix of this list
  /// stays visually distinct — the swatch demo below renders only the first
  /// four.
  static const List<Color> _palette = [
    FlowinDesignColors.error400,
    FlowinDesignColors.warning600,
    FlowinDesignColors.success500,
    FlowinDesignColors.black,
    FlowinDesignColors.white,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold.paged(
      title: 'Fields',
      sections: [
        ShowcaseSection(
          chipLabel: 'Generic field',
          title: 'FlowinInputField — any child',
          description:
              'The generic labelled field: a stacked label above a bordered '
              'surface wrapping whatever you put in it. FlowinColorPickerField '
              'is this component with a swatch row as its child.',
          children: [
            FlowinInputField(
              label: 'Availability',
              child: Row(
                spacing: FlowinDesignSpace.space300,
                children: [
                  FDIcons.timer.toIcon(size: FlowinDesignIconSize.sm),
                  Text('Weekdays', style: context.textTheme.bodyLarge),
                ],
              ),
            ),
            SizedBox(height: context.spacing.sm),
            FlowinInputField(
              label: 'Visibility',
              child: FlowinChipGroup(
                labels: const ['Private', 'Team'],
                isScrollable: false,
                onSelected: (_) {},
              ),
            ),
            SizedBox(height: context.spacing.sm),
            const FlowinInputField(
              child: Text('No label — the surface renders on its own.'),
            ),
          ],
        ),
        const ShowcaseSection(
          chipLabel: 'Field states',
          title: 'FlowinTextField — states',
          children: [
            ShowcaseRow(
              label: 'with initial value',
              child: FlowinTextField(initialValue: 'Prefilled text'),
            ),
            ShowcaseRow(
              label: 'disabled',
              child: FlowinTextField(
                initialValue: 'Read only',
                enabled: false,
              ),
            ),
            ShowcaseRow(
              label: 'digits only',
              child: FlowinTextField(hintText: '0000 0000'),
            ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Swatches',
          title: 'FlowinColorRadialButton',
          description:
              'The swatch primitive behind FlowinColorPickerField. Tap one to '
              'drive the gradient variant beside it.',
          children: [
            ShowcaseRow(
              label: 'selected vs unselected, plus the gradient variant',
              child: Row(
                spacing: FlowinDesignSpace.space300,
                children: [
                  for (final color in _palette.take(4))
                    FlowinColorRadialButton(
                      color: color,
                      selected: color.toARGB32() == _accent.toARGB32(),
                      onTap: () => setState(() => _accent = color),
                    ),
                  FlowinColorRadialButton.gradient(
                    color: _accent,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
