import 'package:flowin_showcase/components/playground/flowin_playground.dart';
import 'package:flowin_showcase/components/playground/flowin_playground_preset.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_actions.dart';
import 'package:flowin_showcase/components/playground/inspector/flowin_playground_knobs.dart';
import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

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
      body: const _SheetPlayground(),
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

/// The full state of the previewed sheet.
///
/// Value equality is what lets the playground tell a preset from a custom
/// configuration, so it is a requirement of the type rather than a
/// convenience.
@immutable
class _SheetConfig {
  const _SheetConfig({
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

  _SheetConfig copyWith({
    bool? hasIcon,
    bool? hasSubtitle,
    bool? hasClose,
    _BodyChoice? body,
    _FooterChoice? footer,
  }) => _SheetConfig(
    hasIcon: hasIcon ?? this.hasIcon,
    hasSubtitle: hasSubtitle ?? this.hasSubtitle,
    hasClose: hasClose ?? this.hasClose,
    body: body ?? this.body,
    footer: footer ?? this.footer,
  );

  @override
  bool operator ==(Object other) =>
      other is _SheetConfig &&
      other.hasIcon == hasIcon &&
      other.hasSubtitle == hasSubtitle &&
      other.hasClose == hasClose &&
      other.body == body &&
      other.footer == footer;

  @override
  int get hashCode => Object.hash(hasIcon, hasSubtitle, hasClose, body, footer);
}

/// The five shapes from the design reference.
const _presets = <FlowinPlaygroundPreset<_SheetConfig>>[
  FlowinPlaygroundPreset(
    label: 'Simple',
    summary: 'Title, subtitle, close.',
    config: _SheetConfig(hasSubtitle: true),
  ),
  FlowinPlaygroundPreset(
    label: 'Confirmation',
    summary: 'Icon and two actions.',
    config: _SheetConfig(
      hasIcon: true,
      hasSubtitle: true,
      footer: _FooterChoice.pair,
    ),
  ),
  FlowinPlaygroundPreset(
    label: 'Form',
    summary: 'A text field and a single action.',
    config: _SheetConfig(
      hasIcon: true,
      body: _BodyChoice.form,
      footer: _FooterChoice.single,
    ),
  ),
  FlowinPlaygroundPreset(
    label: 'Action menu',
    summary: 'Item buttons, no footer.',
    config: _SheetConfig(body: _BodyChoice.list),
  ),
  FlowinPlaygroundPreset(
    label: 'Share',
    summary: 'A full-bleed panel and one action.',
    config: _SheetConfig(
      body: _BodyChoice.fullBleed,
      footer: _FooterChoice.single,
    ),
  ),
];

/// Wires [FlowinActionSheet] into a [FlowinPlayground].
///
/// The header's title-placement rule is why this is interactive rather than a
/// set of static examples: the bar holds one leading element, so switching the
/// icon on displaces the title into the supporting block and off pulls it
/// back. That movement is the rule, and no still frame shows movement.
class _SheetPlayground extends StatefulWidget {
  const _SheetPlayground();

  @override
  State<_SheetPlayground> createState() => _SheetPlaygroundState();
}

class _SheetPlaygroundState extends State<_SheetPlayground> {
  _SheetConfig _config = _presets[1].config;

  Widget? _buildBody(_SheetConfig config) => switch (config.body) {
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

  Widget? _buildFooter(_SheetConfig config, VoidCallback onPressed) =>
      switch (config.footer) {
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

  /// The configured sheet.
  ///
  /// [margin] and [onClose] are the caller's, because the two presentations
  /// want opposite things from both. The inline preview zeroes the margin,
  /// since the stage already insets the sheet, and passes a no-op close so the
  /// button is visible without the preview being dismissable. The modal passes
  /// neither: it keeps the widget's own screen-edge margin, and leaving
  /// `onClose` null lets the sheet's default pop run rather than overriding it.
  Widget _buildSheet(
    _SheetConfig config, {
    required VoidCallback onAction,
    EdgeInsets? margin,
    VoidCallback? onClose,
  }) => FlowinActionSheet(
    title: 'Descriptive title',
    subtitle: config.hasSubtitle
        ? 'Write something in here that gives clear directions.'
        : null,
    headerIcon: config.hasIcon
        ? FDIcons.board.toIcon(size: FlowinDesignIconSize.xl)
        : null,
    displayClose: config.hasClose,
    onClose: onClose,
    margin: margin,
    body: _buildBody(config),
    footer: _buildFooter(config, onAction),
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
        _config,
        onAction: () => sheetContext.popFlowinActionSheet(),
      ),
    );
  }

  Widget _buildKnobs(
    BuildContext context,
    _SheetConfig config,
    ValueChanged<_SheetConfig> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FlowinDesignSpace.space600,
      children: [
        FlowinPlaygroundKnobGroup(
          title: 'Visibility',
          children: [
            FlowinPlaygroundSwitchKnob(
              label: 'Show icon',
              value: config.hasIcon,
              onChanged: (v) => onChanged(config.copyWith(hasIcon: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'Show subtitle',
              value: config.hasSubtitle,
              onChanged: (v) => onChanged(config.copyWith(hasSubtitle: v)),
            ),
            FlowinPlaygroundSwitchKnob(
              label: 'Show close',
              value: config.hasClose,
              onChanged: (v) => onChanged(config.copyWith(hasClose: v)),
            ),
          ],
        ),
        Column(
          spacing: FlowinDesignSpace.space600,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlowinPlaygroundChoiceKnob<_BodyChoice>(
              label: 'Body',
              value: config.body,
              values: _BodyChoice.values,
              labelOf: (v) => v.label,
              onChanged: (v) => onChanged(config.copyWith(body: v)),
            ),
            FlowinPlaygroundChoiceKnob<_FooterChoice>(
              label: 'Footer',
              value: config.footer,
              values: _FooterChoice.values,
              labelOf: (v) => v.label,
              onChanged: (v) => onChanged(config.copyWith(footer: v)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlowinPlayground<_SheetConfig>(
      config: _config,
      onChanged: (c) => setState(() => _config = c),
      presets: _presets,
      previewMaxWidth: _sheetMaxWidth,
      previewBuilder: (context, config) => _buildSheet(
        config,
        onAction: () {},
        onClose: () {},
        margin: EdgeInsets.zero,
      ),
      knobsBuilder: _buildKnobs,
      actions: [
        FlowinPlaygroundAction(
          label: 'Open as modal',
          icon: FDIcons.more.toIcon(size: FlowinDesignIconSize.sm),
          onPressed: _openAsModal,
        ),
      ],
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
