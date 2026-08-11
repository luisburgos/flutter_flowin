import 'package:flutter_flowin/flutter_flowin.dart';

/// A body holding a text field and a chip group.
///
/// No autofocus: the playground rebuilds on every knob change, so grabbing
/// focus would fight whichever control was just used.
class SheetFormBody extends StatelessWidget {
  /// {@macro sheet_form_body}
  const SheetFormBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: FlowinDesignSpace.space200,
        horizontal: FlowinDesignSpace.space800,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: FlowinDesignSpace.space300,
        children: [
          const FlowinLabeledTextField(
            label: 'Board name',
            hintText: 'Q3 roadmap',
          ),
          FlowinChipGroup(
            labels: const ['Personal', 'Team', 'Public'],
            initialSelectedIndex: 1,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
