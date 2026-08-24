import 'dart:math' as math;

import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// A line of handwriting with no words in it.
///
/// Where [LowframerBox.line] stands in for typeset text, this stands in for
/// *written* text: wavy pen strokes broken into word-sized runs, with the
/// pen lifting between them. [height] and [strokeWidth] together read as the
/// writing's size, and [wavelength] is its frequency — tight cycles scrawl,
/// wide ones read as lazy cursive. [seed] varies the handwriting, so two
/// lines with the same knobs still read as different sentences. [fontStyle]
/// mirrors [TextStyle.fontStyle]: italic slants the whole stroke.
///
/// Deterministic on purpose: every irregularity — amplitude, cycle width,
/// word lengths, gaps — comes from a hash of the segment index and [seed],
/// not from randomness, so the same input always paints the same pixels and
/// tests stay stable.
class LowframerScribble extends StatelessWidget {
  /// {@macro lowframer_scribble}
  const LowframerScribble({
    required this.color,
    this.width = 48,
    this.height = 8,
    this.strokeWidth = 2,
    this.wavelength = 10,
    this.seed = 0,
    this.fontStyle = FontStyle.normal,
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

  /// Pixels per full peak-and-valley cycle, before per-cycle jitter.
  final double wavelength;

  /// Varies the handwriting deterministically; same seed, same stroke.
  final int seed;

  /// Mirrors [TextStyle.fontStyle]: [FontStyle.italic] slants the stroke.
  final FontStyle fontStyle;

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
          seed: seed,
          fontStyle: fontStyle,
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
    required this.seed,
    required this.fontStyle,
  });

  final Color color;
  final double strokeWidth;
  final double wavelength;
  final int seed;
  final FontStyle fontStyle;

  /// A deterministic hash in [0, 1) from a segment index and the seed — the
  /// shader-style fractional-sine trick, so no [math.Random] state is
  /// involved and identical input always yields identical output.
  double _hash(int i) {
    final v = math.sin(i * 12.9898 + seed * 78.233) * 43758.5453;
    return v - v.floorToDouble();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final midY = size.height / 2;

    if (fontStyle == FontStyle.italic) {
      // Shear about the midline so the slant costs no horizontal drift: a
      // point at the midline stays put, crests lean right, valleys left —
      // the same oblique a TextStyle italic applies to upright glyphs.
      canvas
        ..translate(0, midY)
        ..transform((Matrix4.identity()..setEntry(0, 1, -0.3)).storage)
        ..translate(0, -midY);
    }

    final baseAmp = math.max(0, (size.height - strokeWidth) / 2).toDouble();
    final halfWave = wavelength / 2;
    final endX = size.width - strokeWidth / 2;

    final path = Path();
    var x = strokeWidth / 2;
    var segment = 0;
    var up = true;

    while (x < endX) {
      // A word: a run of half-waves with the pen down.
      final wordHalfWaves = 3 + (_hash(segment) * 5).floor();
      path.moveTo(x, midY);
      var drewAny = false;
      for (var i = 0; i < wordHalfWaves && x < endX; i++) {
        segment++;
        final hw = halfWave * (0.7 + 0.6 * _hash(segment));
        // Stop rather than squeeze: a truncated final curve reads as the
        // stroke being cut mid-letter.
        if (!drewAny && x + hw > endX) return;
        if (x + hw > endX && (endX - x) < hw * 0.5) break;
        final nextX = math.min(x + hw, endX);
        final amp =
            baseAmp * (0.45 + 0.55 * _hash(segment + 31)) * (up ? -1 : 1);
        path.quadraticBezierTo((x + nextX) / 2, midY + amp * 2, nextX, midY);
        x = nextX;
        up = !up;
        drewAny = true;
      }
      // The pen lifts between words.
      segment++;
      x += wavelength * (0.45 + 0.4 * _hash(segment));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ScribblePainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      wavelength != oldDelegate.wavelength ||
      seed != oldDelegate.seed ||
      fontStyle != oldDelegate.fontStyle;
}
