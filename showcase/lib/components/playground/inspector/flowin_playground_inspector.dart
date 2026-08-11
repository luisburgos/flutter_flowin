import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_actions.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_presets.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The docked region where a [FlowinPlayground]'s subject is examined and
/// adjusted.
///
/// Named for the role a design tool's side region plays rather than for where
/// it sits: it moves below the preview on narrow viewports, so "sidebar" would
/// go stale exactly where the layout is most responsive.
///
/// Unlike a selection-driven inspector, this one always has exactly one
/// subject. Nothing here reflects a selection.
class FlowinPlaygroundInspector<T> extends StatefulWidget {
  /// {@macro flowin_playground_inspector}
  const FlowinPlaygroundInspector({
    required this.presets,
    required this.active,
    required this.onSelected,
    required this.knobs,
    required this.actions,
    this.bordered = true,
    super.key,
  });

  /// The available configurations. Empty hides the Presets tab.
  final List<FlowinPlaygroundPreset<T>> presets;

  /// The preset matching the current configuration, or null when custom.
  final FlowinPlaygroundPreset<T>? active;

  /// Called with a picked preset's configuration.
  final ValueChanged<T> onSelected;

  /// The caller's controls for the current configuration.
  final Widget knobs;

  /// Actions on the configuration, pinned to the bottom.
  final List<FlowinPlaygroundAction> actions;

  /// Whether to draw the hairline on the leading edge.
  ///
  /// True when docked beside the preview, false when stacked below it — there
  /// the two meet on the other axis and a horizontal divider does that job.
  final bool bordered;

  @override
  State<FlowinPlaygroundInspector<T>> createState() =>
      _FlowinPlaygroundInspectorState<T>();
}

class _FlowinPlaygroundInspectorState<T>
    extends State<FlowinPlaygroundInspector<T>>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  /// The tabbed controls: presets pour into the same state the knobs edit.
  ///
  /// The panels are swapped rather than put in a [TabBarView]. A TabBarView
  /// has no intrinsic height, so it needs a fixed one — which either clips the
  /// taller panel or strands the shorter under empty space. Swapping lets each
  /// panel size itself, at the cost of the horizontal swipe between tabs.
  Widget _buildControls(BuildContext context) {
    if (widget.presets.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(FlowinDesignSpace.space600),
        child: widget.knobs,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Flush to the edges: the tab row's own indicator spans the full
        // width, so insetting it would leave the underline stopping short of
        // the surface it belongs to.
        FlowinTabs(
          controller: _tabs,
          tabs: const [
            FlowinTabItem(label: 'Presets'),
            FlowinTabItem(label: 'Custom'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(FlowinDesignSpace.space600),
          child: AnimatedBuilder(
            animation: _tabs.animation!,
            builder: (context, _) => _tabs.index == 0
                ? FlowinPlaygroundPresets<T>(
                    presets: widget.presets,
                    active: widget.active,
                    onSelected: widget.onSelected,
                  )
                : widget.knobs,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only the controls scroll; the actions are pinned to the bottom by the
    // Expanded above them, so they stay reachable however long the control
    // list grows. Unbounded height means there is no bottom to pin to, so the
    // stacked layout lets both size themselves instead.
    final content = widget.bordered
        ? Column(
            children: [
              Expanded(
                child: SingleChildScrollView(child: _buildControls(context)),
              ),
              if (widget.actions.isNotEmpty)
                FlowinPlaygroundActions(actions: widget.actions),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildControls(context),
              if (widget.actions.isNotEmpty)
                FlowinPlaygroundActions(actions: widget.actions),
            ],
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: widget.bordered
            ? Border(
                left: BorderSide(color: context.colorScheme.outlineVariant),
              )
            : null,
      ),
      child: content,
    );
  }
}
