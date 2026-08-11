import 'package:flutter_flowin/flutter_flowin.dart';

/// A labelled row used to caption an individual demo widget.
class ShowcaseRow extends StatelessWidget {
  /// {@macro showcase_row}
  const ShowcaseRow({required this.label, required this.child, super.key});

  /// The caption shown above [child].
  final String label;

  /// The demo widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.spacing.xxs),
          child,
        ],
      ),
    );
  }
}
