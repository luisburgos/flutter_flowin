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

  /// Forces the backing icon library to initialize.
  ///
  /// Call once from `main()`, before `runApp`, on any app that renders Flowin
  /// icons on the web.
  ///
  /// **Why this is needed.** The `lucide_icons_flutter` library declares ~28k
  /// `static const IconData` fields in a single class. In debug web builds
  /// (DDC), a library is initialized lazily behind a `Proxy` on first property
  /// access, and that initialization recursively links the library's
  /// dependencies *on the calling stack*. When the first access happens inside
  /// [FDIcon.build], the element mount chain has already consumed several
  /// hundred frames, and linking this library on top of that exhausts the JS
  /// stack — surfacing as a `StackOverflowError` thrown while building
  /// [FDIcon], and then as a downstream layout overflow where the failed icon
  /// is replaced by an unbounded `ErrorWidget`.
  ///
  /// Touching the library from `main()` moves that one-time cost to a shallow
  /// stack, so every later access finds it already initialized. Release web
  /// builds (dart2js/Wasm) and all native targets are unaffected, where this
  /// is a cheap no-op.
  static void warmUp() {
    // The specific icon is irrelevant: one access initializes the library.
    FDIcons.board.iconData;
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
