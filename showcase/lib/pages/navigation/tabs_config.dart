import 'package:equatable/equatable.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// How many tabs the previewed bar carries.
///
/// The count is an axis rather than a detail: it is what makes a fixed bar
/// crowd and a scrollable bar actually scroll, so the layout knob is inert
/// without it.
enum TabCount {
  /// Three tabs, which a fixed bar divides comfortably.
  few,

  /// Eight tabs, which overflow a fixed bar and give a scrollable one
  /// something to scroll.
  many,
}

/// The state of the [FlowinTabs] preview.
///
/// Value equality is what lets the playground tell a preset from a custom
/// configuration, so it is a requirement of the type rather than a
/// convenience.
class TabsConfig extends Equatable {
  /// {@macro tabs_config}
  const TabsConfig({
    this.count = TabCount.few,
    this.isScrollable = false,
    this.hasIcons = true,
    this.longLabel = false,
  });

  /// How many tabs the bar carries.
  final TabCount count;

  /// Whether the row scrolls instead of dividing the width equally.
  final bool isScrollable;

  /// Whether each tab pairs a glyph with its label.
  final bool hasIcons;

  /// Whether one label is long enough to strain the layout.
  ///
  /// A fixed bar ellipsizes it; a scrollable bar lets it take its natural
  /// width. That difference is the clearest reason to pick one layout.
  final bool longLabel;

  /// A copy with the given fields replaced.
  TabsConfig copyWith({
    TabCount? count,
    bool? isScrollable,
    bool? hasIcons,
    bool? longLabel,
  }) => TabsConfig(
    count: count ?? this.count,
    isScrollable: isScrollable ?? this.isScrollable,
    hasIcons: hasIcons ?? this.hasIcons,
    longLabel: longLabel ?? this.longLabel,
  );

  @override
  List<Object?> get props => [count, isScrollable, hasIcons, longLabel];
}
