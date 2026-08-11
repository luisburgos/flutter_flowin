import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Width at which the playground splits into a preview and a knob pane.
///
/// Chosen as the sheet's own 480 clamp plus a knob pane and the gap between
/// them: below this the two would each be too narrow to use. Local because
/// this is the showcase's only responsive layout — promote it if a second
/// page needs one rather than guessing at a shared scale now.
const _splitPaneBreakpoint = 900.0;

/// Fixed width of the knob pane in the split layout.
const _knobPaneWidth = 300.0;

/// The width the modal clamps itself to on wide viewports.
///
/// Mirrors `showFlowinActionSheet`'s own default so the preview renders at a
/// width the sheet can actually reach.
const _sheetMaxWidth = 480.0;

/// An interactive playground for every action sheet configuration.
class SheetsPage extends StatelessWidget {
  /// {@macro sheets_page}
  const SheetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Not ShowcaseScaffold: it wraps its children in a padded ListView, and
    // the playground's panes run edge to edge and own their own scrolling.
    // The app bar is built the same way so the page still matches the others.
    return Scaffold(
      appBar: FlowinAppBar(
        height: kFlowinAppBarHeight + context.spacing.xxs,
        leading: FlowinIconButton.text(
          icon: FDIcons.back.toIcon(),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: const ThemeModeToggle(),
        // The panes below run edge to edge with no padding to separate them
        // from the bar, so the bar draws its own hairline. Same treatment
        // FlowinTabsAppBar uses, and the same token.
        footer: Padding(
          padding: EdgeInsetsGeometry.only(top: context.spacing.xxs),
          child: const Divider(
            height: FlowinDesignBorders.regular,
            thickness: FlowinDesignBorders.regular,
          ),
        ),
        child: Text('Action sheets', style: context.textTheme.titleMedium),
      ),
      body: const _PlaygroundDemo(),
    );
  }
}

/// Which widget fills the sheet's body slot.
enum _BodyChoice {
  none('None'),
  text('Text'),
  form('Form'),
  list('Item list'),
  fullBleed('Full bleed');

  const _BodyChoice(this.label);

  final String label;
}

/// How many actions the sheet's footer carries.
enum _FooterChoice {
  none('None'),
  single('One action'),
  pair('Two actions');

  const _FooterChoice(this.label);

  final String label;
}

/// A named configuration, poured into the knobs when picked.
///
/// These were separate demo triggers before. As presets they do the same
/// teaching, but the settings that produce each shape are visible and can be
/// mutated from, which a fixed example cannot offer.
enum _Preset {
  simple('Simple', 'Title, subtitle, close.'),
  confirmation('Confirmation', 'Icon and two actions.'),
  form('Form', 'A text field and a single action.'),
  menu('Action menu', 'Item buttons, no footer.'),
  share('Share', 'A full-bleed panel and one action.');

  const _Preset(this.label, this.summary);

  final String label;

  /// One line on what the shape is for, shown under the label.
  final String summary;

  _Config get config => switch (this) {
    _Preset.simple => const _Config(hasSubtitle: true),
    _Preset.confirmation => const _Config(
      hasIcon: true,
      hasSubtitle: true,
      footer: _FooterChoice.pair,
    ),
    _Preset.form => const _Config(
      hasIcon: true,
      body: _BodyChoice.form,
      footer: _FooterChoice.single,
    ),
    _Preset.menu => const _Config(body: _BodyChoice.list),
    _Preset.share => const _Config(
      body: _BodyChoice.fullBleed,
      footer: _FooterChoice.single,
    ),
  };
}

/// The full state of the previewed sheet.
///
/// A value type so a preset is just a constant, and so "has the user deviated
/// from the preset" is an equality check rather than five comparisons.
@immutable
class _Config {
  const _Config({
    this.hasIcon = false,
    this.hasSubtitle = false,
    this.hasClose = true,
    this.body = _BodyChoice.none,
    this.footer = _FooterChoice.none,
  });

  final bool hasIcon;
  final bool hasSubtitle;
  final bool hasClose;
  final _BodyChoice body;
  final _FooterChoice footer;

  _Config copyWith({
    bool? hasIcon,
    bool? hasSubtitle,
    bool? hasClose,
    _BodyChoice? body,
    _FooterChoice? footer,
  }) => _Config(
    hasIcon: hasIcon ?? this.hasIcon,
    hasSubtitle: hasSubtitle ?? this.hasSubtitle,
    hasClose: hasClose ?? this.hasClose,
    body: body ?? this.body,
    footer: footer ?? this.footer,
  );

