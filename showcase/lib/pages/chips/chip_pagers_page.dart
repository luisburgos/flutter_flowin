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
            // keepPagesAlive is in the key so toggling it rebuilds the pager
            // with fresh keep-alive wiring rather than mutating it in place.
            key: ValueKey(
              '${config.isScrollable}-'
              '${config.showDivider}-'
              '${config.keepPagesAlive}',
            ),
            isScrollable: config.isScrollable,
            showDivider: config.showDivider,
            unselectedVariant: config.unselectedVariant,
            keepPagesAlive: config.keepPagesAlive,
            // Horizontal only: a scrollable chip row is a fixed 48 tall, so
            // vertical padding comes out of the chips rather than around
            // them and crushes them until their labels spill out — the Chip
            // groups page demonstrates exactly that with its padding knob.
            chipsPadding: EdgeInsets.symmetric(
              horizontal: config.chipsPadding.resolve(context),
            ),
            items: [
              for (final page in const ['Board', 'Timeline', 'Settings'])
                FlowinChipGroupViewPage.child(
                  label: page,
                  child: _CounterPage(label: page),
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

/// A page holding its own counter, so keepPagesAlive is visible.
///
/// The parameter's whole meaning is whether a page's state survives being
/// swiped away, and stateless page content cannot show that. Count up,
/// switch to another chip and back: the count survives or resets with the
/// knob.
class _CounterPage extends StatefulWidget {
  const _CounterPage({required this.label});

  final String label;

  @override
  State<_CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<_CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: FlowinDesignSpace.space300,
        children: [
          Text(widget.label, style: context.textTheme.titleMedium),
          Text(
            'count: $_count',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          FlowinButton(
            label: 'Increment',
            size: FlowinButtonSize.xs,
            onPressed: () => setState(() => _count++),
          ),
        ],
      ),
    );
  }
}
