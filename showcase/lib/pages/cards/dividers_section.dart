import 'package:flutter_flowin/flutter_flowin.dart';

/// The height the vertical divider is demonstrated at.
///
/// A VerticalDivider fills its parent, so it needs a bounded one to show at
/// all.
const _verticalDividerHeight = 40.0;

/// The rules that separate content, and where their styling comes from.
///
/// Static rather than a playground: there is no Flowin divider to configure.
/// Both rules are the framework's own, styled entirely by the theme's
/// `dividerTheme`, so what is worth showing is that the slot exists and what
/// it produces — not a set of axes a caller picks along.
class DividersSection extends StatelessWidget {
  /// {@macro dividers_section}
  const DividersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dividers', style: context.textTheme.titleMedium),
        SizedBox(height: context.spacing.xxs),
        Text(
          'There is no Flowin divider component. The native Divider and '
          'VerticalDivider are styled entirely by the theme dividerTheme, so '
          'they arrive correct without a wrapper.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: context.spacing.md),
        const Text('Above the divider'),
        const Divider(),
        const Text('Below the divider'),
        SizedBox(height: context.spacing.md),
        SizedBox(
          height: _verticalDividerHeight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: context.spacing.md,
            children: const [
              Text('Left'),
              VerticalDivider(),
              Text('Right'),
            ],
          ),
        ),
      ],
    );
  }
}
