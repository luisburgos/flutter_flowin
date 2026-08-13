import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_actions.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_inspector.dart';
import 'package:flowin_showcase/components/playground/preview/flowin_playground_preview.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Width at which the playground splits into a preview and an inspector.
///
/// Below this the two would each be too narrow to use, so they stack instead.
const _splitPaneBreakpoint = 900.0;

/// Fixed width of the docked inspector.
const _inspectorWidth = 300.0;

/// A component rendered live beside the controls that configure it.
///
/// Two peers: a [FlowinPlaygroundPreview] showing the subject, and a
/// [FlowinPlaygroundInspector] holding presets, knobs and actions. The
/// playground owns the current configuration so it can tell whether the knobs
/// still match a preset, which is what a fixed set of examples cannot show.
///
/// [T] is the caller's configuration type. Give it value equality — the
/// preset-versus-custom check is `==` against each preset's config, so a type
/// without it reports Custom immediately and always.
///
/// ```dart
/// FlowinPlayground<MyConfig>(
///   config: _config,
///   onChanged: (c) => setState(() => _config = c),
///   presets: const [
///     FlowinPlaygroundPreset(label: 'Default', config: MyConfig()),
///   ],
///   previewBuilder: (context, config) => MyComponent(config: config),
///   knobsBuilder: (context, config, onChanged) => MyKnobs(...),
/// )
/// ```
class FlowinPlayground<T> extends StatelessWidget {
  /// {@macro flowin_playground}
  const FlowinPlayground({
    required this.config,
    required this.onChanged,
    required this.previewBuilder,
    required this.knobsBuilder,
    this.presets = const [],
    this.actions = const [],
    this.previewMaxWidth,
    this.previewBackground,
    super.key,
  });

  /// The configuration being previewed.
  final T config;

  /// Called when a preset or a knob changes the configuration.
  final ValueChanged<T> onChanged;

  /// Builds the subject for the current configuration.
  final Widget Function(BuildContext context, T config) previewBuilder;

  /// Builds the controls for the current configuration.
  final Widget Function(
    BuildContext context,
    T config,
    ValueChanged<T> onChanged,
  )
  knobsBuilder;

  /// Named starting configurations. Empty hides the Presets tab.
  final List<FlowinPlaygroundPreset<T>> presets;

  /// Actions on the current configuration, pinned to the inspector's bottom.
  final List<FlowinPlaygroundAction> actions;

  /// Clamps the previewed subject's width to what it really renders at.
  final double? previewMaxWidth;

  /// Overrides the preview stage's background.
  ///
  /// Pass `surface` when the subject is a neutral the default tint would
  /// swallow — a tonal or outlined control.
  final Color? previewBackground;

  /// The preset matching [config], or null once the knobs have moved away.
  FlowinPlaygroundPreset<T>? get _activePreset {
    for (final preset in presets) {
      if (preset.config == config) return preset;
    }
    return null;
  }

  Widget _buildPreview(BuildContext context) => FlowinPlaygroundPreview(
    maxWidth: previewMaxWidth,
    background: previewBackground,
    child: previewBuilder(context, config),
  );

  Widget _buildInspector({required bool bordered}) =>
      FlowinPlaygroundInspector<T>(
        presets: presets,
        active: _activePreset,
        onSelected: onChanged,
        knobs: Builder(
          builder: (context) => knobsBuilder(context, config, onChanged),
        ),
        actions: actions,
        bordered: bordered,
      );

  @override
  Widget build(BuildContext context) {
    // Measures the space the playground actually gets rather than the window,
    // so it still splits correctly inside a padded or inset parent.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _splitPaneBreakpoint) {
          // Stacked, so the inspector's leading border would divide nothing —
          // a Divider does that job along the axis the two actually meet on.
          return ListView(
            children: [
              _buildPreview(context),
              const Divider(height: FlowinDesignBorders.regular),
              _buildInspector(bordered: false),
            ],
          );
        }

        // Preview first in the reading order, inspector docked to its right.
        // The preview takes the remaining width so it stays the focus, while
        // the inspector is fixed — controls that reflow as you use them are
        // harder to hit than ones that stay put.
        //
        // Stretched and gapless: the two meet at the inspector's border the
        // way a docked design tool does, rather than floating apart as cards.
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, pane) => SingleChildScrollView(
                  // Floor the stage at the pane's height so its tint fills the
                  // pane; without it the stage hugs the subject and the
                  // surface stops partway down.
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: pane.maxHeight),
                    child: _buildPreview(context),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: _inspectorWidth,
              child: _buildInspector(bordered: true),
            ),
          ],
        );
      },
    );
  }
}
