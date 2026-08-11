import 'package:flutter_flowin/flutter_flowin.dart';

/// The state of the [FlowinChipGroupViewPager] preview.
@immutable
class ChipPagerConfig {
  /// {@macro chip_pager_config}
  const ChipPagerConfig({this.isScrollable = false, this.showDivider = true});

  /// Whether the chip row scrolls horizontally or wraps.
  final bool isScrollable;

  /// Whether a hairline separates the chip row from the pages.
  final bool showDivider;

  /// A copy with the given fields replaced.
  ChipPagerConfig copyWith({bool? isScrollable, bool? showDivider}) =>
      ChipPagerConfig(
        isScrollable: isScrollable ?? this.isScrollable,
        showDivider: showDivider ?? this.showDivider,
      );

  @override
  bool operator ==(Object other) =>
      other is ChipPagerConfig &&
      other.isScrollable == isScrollable &&
      other.showDivider == showDivider;

  @override
  int get hashCode => Object.hash(isScrollable, showDivider);
}
