import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The inspector's preset list.
///
/// Picking a preset pours its configuration into the knobs, so the settings
/// that produce a shape stay visible and editable. Once the knobs no longer
/// match any preset the list reports that the configuration is custom, which
/// is why [active] is nullable rather than an index.
class FlowinPlaygroundPresets<T> extends StatelessWidget {
  /// {@macro flowin_playground_presets}
  const FlowinPlaygroundPresets({
    required this.presets,
    required this.active,
    required this.onSelected,
    super.key,
  });

  /// The available configurations.
  final List<FlowinPlaygroundPreset<T>> presets;

  /// The preset matching the current configuration, or null once the knobs
  /// have been moved away from all of them.
  final FlowinPlaygroundPreset<T>? active;

  /// Called with the picked preset's configuration.
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space200,
      children: [
        for (final preset in presets)
          FlowinItemButton.tonal(
            icon: (preset == active ? FDIcons.done : FDIcons.board).toIcon(),
            onPressed: () => onSelected(preset.config),
            label: preset.label,
          ),
        SizedBox(height: context.spacing.xxs),
        Text(
          active?.summary ?? 'Custom — the knobs no longer match a preset.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
