import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';
import 'package:flutter_flowin/src/widgets/flowin_color_radial_button.dart';
import 'package:flutter_flowin/src/widgets/flowin_input_field.dart';

/// Presents a custom-color picker seeded with [current], resolving to the
/// chosen color or null if the user dismisses without choosing.
///
/// Injected into [FlowinColorPickerField] so the design system carries the
/// swatch-row affordance without binding a particular picker implementation:
/// the caller supplies any picker they like — native, a pub package, or their
/// own. See the showcase for a worked example.
typedef FlowinCustomColorPicker =
    Future<Color?> Function(
      BuildContext context,
      Color? current,
    );

/// Whether two colors denote the same canonical 32-bit ARGB value.
///
/// `Color.==` compares `colorSpace` alongside the normalized channels, so a
/// color that came back from a platform picker (which reports a wide-gamut
/// space such as Display P3) is never equal to the sRGB swatch it was picked
/// from, even though both denote the same value. Every preset would therefore
/// render as a custom color once it had been through the picker or storage.
/// Comparing the packed integer makes every swatch select correctly however
/// the color was reconstructed.
bool _isSameColorValue(Color? a, Color? b) {
  if (a == null || b == null) return a == b;
  return a.toARGB32() == b.toARGB32();
}

/// {@template flowin_color_picker_field}
/// A [FlowinInputField] whose content is an inline color picker: a scrollable
/// row of predefined swatches with a custom-color swatch pinned to the trailing
/// edge.
///
/// The custom-color swatch opens whatever picker the caller supplies through
/// [onPickCustomColor]. When that is null the swatch is omitted and the field
/// offers the predefined swatches alone, so a caller that only needs presets
/// pays for no picker at all.
/// {@endtemplate}
class FlowinColorPickerField extends StatefulWidget {
  /// {@macro flowin_color_picker_field}
  const FlowinColorPickerField({
    required this.predefinedColors,
    this.label = 'Color',
    this.initialColor,
    this.onColorChanged,
    this.onPickCustomColor,
    super.key,
  });

  /// The predefined color swatches.
  final List<Color> predefinedColors;

  /// The field label.
  final String label;

  /// The initially-selected color.
  final Color? initialColor;

  /// Called whenever the selected color changes.
  final ValueChanged<Color>? onColorChanged;

  /// Opens the caller's custom-color picker when the trailing swatch is tapped.
  ///
  /// The design system deliberately ships no picker of its own: the caller
  /// injects one — native, a pub package, or their own — seeded with the
  /// current selection and resolving to the chosen color, or null if
  /// dismissed. When null, the custom-color swatch is not shown and the field
  /// is preset-only.
  final FlowinCustomColorPicker? onPickCustomColor;

  @override
  State<FlowinColorPickerField> createState() => _FlowinColorPickerFieldState();
}

class _FlowinColorPickerFieldState extends State<FlowinColorPickerField> {
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  /// Re-seeds from [FlowinColorPickerField.initialColor] when the caller swaps
  /// in a different color — switching to another entity being edited, say.
  ///
  /// Compared on the canonical value so a color that only round-tripped
  /// through storage is not treated as a change, which would clobber a color
  /// the user is actively picking.
  @override
  void didUpdateWidget(FlowinColorPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameColorValue(widget.initialColor, oldWidget.initialColor)) {
      _selectedColor = widget.initialColor;
    }
  }

  void _setSelectedColor(Color color) {
    if (!mounted) return;
    setState(() {
      _selectedColor = color;
      widget.onColorChanged?.call(color);
    });
  }

  Future<void> _openCustomPicker() async {
    final pick = widget.onPickCustomColor;
    if (pick == null) return;
    final picked = await pick(context, _selectedColor);
    if (picked != null) _setSelectedColor(picked);
  }

  @override
  Widget build(BuildContext context) {
    return FlowinInputField(
      label: widget.label,
      child: FlowinInlineColorPicker(
        selectedColor: _selectedColor,
        predefinedColors: widget.predefinedColors,
        // Null hides the custom-color swatch: the field is preset-only when
        // the caller injects no picker.
        onCustomColorTap: widget.onPickCustomColor == null
            ? null
            : _openCustomPicker,
        onPredefinedColorTap: _setSelectedColor,
      ),
    );
  }
}

