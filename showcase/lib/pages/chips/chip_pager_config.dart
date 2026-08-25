import 'package:equatable/equatable.dart';
import 'package:flowin_showcase/components/flowin_spacing_knob.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The state of the [FlowinChipGroupViewPager] preview.
///
/// Deliberately-undriven parameters are recorded in flowin_pm#35.
class ChipPagerConfig extends Equatable {
  /// {@macro chip_pager_config}
  const ChipPagerConfig({
    this.isScrollable = false,
    this.showDivider = true,
    this.unselectedVariant = FlowinChipVariant.unselected,
    this.chipsPadding = SpacingStep.sm,
    this.keepPagesAlive = true,
  });

  /// Whether the chip row scrolls or wraps.
  final bool isScrollable;

  /// Whether a hairline separates the chips from the pages.
  final bool showDivider;

  /// The emphasis every unselected chip carries.
  final FlowinChipVariant unselectedVariant;

  /// Horizontal padding around the chip row.
  ///
  /// Horizontal only: the pager keeps the row shape a real caller gives it,
  /// and the all-sides case lives on the Chip groups page.
  final SpacingStep chipsPadding;

  /// Whether a page's state survives being swiped away.
  ///
  /// The preview gives each page a counter so this is visible rather than
  /// stated: count up, switch away and back, and the count either survives
  /// or resets with the knob.
  final bool keepPagesAlive;

  /// A copy with the given fields replaced.
  ChipPagerConfig copyWith({
    bool? isScrollable,
    bool? showDivider,
    FlowinChipVariant? unselectedVariant,
    SpacingStep? chipsPadding,
    bool? keepPagesAlive,
  }) => ChipPagerConfig(
    isScrollable: isScrollable ?? this.isScrollable,
    showDivider: showDivider ?? this.showDivider,
    unselectedVariant: unselectedVariant ?? this.unselectedVariant,
    chipsPadding: chipsPadding ?? this.chipsPadding,
    keepPagesAlive: keepPagesAlive ?? this.keepPagesAlive,
  );

  @override
  List<Object?> get props => [
    isScrollable,
    showDivider,
    unselectedVariant,
    chipsPadding,
    keepPagesAlive,
  ];
}
