import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/pages/foundations/icons/icon_config.dart';
import 'package:flowin_showcase/pages/foundations/icons/icon_knobs.dart';
import 'package:flowin_showcase/pages/foundations/icons/icon_preview.dart';
import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// One preset per step of the size scale.
///
/// The scale was a static row of samples before. As presets it renders the
/// whole set at each size, which is what a reader picking a size actually
/// needs to judge.
const _presets = <FlowinPlaygroundPreset<IconConfig>>[
  FlowinPlaygroundPreset(
    label: 'Extra small',
    summary: '12px — inline with caption text.',
    config: IconConfig(size: FlowinDesignIconSize.xs),
  ),
  FlowinPlaygroundPreset(
    label: 'Small',
    summary: '16px — inside buttons and chips.',
    config: IconConfig(size: FlowinDesignIconSize.sm),
  ),
  FlowinPlaygroundPreset(
    label: 'Medium',
    summary: '20px — the default.',
    config: IconConfig(),
  ),
  FlowinPlaygroundPreset(
    label: 'Large',
    summary: '24px — list leading slots.',
    config: IconConfig(size: FlowinDesignIconSize.lg),
  ),
  FlowinPlaygroundPreset(
    label: 'Extra large',
    summary: '32px — sheet headers and empty states.',
    config: IconConfig(size: FlowinDesignIconSize.xl),
  ),
];

/// The semantic icon set, rendered at any step of the size scale.
///
/// FDIcons maps product concepts onto Lucide glyphs, so the set is browsed by
/// meaning rather than by glyph name.
class IconsPage extends StatefulWidget {
  /// {@macro icons_page}
  const IconsPage({super.key});

  @override
  State<IconsPage> createState() => _IconsPageState();
}

class _IconsPageState extends State<IconsPage> {
  IconConfig _config = const IconConfig();

  @override
  Widget build(BuildContext context) {
    // Not ShowcaseScaffold: it wraps its children in a padded ListView, and
    // the playground's panes run edge to edge and own their own scrolling.
    return Scaffold(
      appBar: FlowinAppBar(
        height: kFlowinAppBarHeight + context.spacing.xxs,
        leading: FlowinIconButton.text(
          icon: FDIcons.back.toIcon(),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: const ThemeModeToggle(),
        footer: Padding(
          padding: EdgeInsetsGeometry.only(top: context.spacing.xxs),
          child: const Divider(
            height: FlowinDesignBorders.regular,
            thickness: FlowinDesignBorders.regular,
          ),
        ),
        child: Text('Icons', style: context.textTheme.titleMedium),
      ),
      body: FlowinPlayground<IconConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        previewBuilder: (context, config) => IconPreview(config),
        knobsBuilder: (context, config, onChanged) =>
            IconKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