/// Identifies the custom-color (gradient) swatch.
///
/// The predefined swatches all render as the same widget type inside a
/// `ListView`, and the gradient one paints the *currently selected* color, so
/// it can share a color with a preset. Without a key, a test asserting on the
/// custom swatch has to reach it structurally and can easily match a preset
/// instead.
const flowinCustomColorSwatchKey = ValueKey<String>(
  'flowin-color-picker-gradient',
);

/// {@template flowin_inline_color_picker}
/// The inline color-picker row used by [FlowinColorPickerField]: a scrollable
/// list of predefined swatches with the custom-color gradient swatch pinned
/// to the trailing edge.
/// {@endtemplate}
class FlowinInlineColorPicker extends StatelessWidget {
  /// {@macro flowin_inline_color_picker}
  const FlowinInlineColorPicker({
    required this.predefinedColors,
    required this.onPredefinedColorTap,
    this.onCustomColorTap,
    this.selectedColor,
    super.key,
  });

  /// The predefined color swatches.
  final List<Color> predefinedColors;

  /// Called when the custom-color (gradient) swatch is tapped.
  ///
  /// When null, the custom-color swatch is not rendered and the row shows the
  /// predefined swatches alone.
  final VoidCallback? onCustomColorTap;

  /// Called when a predefined swatch is tapped.
  final ValueChanged<Color> onPredefinedColorTap;

  /// The currently-selected color, if any.
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPredefinedSelected = predefinedColors.any(
      (color) => _isSameColorValue(color, selectedColor),
    );
    final isGradientSelected = selectedColor != null && !isPredefinedSelected;

    // Hairline separation ring so swatches stay visible on same-colored
    // surfaces; resolved against the scheme in dark themes where the neutral
    // token would disappear. This is what keeps an UNSELECTED swatch readable,
    // so no swatch needs a border of its own.
    final swatchShadows = theme.brightness == Brightness.light
        ? const [FlowinDesignShadows.shadow10]
        : [FlowinDesignShadows.themedShadow10(context)];

    // The selection ring needs no gap colour from us: the swatch carves its
    // gap transparently, so the ring separates by revealing whatever is behind
    // the swatch. A white swatch on a white surface still reads as selected,
    // which is what the earlier contrast-resolved gap colour existed to fix.
    return SizedBox(
      height: FlowinDesignSpace.space1000,
      child: Row(
        spacing: FlowinDesignSpace.space400,
        children: [
          // Presets lead and take the remaining width; the custom swatch is
          // pinned to the trailing edge so it never scrolls out of reach.
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: predefinedColors.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: FlowinDesignSpace.space400),
              itemBuilder: (context, index) {
                final color = predefinedColors[index];
                return Container(
                  decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    shadows: swatchShadows,
                  ),
                  child: FlowinColorRadialButton(
                    selected: _isSameColorValue(color, selectedColor),
                    color: color,
                    onTap: () => onPredefinedColorTap(color),
                  ),
                );
              },
            ),
          ),
          // Only when a custom-color picker is wired: without it the field is
          // preset-only and the trailing gradient swatch would open nothing.
          if (onCustomColorTap != null)
            Tooltip(
              message: isGradientSelected
                  ? 'Custom color selected'
                  : 'Pick a custom color',
              // `color` here is the selection seed, not the rendered fill — the
              // sweep gradient is what gets painted.
              child: FlowinColorRadialButton.gradient(
                key: flowinCustomColorSwatchKey,
                selected: isGradientSelected,
                color: selectedColor ?? Colors.transparent,
                onTap: onCustomColorTap,
              ),
            ),
        ],
      ),
    );
  }
}
