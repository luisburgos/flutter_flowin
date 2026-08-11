import 'package:flutter_flowin/flutter_flowin.dart';

/// The state of the [FlowinChipGroup] preview.
@immutable
class ChipGroupConfig {
  /// {@macro chip_group_config}
  const ChipGroupConfig({
    this.isScrollable = true,
    this.unselectedVariant = FlowinChipVariant.unselected,
    this.manyLabels = true,
  });

  /// Whether the row scrolls horizontally or wraps onto more lines.
  final bool isScrollable;

  /// The emphasis every unselected chip carries.
  final FlowinChipVariant unselectedVariant;

  /// Whether the group holds enough labels to overflow one line.
  ///
  /// The scrollable knob does nothing visible until the labels exceed the
  /// available width, so the two are read together.
  final bool manyLabels;

  /// A copy with the given fields replaced.
  ChipGroupConfig copyWith({
    bool? isScrollable,
    FlowinChipVariant? unselectedVariant,
    bool? manyLabels,
  }) => ChipGroupConfig(
    isScrollable: isScrollable ?? this.isScrollable,
    unselectedVariant: unselectedVariant ?? this.unselectedVariant,
    manyLabels: manyLabels ?? this.manyLabels,
  );

  @override
  bool operator ==(Object other) =>
      other is ChipGroupConfig &&
      other.isScrollable == isScrollable &&
      other.unselectedVariant == unselectedVariant &&
      other.manyLabels == manyLabels;

  @override
  int get hashCode => Object.hash(isScrollable, unselectedVariant, manyLabels);
}
