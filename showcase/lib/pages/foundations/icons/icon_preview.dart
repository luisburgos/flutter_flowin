import 'package:flowin_showcase/pages/foundations/icons/icon_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The whole semantic icon set at one size.
///
/// Every glyph rather than a sample: the set is the thing being documented,
/// and a reader is usually here to find whether a concept already has an icon.
class IconPreview extends StatelessWidget {
  /// {@macro icon_preview}
  const IconPreview(this.config, {super.key});

  /// The configuration to render.
  final IconConfig config;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final text = context.textTheme;

    return Wrap(
      spacing: FlowinDesignSpace.space400,
      runSpacing: FlowinDesignSpace.space300,
      alignment: WrapAlignment.center,
      children: [
        for (final icon in FDIcons.values)
          SizedBox(
            width: 68,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon.toIcon(size: config.size),
                if (config.showLabels) ...[
                  SizedBox(height: context.spacing.xxs),
                  Text(
                    icon.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.captionMedium.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
