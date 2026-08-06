import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

/// {@template fd_svg_icons}
/// Namespace for inline SVG icon string constants.
/// {@endtemplate}
class FDSvgIcons {
  /// {@macro fd_svg_icons}
  const FDSvgIcons();

  // TODO(luis): add svg icon contents
}

/// {@template fd_svg_icon}
/// Renders an inline SVG string with optional tinting and sizing.
/// {@endtemplate}
class FDSvgIcon extends StatelessWidget {
  /// {@macro fd_svg_icon}
  const FDSvgIcon(
    this.icon, {
    super.key,
    this.color,
    this.size = 24,
    this.alignment = Alignment.center,
  });

  /// The raw SVG string to render.
  final String icon;

  /// The tint color applied via [BlendMode.srcIn]. No tint when null.
  final Color? color;

  /// The width and height of the rendered icon.
  final double? size;

  /// How the icon is aligned within its bounds.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      icon,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      width: size,
      height: size,
      alignment: alignment,
    );
  }
}
