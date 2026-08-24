import 'dart:math' as math;

import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// A line of handwriting with no words in it.
///
/// Where [LowframerBox.line] stands in for typeset text, this stands in for
/// *written* text: a continuous wavy stroke, like a scribbled signature.
/// [height] and [strokeWidth] together read as the writing's size, and
/// [wavelength] is its frequency — tight cycles scrawl, wide ones read as
/// lazy cursive.
///
/// Deterministic on purpose: the wobble that keeps it from looking like a
/// sine chart is a fixed secondary modulation, not randomness, so the same
/// input always paints the same pixels and tests stay stable.
class LowframerScribble extends StatelessWidget {
  /// {@macro lowframer_scribble}
  const LowframerScribble({
    required this.color,
    this.width = 48,
    this.height = 8,
    this.strokeWidth = 2,
    this.wavelength = 10,
    super.key,
  }) : assert(wavelength > 0, 'wavelength must be positive'),
       assert(strokeWidth > 0, 'strokeWidth must be positive');

  /// The ink color.
  final Color color;

  /// The line's length.
  final double width;

  /// The wave band's height; the amplitude derives from this minus the
  /// stroke, so the ink never paints outside its box.
  final double height;

  /// The pen thickness.
  final double strokeWidth;

  /// Pixels per full peak-and-valley cycle.
  final double wavelength;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _ScribblePainter(
          color: color,
          strokeWidth: strokeWidth,
          wavelength: wavelength,
        ),
      ),
    );
  }
}

class _ScribblePainter extends CustomPainter {
  const _ScribblePainter({
    required this.color,
    required this.strokeWidth,
    required this.wavelength,
  });

  final Color color;
  final double strokeWidth;
  final double wavelength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final midY = size.height / 2;
    final baseAmp = math.max(0, (size.height - strokeWidth) / 2).toDouble();
    final halfWave = wavelength / 2;

    // One quadratic bézier per half cycle, control point alternating above
    // and below the midline. The amplitude is modulated by a fixed slow sine
    // so the crests vary like handwriting rather than a plotted wave.
    final path = Path()..moveTo(strokeWidth / 2, midY);
    var x = strokeWidth / 2;
    final endX = size.width - strokeWidth / 2;
    var up = true;
    while (x < endX) {
      final nextX = math.min(x + halfWave, endX);
      final controlX = (x + nextX) / 2;
      final wobble = 0.75 + 0.25 * math.sin(controlX * 0.37);
      final amp = baseAmp * wobble * (up ? -1 : 1);
      path.quadraticBezierTo(controlX, midY + amp * 2, nextX, midY);
      x = nextX;
      up = !up;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ScribblePainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      wavelength != oldDelegate.wavelength;
}
