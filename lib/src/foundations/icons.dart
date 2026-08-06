import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/icon_size.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// {@template fd_icon}
/// Renders a Flowin semantic icon ([FDIcons]) at a [FlowinDesignIconSize],
/// pairing the size with its matching stroke weight.
/// {@endtemplate}
class FDIcon extends StatelessWidget {
  /// {@macro fd_icon}
  const FDIcon({
    required this.icon,
    this.size = FlowinDesignIconSize.defaultSize,
    this.color,
    super.key,
  });

  /// The semantic icon to render.
  final FDIcons icon;

  /// The size of the icon. Defaults to [FlowinDesignIconSize.defaultSize].
  final FlowinDesignIconSize? size;

  /// The icon color. Falls back to the ambient [IconTheme] when null.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon.iconData,
      color: color,
      size: size?.value,
      weight: size?.stroke,
    );
  }
}

/// {@template fd_icons}
/// The Flowin semantic icon set.
///
/// Names express intent (e.g. [FDIcons.share], [FDIcons.trash]) and are mapped
/// onto concrete Lucide icons via [iconData], so the underlying icon library
/// can change without touching call sites.
/// {@endtemplate}
enum FDIcons {
  /// Board / rows layout.
  board,

  /// Timeline / route.
  timeline,

  /// Edit / settings.
  edit,

  /// Paint / palette.
  paint,

  /// Trash / delete.
  trash,

  /// Share.
  share,

  /// Plus / add.
  plus,

  /// Timer.
  timer,

  /// Swap horizontally.
  arrowRightLeft,

  /// Swap vertically.
  arrowDownUp,

  /// Settings.
  settings,

  /// Overflow / more.
  more,

  /// Close.
  x,

  /// Set to neutral.
  setNeutral,

  /// Scan face.
  scanFace,

  /// Restart.
  restart,

  /// Back.
  back,

  /// Done.
  done,

  /// Spark / AI.
  spark;

  /// Builds an [FDIcon] for this semantic icon.
  FDIcon toIcon({FlowinDesignIconSize? size, Color? color}) {
    return FDIcon(icon: this, size: size, color: color);
  }

  /// The concrete [IconData] backing this semantic icon.
  IconData get iconData => switch (this) {
    FDIcons.board => LucideIcons.rows2,
    FDIcons.timeline => LucideIcons.route,
    FDIcons.edit => LucideIcons.settings2,
    FDIcons.paint => LucideIcons.palette,
    FDIcons.trash => LucideIcons.trash,
    FDIcons.share => LucideIcons.share,
    FDIcons.plus => LucideIcons.plus,
    FDIcons.timer => LucideIcons.timer,
    FDIcons.arrowRightLeft => LucideIcons.arrowRightLeft,
    FDIcons.arrowDownUp => LucideIcons.arrowDownUp,
    FDIcons.settings => LucideIcons.settings,
    FDIcons.more => LucideIcons.ellipsisVertical,
    FDIcons.x => LucideIcons.x,
    FDIcons.setNeutral => LucideIcons.circleDashed,
    FDIcons.scanFace => LucideIcons.scanFace,
    FDIcons.restart => LucideIcons.rotateCcw,
    FDIcons.back => LucideIcons.arrowLeft,
    FDIcons.done => LucideIcons.circleCheck,
    FDIcons.spark => LucideIcons.sparkles,
  };
}
