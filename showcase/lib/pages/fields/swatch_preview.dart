import 'package:flowin_showcase/pages/fields/swatch_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// A demo palette of visually distinct colours.
///
/// Deliberately NOT primary/secondary/tertiary: those three brand ramps are
/// byte-identical neutrals in the Flowin palette (every step, `#7A7A7A` at
/// 500), so sampling them here rendered three identical grey swatches. Only
/// the semantic ramps carry hue, so the palette walks their steps instead —
/// a picker demo needs colours a viewer can tell apart.
///
/// Hues alternate rather than grouping by ramp, so any prefix stays visually
/// distinct: the swatch row renders only the first four.
const swatchPalette = <Color>[
  FlowinDesignColors.error400,
  FlowinDesignColors.warning600,
  FlowinDesignColors.success500,
  FlowinDesignColors.black,
  FlowinDesignColors.white,
  Colors.blue,
];

/// A row of [FlowinColorRadialButton]s that tracks which one is selected.
///
/// Stateful because the selection is the point: a swatch row where tapping
/// does nothing cannot show what the ring is for.
class SwatchRowDemo extends StatefulWidget {
  /// {@macro swatch_row_demo}
  const SwatchRowDemo({required this.config, super.key});

  /// The configuration driving the row.
  final SwatchConfig config;

  @override
  State<SwatchRowDemo> createState() => _SwatchRowDemoState();
}

class _SwatchRowDemoState extends State<SwatchRowDemo> {
  Color _accent = swatchPalette.first;

  @override
  Widget build(BuildContext context) {
    final size = widget.config.size.value;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: FlowinDesignSpace.space300,
      children: [
        for (final color in swatchPalette.take(4))
          FlowinColorRadialButton(
            color: color,
            size: size,
            selected:
                widget.config.selected &&
                color.toARGB32() == _accent.toARGB32(),
            onTap: () => setState(() => _accent = color),
          ),
        if (widget.config.showGradient)
          FlowinColorRadialButton.gradient(
            color: _accent,
            size: size,
            onTap: () {},
          ),
      ],
    );
  }
}
