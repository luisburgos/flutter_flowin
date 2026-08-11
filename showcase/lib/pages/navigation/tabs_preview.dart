import 'package:flowin_showcase/pages/navigation/tabs_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The labels and glyphs the preview draws from, longest list first used.
const _sections = <(String, FDIcons)>[
  ('Board', FDIcons.board),
  ('Timeline', FDIcons.timeline),
  ('Settings', FDIcons.settings),
  ('Members', FDIcons.scanFace),
  ('Sharing', FDIcons.share),
  ('History', FDIcons.timer),
  ('Labels', FDIcons.paint),
  ('Archive', FDIcons.trash),
];

/// How many tabs each [TabCount] renders.
int _lengthOf(TabCount count) => switch (count) {
  TabCount.few => 3,
  TabCount.many => _sections.length,
};

/// The label substituted for the last tab when the long-label knob is on.
const _longLabel = 'A much longer tab label';

/// The height of the body beneath the bar.
const _bodyHeight = 140.0;

/// A [FlowinTabs] bar with a body behind it, built from a [TabsConfig].
///
/// Stateful because the bar is driven by a [TabController], which must be
/// created and disposed, and whose length has to track the tab count — a
/// controller whose length disagrees with the number of tabs silently drops
/// the extras, leaving surplus tabs with no page behind them.
class TabsDemo extends StatefulWidget {
  /// {@macro tabs_demo}
  const TabsDemo({required this.config, super.key});

  /// The configuration driving the bar.
  final TabsConfig config;

  @override
  State<TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo> with TickerProviderStateMixin {
  late TabController _controller = _createController();

  TabController _createController() =>
      TabController(length: _lengthOf(widget.config.count), vsync: this);

  @override
  void didUpdateWidget(TabsDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The length is fixed at construction, so a changed count needs a new
    // controller rather than a mutated one.
    if (widget.config.count != oldWidget.config.count) {
      _controller.dispose();
      _controller = _createController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// The labels for the current count, with the last swapped for a long one
  /// when that knob is on.
  List<String> get _labels {
    final labels = [
      for (final section in _sections.take(_lengthOf(widget.config.count)))
        section.$1,
    ];
    if (widget.config.longLabel) labels[labels.length - 1] = _longLabel;
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    final labels = _labels;

    // Clipped so the bar's own edges follow the card's corners rather than
    // running past them.
    return FlowinCard(
      clipChild: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlowinTabs(
            controller: _controller,
            isScrollable: widget.config.isScrollable,
            tabs: [
              for (var i = 0; i < labels.length; i++)
                FlowinTabItem(
                  label: labels[i],
                  icon: widget.config.hasIcons
                      ? _sections[i].$2.toIcon()
                      : null,
                ),
            ],
          ),
          SizedBox(
            height: _bodyHeight,
            child: TabBarView(
              controller: _controller,
              children: [
                for (final label in labels)
                  Center(
                    child: Text(
                      '$label content',
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
