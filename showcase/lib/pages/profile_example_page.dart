import 'package:flowin_showcase/components/showcase/showcase_scaffold.dart';
import 'package:flowin_showcase/showcase_custom_color_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// A realistic profile *edit* screen assembled from Flowin components.
///
/// This is an **example**, not a component demo: it shows the pieces working
/// together — a live preview header the fields below it drive, an accent
/// picker tinting it, and a save action gated on validation — rather than
/// cataloguing each widget's variants. The individual components are
/// catalogued under the Components tab.
///
/// The preview leads rather than trailing the form, which is what makes it
/// read as editing something that already exists: the subject is on screen
/// first, and the fields beneath it are the controls that change it.
class ProfileExamplePage extends StatefulWidget {
  /// {@macro profile_example_page}
  const ProfileExamplePage({super.key});

  @override
  State<ProfileExamplePage> createState() => _ProfileExamplePageState();
}

class _ProfileExamplePageState extends State<ProfileExamplePage> {
  String _name = '';
  String _handle = '';
  String _notes = '';
  // Blue, which leads the palette — see [_palette] for why.
  Color _accent = _palette.first;
  bool _submitted = false;

  /// A demo palette of visually distinct colours.
  ///
  /// Deliberately NOT primary/secondary/tertiary: those three brand ramps are
  /// byte-identical neutrals in the Flowin palette (every step, `#7A7A7A` at
  /// 500), so sampling them here rendered three identical grey swatches. Only
  /// the semantic ramps carry hue, so the palette walks their steps instead —
  /// a picker demo needs colours a viewer can tell apart.
  ///
  /// Blue leads because it is the initial selection, and the strip scrolls
  /// horizontally — a selected swatch at the tail would open out of view.
  /// Black and white sit at the end deliberately: they are the entries that
  /// exercise contrast resolution in the preview's monogram, so they are
  /// worth reaching but not worth opening on.
  static const List<Color> _palette = [
    Colors.blue,
    FlowinDesignColors.error400,
    FlowinDesignColors.warning600,
    FlowinDesignColors.success500,
    FlowinDesignColors.black,
    FlowinDesignColors.white,
  ];

  bool get _isValid => _name.isNotEmpty && _handle.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold.stacked(
      title: 'Create profile',
      children: [
        // Extra horizontal inset on top of the scaffold's own body padding.
        // The scaffold's is shared by every showcase page and tuned for
        // catalogue pages, which are dense lists of specimens; a form wants
        // more room around its fields than a specimen grid does.
        //
        // The section is built inline rather than through ShowcaseSection
        // because that widget reserves a leading gap to separate stacked
        // sections — space this page has no use for, since the preview is
        // meant to sit near the top of the scroll.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.spacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfilePreview(
                accent: _accent,
                name: _name,
                handle: _handle,
                notes: _notes,
              ),
              SizedBox(height: context.spacing.lg),
              // The colour leads the form: it is the one field that changes
              // the preview's whole appearance rather than one line of it.
              FlowinColorPickerField(
                label: 'Main color',
                predefinedColors: _palette,
                initialColor: _accent,
                onColorChanged: (c) => setState(() => _accent = c),
                onPickCustomColor: showcaseCustomColorPicker,
              ),
              SizedBox(height: context.spacing.sm),
              FlowinLabeledTextField(
                label: 'Display name',
                hintText: 'Ada Lovelace',
                onChanged: (v) => setState(() => _name = v),
              ),
              SizedBox(height: context.spacing.sm),
              FlowinLabeledTextField(
                label: 'Handle',
                hintText: 'ada',
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[a-z0-9_]')),
                ],
                onChanged: (v) => setState(() => _handle = v),
              ),
              SizedBox(height: context.spacing.sm),
              FlowinLabeledTextField(
                label: 'Notes',
                hintText: 'Anything worth remembering…',
                maxLines: 3,
                onChanged: (v) => setState(() => _notes = v),
              ),
              SizedBox(height: context.spacing.lg),
              // Trailing-aligned, the conventional position for the action
              // that commits a form. The reason it is disabled travels with
              // it — left where the column puts it, the message reads as
              // unrelated to the button it explains.
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FlowinButton.filled(
                      size: FlowinButtonSize.md,
                      onPressed: _isValid
                          ? () => setState(() => _submitted = true)
                          : null,
                      label: _submitted ? 'Saved' : 'Create profile',
                    ),
                    if (!_isValid)
                      Padding(
                        padding: EdgeInsets.only(top: context.spacing.xs),
                        child: Text(
                          'Name and handle are required.',
                          textAlign: TextAlign.end,
                          style: context.textTheme.captionLarge.copyWith(
                            color: context.colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The profile being edited, rendered as the page's header.
///
/// Presentational: it takes the values it draws and holds no state, so the
/// page above owns every field and this only reflects them.
class _ProfilePreview extends StatelessWidget {
  const _ProfilePreview({
    required this.accent,
    required this.name,
    required this.handle,
    required this.notes,
  });

  final Color accent;
  final String name;
  final String handle;
  final String notes;

  @override
  Widget build(BuildContext context) {
    // The avatar carries the accent at full strength while the card behind it
    // stays a wash, so the picked colour reads clearly without tinting the
    // text on top of it.
    final initial = name.trim().isEmpty
        ? '?'
        : name.trim().substring(0, 1).toUpperCase();

    return FlowinCard(
      backgroundColor: accent.withValues(alpha: 0.12),
      // Taller than the fields below it so the preview reads as a header
      // rather than as another row of the form.
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.md,
        vertical: context.spacing.lg,
      ),
      child: Row(
        spacing: context.spacing.md,
        children: [
          _Avatar(accent: accent, initial: initial),
          // Takes the remaining width so long names ellipsize against the
          // card's edge rather than overflowing it.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FlowinDesignSpace.space100,
              children: [
                Text(
                  name.isEmpty ? 'No name yet' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  handle.isEmpty ? '@handle' : '@$handle',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (notes.isNotEmpty)
                  Text(
                    notes,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A circular monogram tinted with the picked accent.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.accent, required this.initial});

  final Color accent;
  final String initial;

  @override
  Widget build(BuildContext context) {
    // The accent is caller-picked data, so what reads on top of it is
    // resolved rather than assumed — a white swatch and a black one both
    // land in this palette.
    final foreground = AccessibleColorConfig(
      seedColor: accent,
      backgroundColor: accent,
      compliance: ContrastCompliance.largeText,
    ).foregroundColor;

    return DecoratedBox(
      decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
      child: SizedBox.square(
        dimension: FlowinDesignSpace.space1400,
        child: Center(
          child: Text(
            initial,
            style: context.textTheme.titleLarge?.copyWith(color: foreground),
          ),
        ),
      ),
    );
  }
}