  @override
  bool operator ==(Object other) =>
      other is _Config &&
      other.hasIcon == hasIcon &&
      other.hasSubtitle == hasSubtitle &&
      other.hasClose == hasClose &&
      other.body == body &&
      other.footer == footer;

  @override
  int get hashCode => Object.hash(hasIcon, hasSubtitle, hasClose, body, footer);
}

/// Every sheet slot wired to a control, rebuilt live.
///
/// The header's title-placement rule is why this is interactive rather than a
/// set of static examples: the bar holds one leading element, so switching the
/// icon on displaces the title into the supporting block and off pulls it
/// back. That movement is the rule, and no still frame shows movement.
///
/// The knobs are raw Material switches and dropdowns. The package has neither
/// component, and this pane is scaffolding for driving the demo rather than
/// anything being demonstrated, so it does not warrant inventing one.
class _PlaygroundDemo extends StatefulWidget {
  const _PlaygroundDemo();

  @override
  State<_PlaygroundDemo> createState() => _PlaygroundDemoState();
}

class _PlaygroundDemoState extends State<_PlaygroundDemo>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  _Config _config = _Preset.confirmation.config;

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  /// The preset matching the current knobs, or null once the user deviates.
  _Preset? get _activePreset {
    for (final preset in _Preset.values) {
      if (preset.config == _config) return preset;
    }
    return null;
  }

  void _apply(_Config config) => setState(() => _config = config);

  Widget? _buildBody() => switch (_config.body) {
    _BodyChoice.none => null,
    _BodyChoice.text => const Padding(
      padding: EdgeInsets.symmetric(horizontal: FlowinDesignSpace.space600),
      child: Text(
        'The body slot takes any widget. This one insets itself to line up '
        'with the footer.',
      ),
    ),
    // No autofocus: the playground rebuilds on every knob change, so grabbing
    // focus would fight whichever control was just used.
    _BodyChoice.form => Padding(
      padding: const EdgeInsets.symmetric(
        vertical: FlowinDesignSpace.space200,
        horizontal: FlowinDesignSpace.space800,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: FlowinDesignSpace.space300,
        children: [
          const FlowinLabeledTextField(
            label: 'Board name',
            hintText: 'Q3 roadmap',
          ),
          FlowinChipGroup(
            labels: const ['Personal', 'Team', 'Public'],
            initialSelectedIndex: 1,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    ),
    _BodyChoice.list => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FlowinDesignSpace.space600,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: FlowinDesignSpace.space200,
        children: [
          for (final action in const [
            ('Edit', FDIcons.edit),
            ('Share', FDIcons.share),
          ])
            FlowinItemButton.tonal(
              icon: action.$2.toIcon(),
              onPressed: () {},
              label: action.$1,
            ),
          FlowinItemButton.destructive(
            icon: FDIcons.trash.toIcon(),
            onPressed: () {},
            label: 'Delete',
          ),
        ],
      ),
    ),
    // Unwrapped on purpose: nothing insets it, so it reaches the card edge.
    _BodyChoice.fullBleed => const _ScorePanel(),
  };

  Widget? _buildFooter(VoidCallback onPressed) => switch (_config.footer) {
    _FooterChoice.none => null,
    _FooterChoice.single => FlowinActionSheetFooter(
      right: FlowinButton.filled(
        size: FlowinButtonSize.md,
        onPressed: onPressed,
        label: 'Continue',
      ),
    ),
    _FooterChoice.pair => FlowinActionSheetFooter(
      left: FlowinButton.tonal(
        size: FlowinButtonSize.md,
        onPressed: onPressed,
        label: 'Cancel',
      ),
      right: FlowinButton.filled(
        size: FlowinButtonSize.md,
        onPressed: onPressed,
        label: 'Confirm',
      ),
    ),
  };

  /// The configured sheet. [onAction] fires from the footer buttons, so the
  /// modal can pop while the inline preview does nothing.
  ///
  /// [margin] and [onClose] are the caller's, because the two presentations
  /// want opposite things from both.
  ///
  /// The inline preview zeroes the margin, since the stage already insets the
  /// sheet, and passes a no-op close so the button is visible without the
  /// preview being dismissable. The modal passes neither: it keeps the
  /// widget's own screen-edge margin, and leaving `onClose` null lets the
  /// sheet's default pop run rather than overriding it with a no-op.
  Widget _buildSheet({
    required VoidCallback onAction,
    EdgeInsets? margin,
    VoidCallback? onClose,
  }) => FlowinActionSheet(
    title: 'Descriptive title',
    subtitle: _config.hasSubtitle
        ? 'Write something in here that gives clear directions.'
        : null,
    headerIcon: _config.hasIcon
        ? FDIcons.board.toIcon(size: FlowinDesignIconSize.xl)
        : null,
    displayClose: _config.hasClose,
    onClose: onClose,
    margin: margin,
    body: _buildBody(),
    footer: _buildFooter(onAction),
  );

  /// Presents the current configuration as a real modal.
  ///
  /// The scrim, the 480 clamp and the keyboard lift only exist in a modal
  /// presentation, so the inline preview cannot show them however faithful it
  /// is otherwise. This is the only place they are reachable.
  Future<void> _openAsModal() async {
    await showFlowinActionSheet<void>(
      context: context,
      builder: (sheetContext) => _buildSheet(
        onAction: () => sheetContext.popFlowinActionSheet(),
      ),
    );
  }

  Widget _buildPresets(BuildContext context) {
    final active = _activePreset;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space200,
      children: [
        for (final preset in _Preset.values)
          FlowinItemButton.tonal(
            icon: (preset == active ? FDIcons.done : FDIcons.board).toIcon(),
            onPressed: () => _apply(preset.config),
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

  Widget _buildKnobs(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VISIBILITY',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            _SwitchControl(
              label: 'Show icon',
              value: _config.hasIcon,
              onChanged: (v) => _apply(_config.copyWith(hasIcon: v)),
            ),
            _SwitchControl(
              label: 'Show subtitle',
              value: _config.hasSubtitle,
              onChanged: (v) => _apply(_config.copyWith(hasSubtitle: v)),
            ),
            _SwitchControl(
              label: 'Show close',
              value: _config.hasClose,
              onChanged: (v) => _apply(_config.copyWith(hasClose: v)),
            ),
          ],
        ),
        Column(
          spacing: FlowinDesignSpace.space600,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DropdownControl<_BodyChoice>(
              label: 'Body',
              value: _config.body,
              values: _BodyChoice.values,
              labelOf: (v) => v.label,
              onChanged: (v) => _apply(_config.copyWith(body: v)),
            ),
            _DropdownControl<_FooterChoice>(
              label: 'Footer',
              value: _config.footer,
              values: _FooterChoice.values,
              labelOf: (v) => v.label,
              onChanged: (v) => _apply(_config.copyWith(footer: v)),
            ),
          ],
        ),
      ],
    );
  }

  /// The tabbed control pane: presets pour into the same state the knobs edit.
  ///
  /// The panels are swapped rather than put in a [TabBarView]. A TabBarView
  /// has no intrinsic height, so it needs a fixed one — which either clips the
  /// taller panel or strands the shorter under empty space. Swapping lets each
  /// panel size itself, at the cost of the horizontal swipe between tabs.
  Widget _buildControlPane(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Flush to the panel edges: the tab row's own indicator spans the full
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
                ? _buildPresets(context)
                : _buildKnobs(context),
          ),
        ),
      ],
    );
  }

  /// The pane's pinned action, separated from the controls above it.
  ///
  /// Kept out of [_buildControlPane] so the split layout can hold it below the
  /// scrolling region rather than inside it.
  Widget _buildPaneFooter(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Divider(height: FlowinDesignBorders.regular),
      Padding(
        padding: const EdgeInsets.all(FlowinDesignSpace.space600),
        child: _buildModalButton(),
      ),
    ],
  );

  /// Full width so it reads as an action on the pane rather than one more
  /// control among the knobs above it.
  Widget _buildModalButton() => SizedBox(
    width: double.infinity,
    child: FlowinButton.tonal(
      size: FlowinButtonSize.md,
      icon: FDIcons.more.toIcon(size: FlowinDesignIconSize.sm),
      onPressed: _openAsModal,
      label: 'Open as modal',
    ),
  );

  @override
  Widget build(BuildContext context) {
    // Measures the space the section actually gets, not the window: the
    // scaffold's own padding comes off the top, and a MediaQuery width would
    // not see that.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _splitPaneBreakpoint) {
          // Stacked, so the sidebar's left border would divide nothing. A
          // Divider does the same job along the axis they actually meet on.
          // The page scrolls as one, so there is no pane bottom to pin to —
          // the footer stays inline at the end of the controls.
          return ListView(
            children: [
              _PreviewStage(
                child: _buildSheet(
                  onAction: () {},
                  onClose: () {},
                  margin: EdgeInsets.zero,
                ),
              ),
              const Divider(height: FlowinDesignBorders.regular),
              _buildControlPane(context),
              _buildPaneFooter(context),
            ],
          );
        }

        // Stage first in the reading order, controls to its right. The stage
        // takes the remaining width so the preview stays the focus, while the
        // control pane is fixed — controls that reflow as you use them are
        // harder to hit than ones that stay put. Everything that drives the
        // preview lives in that pane, including the modal trigger.
        //
        // Stretched and gapless: the panes meet at the sidebar's border the
        // way a docked inspector does, rather than floating apart as cards.
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Each pane scrolls on its own: a tall sheet should not push the
            // controls off-screen, and long controls should not move the
            // preview.
            Expanded(
              child: LayoutBuilder(
                builder: (context, pane) => SingleChildScrollView(
                  // Floor the stage at the pane's height so its tint fills the
                  // pane; without it the stage hugs the sheet and the surface
                  // stops partway down.
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: pane.maxHeight),
                    child: _PreviewStage(
                      child: _buildSheet(
                        onAction: () {},
                        onClose: () {},
                        margin: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: _knobPaneWidth,
              child: _SidebarPane(
                // Only the controls scroll; the footer is pinned to the pane's
                // bottom by the Expanded above it, so the modal trigger stays
                // reachable however long the control list grows.
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildControlPane(context),
                      ),
                    ),
                    _buildPaneFooter(context),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// The control pane's surface: `surface`, divided from the preview by a
/// hairline on its leading edge rather than by a gap.
///
/// Square and full-bleed, so the pane reads as a region of the window in the
/// way an editor's inspector does. Rounding it would make it a card floating
/// on the page, which is the opposite of a docked pane.
class _SidebarPane extends StatelessWidget {
  const _SidebarPane({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          left: BorderSide(color: context.colorScheme.outlineVariant),
        ),
      ),
      child: child,
    );
  }
}

/// The stage the preview sheet sits on.
///
/// Clamped to the width the modal actually uses — showing the sheet wider than
/// it can ever render would misinform the eye this exists to inform.
class _PreviewStage extends StatelessWidget {
  const _PreviewStage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // outlineVariant, not a surfaceContainer role: the Flowin scheme leaves
      // those at their default, which resolves to plain surface — pure white
      // in light mode — so the white sheet would vanish into its own stage.
      decoration: BoxDecoration(color: context.colorScheme.outlineVariant),
      child: Padding(
        padding: const EdgeInsets.all(FlowinDesignSpace.space600),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _sheetMaxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A full-bleed body: a dark panel spanning the card corner to corner.
///
/// Deliberately carries no horizontal inset of its own. That is the whole
/// point of the demo — the sheet insets nothing, so reaching the card edge is
/// the body's own choice rather than something it has to undo.
class _ScorePanel extends StatelessWidget {
  const _ScorePanel();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: scheme.inverseSurface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: FlowinDesignSpace.space600,
          horizontal: FlowinDesignSpace.space800,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final score in ['2', '2'])
              Text(
                score,
                style: context.textTheme.displaySmall?.copyWith(
                  color: scheme.onInverseSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A labelled switch for the playground's boolean slots.
class _SwitchControl extends StatelessWidget {
  const _SwitchControl({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: FlowinDesignSpace.space200,
      children: [
        Expanded(
          child: Text(label, style: context.textTheme.bodyLarge),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

/// A labelled dropdown for the playground's slot choices.
class _DropdownControl<T> extends StatelessWidget {
  const _DropdownControl({
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> values;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: context.textTheme.bodySmall),
        // `isExpanded` so the button takes the space left rather than sizing
        // to its widest item, which is what pushes it past a narrow pane.
        SizedBox(
          width: double.infinity,
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            borderRadius: BorderRadius.circular(FlowinDesignRadius.radius300),
            items: [
              for (final v in values)
                DropdownMenuItem<T>(value: v, child: Text(labelOf(v))),
            ],
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ],
    );
  }
}
