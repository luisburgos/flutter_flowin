import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/chips/chip_pager_config.dart';
import 'package:flowin_showcase/pages/chips/chip_pager_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The box the pager is previewed in.
///
/// It fills its parent and pages between whole views, so it needs a bounded
/// height to render at all. Tall enough that a page reads as a page rather
/// than a strip.
const _pagerHeight = 320.0;
const _pagerMaxWidth = 420.0;

const _presets = <FlowinPlaygroundPreset<ChipPagerConfig>>[
  FlowinPlaygroundPreset(
    label: 'Wrapped',
    summary: 'Every chip visible — the showcase index uses this.',
    config: ChipPagerConfig(),
  ),
  FlowinPlaygroundPreset(
    label: 'Scrollable',
    summary: 'One line that scrolls, for more sections than fit.',
    config: ChipPagerConfig(isScrollable: true),
  ),
  FlowinPlaygroundPreset(
    label: 'No divider',
    summary: 'When the chips already sit against a boundary.',
    config: ChipPagerConfig(showDivider: false),
  ),
];

/// A playground for [FlowinChipGroupViewPager]: chips that page between views.
class ChipPagersPage extends StatefulWidget {
  /// {@macro chip_pagers_page}
  const ChipPagersPage({super.key});

  @override
  State<ChipPagersPage> createState() => _ChipPagersPageState();
}

class _ChipPagersPageState extends State<ChipPagersPage> {
  ChipPagerConfig _config = const ChipPagerConfig();

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Chip view pagers',
      dividedAppBar: true,
      body: FlowinPlayground<ChipPagerConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        previewMaxWidth: _pagerMaxWidth,
        previewBuilder: (context, config) => FlowinCard(
          clipChild: true,
          size: const Size(_pagerMaxWidth, _pagerHeight),
          child: FlowinChipGroupViewPager(
            key: ValueKey('${config.isScrollable}-${config.showDivider}'),
            isScrollable: config.isScrollable,
            showDivider: config.showDivider,
            chipsPadding: EdgeInsets.all(context.spacing.sm),
            items: [
              for (final page in const ['Board', 'Timeline', 'Settings'])
                FlowinChipGroupViewPage.child(
                  label: page,
                  child: Center(
                    child: Text(page, style: context.textTheme.titleMedium),
                  ),
                ),
            ],
          ),
        ),
        knobsBuilder: (context, config, onChanged) =>
            ChipPagerKnobs(config: config, onChanged: onChanged),
      ),
    );
  }
}
