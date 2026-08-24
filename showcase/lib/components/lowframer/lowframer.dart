import 'package:flutter_flowin/flutter_flowin.dart';

/// The fixed footprint of a [LowframerWindow], landscape orientation.
const Size _kWindowSize = Size(160, 120);

/// The corner radius of the window frame.
const double _kWindowRadius = 6;

/// The colors a lowframer composition paints with.
///
/// Resolved from the ambient [ColorScheme] rather than carried as a standalone
/// palette object: the art must follow the app's theme, including dark mode,
/// and a scheme-derived palette gets that for free.
class LowframerPalette {
  const LowframerPalette._({
    required this.backdrop,
    required this.background,
    required this.border,
    required this.fill,
    required this.fillStrong,
    required this.accent,
  });

  /// Derives the palette from [context]'s [ColorScheme].
  factory LowframerPalette.of(BuildContext context) {
    final scheme = context.colorScheme;
    return LowframerPalette._(
      backdrop: scheme.onSurface.withValues(alpha: 0.05),
      background: scheme.surface,
      border: scheme.outlineVariant,
      // Alpha over onSurface rather than the container roles: on this scheme
      // surfaceContainerHighest sits within a hair of surface, which made the
      // quiet shapes invisible at art scale.
      fill: scheme.onSurface.withValues(alpha: 0.14),
      fillStrong: scheme.onSurface.withValues(alpha: 0.35),
      accent: scheme.primary,
    );
  }

  /// The cover panel's wash, one quiet step off the card it sits on.
  final Color backdrop;

  /// The window's canvas color.
  final Color background;

  /// The window's hairline frame color.
  final Color border;

  /// The quiet placeholder fill.
  final Color fill;

  /// A stronger fill for elements that must read above [fill].
  final Color fillStrong;

  /// The single emphasis color, used sparingly.
  final Color accent;
}

/// The height of a [LowframerCover] panel.
const double _kCoverHeight = 150;

/// The full-width panel a cover art sits on inside a card.
///
/// The panel is what makes the art read as a cover rather than a floating
/// glyph: a quiet wash the full width of the card, with the framed window
/// centered and lifted off it.
class LowframerCover extends StatelessWidget {
  /// {@macro lowframer_cover}
  const LowframerCover({required this.child, super.key});

  /// The framed art to center on the panel.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return Container(
      width: double.infinity,
      height: _kCoverHeight,
      decoration: BoxDecoration(
        color: palette.backdrop,
        borderRadius: BorderRadius.circular(FlowinDesignRadius.radius400),
      ),
      child: Center(child: child),
    );
  }
}

/// The miniature framed canvas every cover art draws inside.
///
/// Fixed-size on purpose: the art is an illustration, not a layout, and a
/// fixed frame keeps every card's art the same optical weight.
class LowframerWindow extends StatelessWidget {
  /// {@macro lowframer_window}
  const LowframerWindow({required this.child, super.key});

  /// The composition to frame.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return Container(
      width: _kWindowSize.width,
      height: _kWindowSize.height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: palette.background,
        border: Border.all(color: palette.border, width: 0.5),
        borderRadius: BorderRadius.circular(_kWindowRadius),
        // Lifts the window off the cover wash; near-invisible in dark, where
        // the surface-on-wash contrast already does the separating.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// The one placeholder shape.
///
/// A rounded box covers every wireframe element — a line is a short flat box,
/// a pill is a box at stadium radius, a circle is a box at `size / 2` — so the
/// kit needs exactly one shape primitive instead of a Square/Circle/Line trio
/// that all wrap the same [Container].
class LowframerBox extends StatelessWidget {
  /// {@macro lowframer_box}
  const LowframerBox({
    required this.color,
    this.width = double.infinity,
    this.height = 4,
    this.radius = 2,
    this.borderColor,
    this.child,
    super.key,
  });

  /// A text-placeholder line: short, flat, quiet.
  const LowframerBox.line({
    required this.color,
    this.width = 32,
    this.height = 4,
    super.key,
  }) : radius = 2,
       borderColor = null,
       child = null;

  /// A pill — stadium-radius box, the button/chip silhouette.
  const LowframerBox.pill({
    required this.color,
    required this.width,
    this.height = 12,
    this.borderColor,
    this.child,
    super.key,
  }) : radius = 999;

  /// The fill color.
  final Color color;

  /// The box width. Defaults to filling the parent.
  final double width;

  /// The box height.
  final double height;

  /// The corner radius.
  final double radius;

  /// An optional hairline border, for outlined silhouettes.
  final Color? borderColor;

  /// Optional content, for boxes that frame smaller shapes (e.g. a sheet).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 0.75),
      ),
      child: child,
    );
  }
}
