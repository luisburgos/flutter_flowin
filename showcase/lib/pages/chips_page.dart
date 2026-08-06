import 'package:flowin_showcase/pages/showcase_scaffold.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Demonstrates chips, chip groups and the chip-driven view pager.
class ChipsPage extends StatefulWidget {
  /// {@macro chips_page}
  const ChipsPage({super.key});

  @override
  State<ChipsPage> createState() => _ChipsPageState();
}

class _ChipsPageState extends State<ChipsPage> {
  final _groupController = FlowinChipGroupController();
  String _selectedLabel = 'All';
  String _lastLongPress = '—';
  int _pagerIndex = 0;

  static const _filters = [
    'All',
    'Active',
    'Paused',
    'Archived',
    'Draft',
    'Shared',
  ];

  @override
  void dispose() {
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold.paged(
      title: 'Chips',
      sections: [
        ShowcaseSection(
          chipLabel: 'Variants',
          title: 'FlowinChip — variants',
          description: 'Selected, unselected and dimmed emphasis.',
          children: [
            ShowcaseRow(
              label: 'selected / unselected / unselectedDimmed',
              child: Wrap(
                spacing: FlowinDesignSpace.space200,
                runSpacing: FlowinDesignSpace.space200,
                children: [
                  for (final variant in FlowinChipVariant.values)
                    FlowinChip(
                      variant: variant,
                      label: Text(variant.name),
                      onSelected: (_) {},
                    ),
                ],
              ),
            ),
            ShowcaseRow(
              label: 'with leading + long-press',
              child: Wrap(
                spacing: FlowinDesignSpace.space200,
                children: [
                  FlowinChip(
                    leading: FDIcons.scanFace.toIcon(
                      size: FlowinDesignIconSize.xs,
                    ),
                    label: const Text('Long-press me'),
                    onSelected: (_) {},
                    onLongPress: () => setState(
                      () => _lastLongPress = 'leading chip',
                    ),
                  ),
                  FlowinChip(
                    variant: FlowinChipVariant.selected,
                    label: const Text('Composite'),
                    onSelected: (_) {},
                  ),
                ],
              ),
            ),
            Text(
              'Last long-press: $_lastLongPress',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Scrollable',
          title: 'FlowinChipGroup — scrollable',
          description: 'Single-select row. Selected: $_selectedLabel',
          children: [
            FlowinChipGroup(
              labels: _filters,
              controller: _groupController,
              onSelectedLabel: (label) =>
                  setState(() => _selectedLabel = label),
              onLongPress: (index) => setState(
                () => _lastLongPress = _filters[index],
              ),
            ),
            SizedBox(height: context.spacing.sm),
            Row(
              spacing: FlowinDesignSpace.space200,
              children: [
                FlowinButton.text(
                  size: FlowinButtonSize.xs,
                  onPressed: () => _groupController.index = 0,
                  label: 'Select first',
                ),
                FlowinButton.text(
                  size: FlowinButtonSize.xs,
                  onPressed: () => _groupController.index = _filters.length - 1,
                  label: 'Select last',
                ),
              ],
            ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'Wrapped',
          title: 'FlowinChipGroup — wrapped',
          description: 'isScrollable: false lays the chips out in a Wrap.',
          children: [
            FlowinChipGroup(
              labels: const ['Design', 'Engineering', 'Ops', 'Research'],
              isScrollable: false,
              onSelected: (_) {},
            ),
          ],
        ),
        ShowcaseSection(
          chipLabel: 'View pager',
          title: 'FlowinChipGroupViewPager',
          description: 'Chips drive a swipeable PageView. Page $_pagerIndex.',
          children: [
            SizedBox(
              height: 220,
              child: FlowinChipGroupViewPager(
                onIndexChanged: (i) => setState(() => _pagerIndex = i),
                items: [
                  for (final entry in const [
                    ('Overview', FDIcons.board),
                    ('Timeline', FDIcons.timeline),
                    ('Settings', FDIcons.settings),
                  ])
                    FlowinChipGroupViewPage.child(
                      label: entry.$1,
                      child: FlowinCard(
                        padding: EdgeInsets.all(context.spacing.md),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: FlowinDesignSpace.space200,
                          children: [
                            entry.$2.toIcon(size: FlowinDesignIconSize.xl),
                            Text(
                              '${entry.$1} page',
                              style: context.textTheme.titleSmall,
                            ),
                            Text(
                              'Swipe or tap a chip to change pages.',
                              textAlign: TextAlign.center,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
