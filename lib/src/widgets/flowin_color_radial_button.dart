import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';

/// {@template flowin_color_radial_button}
/// A circular color swatch button with an optional "selected" ring.
///
/// Material has no swatch widget, so this is a custom composition. When
/// [selected], the swatch renders as a colored ring of [borderWidth] around an
/// inner disc, separated by a [gapWidth] gap that is **genuinely transparent**
/// — whatever is behind the swatch shows through it, the way the iOS color
/// picker carves its selection ring.
///
/// The transparent gap is what makes the ring self-sufficient. An earlier
/// version painted the gap in a chosen color, which meant the gap had to
/// contrast with the swatch or the ring vanished — a white swatch on a white
/// surface painted white-on-white-on-white and read as unselected. Revealing
/// the background instead removes the question: there is nothing to contrast
/// against, because the separation comes from whatever the swatch happens to
/// sit on. Callers therefore never need to compute a gap color.
///
/// The default sizes derive from Flowin space and border tokens. Use
/// [FlowinColorRadialButton.gradient] for the "pick a custom color" affordance.
/// {@endtemplate}
class FlowinColorRadialButton extends StatelessWidget {
  /// {@macro flowin_color_radial_button}
  const FlowinColorRadialButton({
    required this.color,
    this.size = FlowinDesignSpace.space700,
    this.selected = false,
    this.borderWidth = FlowinDesignBorders.extraBold,
    this.gapWidth = FlowinDesignBorders.bold,
    this.onTap,
    super.key,
  }) : _outerCircleDecoration = null;

  /// A swatch filled with a rainbow sweep gradient, for custom-color selection.
  const FlowinColorRadialButton.gradient({
    required this.color,
    this.size = FlowinDesignSpace.space700,
    this.selected = false,
    this.borderWidth = FlowinDesignBorders.extraBold,
    this.gapWidth = FlowinDesignBorders.bold,
    this.onTap,
    super.key,
  }) : _outerCircleDecoration = const BoxDecoration(
         shape: BoxShape.circle,
         gradient: SweepGradient(
           colors: [
             Colors.greenAccent,
             Colors.yellow,
             Colors.orange,
             Colors.red,
             Colors.purple,
             Colors.blue,
             Colors.cyan,
             Colors.greenAccent,
           ],
         ),
       );

  /// The swatch color.
  final Color color;

  /// The diameter of the swatch.
  final double size;

  /// Whether the selected ring is shown.
  final bool selected;

  /// The width of the colored ring when [selected].
  final double borderWidth;

  /// The width of the transparent gap between the ring and the inner circle.
  final double gapWidth;

  /// Called when the swatch is tapped.
  final VoidCallback? onTap;

  /// The decoration that fills the swatch, set only by the gradient
  /// constructor.
  ///
  /// Private because it selects the fill *mechanism* rather than styling one:
  /// when set, [color] is ignored and the swatch painter does not run. Callers
  /// choose a fill by choosing a constructor; [isGradient] reports which.
  final BoxDecoration? _outerCircleDecoration;

  /// Whether this swatch renders the custom-colour gradient sweep rather than
  /// a solid [color].
  bool get isGradient => _outerCircleDecoration != null;

  @override
  Widget build(BuildContext context) {
    final middleSize = size - 2 * borderWidth;
    final innerSize = middleSize - 2 * gapWidth;

    assert(
      innerSize >= 0,
      'Invalid size: $size. It must be at least twice the sum of borderWidth '
      '($borderWidth) and gapWidth ($gapWidth).',
    );

    const shape = CircleBorder();

    // A gradient swatch keeps its DecoratedBox: the sweep gradient has to be
    // painted by the decoration, and it is clipped to the ring-plus-disc shape
    // when selected so the gap stays transparent there too.
    final Widget swatch = _outerCircleDecoration != null
        ? ClipPath(
            clipper: selected
                ? _RingClipper(
                    size: size,
                    middleSize: middleSize,
                    innerSize: innerSize,
                  )
                : const _CircleClipper(),
            child: DecoratedBox(decoration: _outerCircleDecoration),
          )
        : CustomPaint(
            painter: _SwatchPainter(
              color: color,
              selected: selected,
              middleSize: middleSize,
              innerSize: innerSize,
            ),
          );

    // Ink is suppressed. The Material paints its splash and highlight into the
    // swatch's own bounds, and the gap is transparent now, so a tap tints
    // whatever shows through the gap and reads as the just-picked colour
    // dimming. The swatch IS the value it stands for, so a wash over it
    // misreports that value; selection is already communicated by the ring.
    return Material(
      color: Colors.transparent,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: SizedBox.square(dimension: size, child: swatch),
      ),
    );
  }
}

/// Paints the swatch as either a full disc or a ring plus an inner disc.
///
/// The gap is carved with [PathFillType.evenOdd] rather than by painting a
/// second circle over the first, so the gap is never filled at all and the
/// background shows through it. That also avoids the saved layer a
/// `BlendMode.clear` approach would need, keeping the swatch cheap enough to
/// sit in a scrolling row.
class _SwatchPainter extends CustomPainter {
  const _SwatchPainter({
    required this.color,
    required this.selected,
    required this.middleSize,
    required this.innerSize,
  });

  final Color color;
  final bool selected;
  final double middleSize;
  final double innerSize;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    if (!selected) {
      canvas.drawCircle(center, size.width / 2, paint);
      return;
    }

    // The outer ring: the annulus between the swatch edge and the gap's outer
    // edge. even-odd leaves the enclosed circle unpainted.
    final ring = Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(Rect.fromCircle(center: center, radius: size.width / 2))
      ..addOval(Rect.fromCircle(center: center, radius: middleSize / 2));

    canvas
      ..drawPath(ring, paint)
      ..drawCircle(center, innerSize / 2, paint);
  }

  @override
  bool shouldRepaint(_SwatchPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.selected != selected ||
      oldDelegate.middleSize != middleSize ||
      oldDelegate.innerSize != innerSize;
}

/// Clips a gradient swatch to a ring plus an inner disc, leaving the gap
/// transparent. The gradient itself is painted by the decoration underneath.
class _RingClipper extends CustomClipper<Path> {
  const _RingClipper({
    required this.size,
    required this.middleSize,
    required this.innerSize,
  });

  final double size;
  final double middleSize;
  final double innerSize;

  @override
  Path getClip(Size layoutSize) {
    final center = Offset(layoutSize.width / 2, layoutSize.height / 2);
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(Rect.fromCircle(center: center, radius: layoutSize.width / 2))
      ..addOval(Rect.fromCircle(center: center, radius: middleSize / 2))
      ..addOval(Rect.fromCircle(center: center, radius: innerSize / 2));
  }

  @override
  bool shouldReclip(_RingClipper oldClipper) =>
      oldClipper.size != size ||
      oldClipper.middleSize != middleSize ||
      oldClipper.innerSize != innerSize;
}

/// Clips an unselected gradient swatch to a plain circle.
class _CircleClipper extends CustomClipper<Path> {
  const _CircleClipper();

  @override
  Path getClip(Size size) => Path()
    ..addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
    );

  @override
  bool shouldReclip(_CircleClipper oldClipper) => false;
}
