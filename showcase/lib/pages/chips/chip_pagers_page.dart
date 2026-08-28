import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/pages/chips/chip_pager_config.dart';
import 'package:flowin_showcase/pages/chips/chip_pager_knobs.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:playgrounder/playgrounder.dart';

/// The box the pager is previewed in.
///
/// It fills its parent and pages between whole views, so it needs a bounded
/// height to render at all. Tall enough that a page reads as a page rather
/// than a strip.
const _pagerHeight = 320.0;
const _pagerMaxWidth = 420.0;

const _presets = <PlaygroundPreset<ChipPagerConfig>>[
  PlaygroundPreset(
    label: 'Wrapped',
    summary: 'Every chip visible — the showcase index uses this.',
    config: ChipPagerConfig(),
  ),
  PlaygroundPreset(
    label: 'Scrollable',
    summary: 'One line that scrolls, for more sections than fit.',
    config: ChipPagerConfig(isScrollable: true),
  ),
  PlaygroundPreset(
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
      body: Playground<ChipPagerConfig>(
        config: _config,
        onChanged: (c) => setState(() => _config = c),
        presets: _presets,
        previewMaxWidth: _pagerMaxWidth,
        previewBuilder: (context, config) => FlowinCard(
          clipChild: true,
          // The card's default fill is secondaryContainer, which is exactly
          // the selected chip's colour — so a selected chip vanishes into the
          // card it sits on. Surface breaks the tie, the way the swatches page
          // moves its stage off the selection colour.
          backgroundColor: context.colorScheme.surface,
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
            // The knob drives the horizontal inset; the row shape is what a
            // real caller controls, and the all-sides case lives on the Chip
            // groups page. A fixed top pad keeps the chips off the card's
            // clipped edge — top only, since the pager's own column already
            // spaces the row from the divider below it.
            chipsPadding: EdgeInsets.only(
              left: config.chipsPadding.resolve(context),
              right: config.chipsPadding.resolve(context),
              top: FlowinDesignSpace.space300,
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
