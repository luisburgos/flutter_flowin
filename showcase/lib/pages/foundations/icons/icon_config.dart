import 'package:equatable/equatable.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The state of the icon-set preview.
///
/// Value equality is what lets the playground tell a preset from a custom
/// configuration, so it is a requirement of the type rather than a
/// convenience.
class IconConfig extends Equatable {
  /// {@macro icon_config}
  const IconConfig({
    this.size = FlowinDesignIconSize.md,
    this.showLabels = true,
  });

  /// The size every glyph renders at.
  final FlowinDesignIconSize size;

  /// Whether each glyph is captioned with its name.
  final bool showLabels;

  /// A copy with the given fields replaced.
  IconConfig copyWith({FlowinDesignIconSize? size, bool? showLabels}) =>
      IconConfig(
        size: size ?? this.size,
        showLabels: showLabels ?? this.showLabels,
      );

  @override
  List<Object?> get props => [size, showLabels];
}
