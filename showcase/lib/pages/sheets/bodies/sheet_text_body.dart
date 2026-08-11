import 'package:flutter_flowin/flutter_flowin.dart';

/// A body that insets itself to line up with the footer.
class SheetTextBody extends StatelessWidget {
  /// {@macro sheet_text_body}
  const SheetTextBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: FlowinDesignSpace.space600),
      child: Text(
        'The body slot takes any widget. This one insets itself to line up '
        'with the footer.',
      ),
    );
  }
}
