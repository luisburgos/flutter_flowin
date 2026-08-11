import 'package:flowin_showcase/pages/fields/input_field_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The demo content placed in a [FlowinInputField]'s child slot.
///
/// A widget rather than a builder method so each choice keeps its own element
/// — the chip group holds selection state, which a rebuilt closure would drop.
class InputFieldChildDemo extends StatelessWidget {
  /// {@macro input_field_child_demo}
  const InputFieldChildDemo({required this.child, super.key});

  /// Which demo content to render.
  final InputFieldChild child;

  @override
  Widget build(BuildContext context) {
    return switch (child) {
      InputFieldChild.iconAndValue => Row(
        spacing: FlowinDesignSpace.space300,
        children: [
          FDIcons.timer.toIcon(size: FlowinDesignIconSize.sm),
          Text('Weekdays', style: context.textTheme.bodyLarge),
        ],
      ),
      InputFieldChild.chipGroup => FlowinChipGroup(
        labels: const ['Private', 'Team'],
        isScrollable: false,
        padding: EdgeInsets.zero,
        onSelected: (_) {},
      ),
      InputFieldChild.text => Text(
        'Any widget fits here.',
        style: context.textTheme.bodyLarge,
      ),
    };
  }
}
