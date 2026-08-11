import 'package:flowin_showcase/components/playground/inspector/flowin_playground_spacing_knob.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The state of the [FlowinChipGroup] preview.
///
/// `height` stays deliberately undriven: it is a free double with no token
/// scale behind it, so a knob would invent values the system does not have.
@immutable
class ChipGroupConfig {
  /// {@macro chip_group_config}
  const ChipGroupConfig({
    this.isScrollable = true,
    this.unselectedVariant = FlowinChipVariant.unselected,
    this.manyLabels = true,
    this.padding = SpacingStep.none,
    this.chipSpacing = SpacingStep.xs,
    this.runSpacing = SpacingStep.xs,
    this.wrapAlignment = WrapAlignment.start,
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

  /// Padding around the chips, applied on every side.
  ///
  /// A vertical inset grows the scrollable row rather than shrinking the
  /// chips inside it — the row is `height + padding.vertical`. It used to be
  /// the other way around: the fixed row handed the chips whatever the inset
  /// left, and this knob is what made that visible enough to fix.
  final SpacingStep padding;

  /// The gap between chips within a row.
  ///
  /// Defaults to the step the component itself uses (space200).
  final SpacingStep chipSpacing;

  /// The gap between wrapped rows, when not scrollable.
  ///
  /// The component defaults this to match [chipSpacing]; the knob passes it
  /// explicitly so the axis can be moved on its own.
  final SpacingStep runSpacing;

  /// How wrapped rows are aligned along the main axis, when not scrollable.
  final WrapAlignment wrapAlignment;

  /// A copy with the given fields replaced.
  ChipGroupConfig copyWith({
    bool? isScrollable,
    FlowinChipVariant? unselectedVariant,
    bool? manyLabels,
    SpacingStep? padding,
    SpacingStep? chipSpacing,
    SpacingStep? runSpacing,
    WrapAlignment? wrapAlignment,
  }) => ChipGroupConfig(
    isScrollable: isScrollable ?? this.isScrollable,
    unselectedVariant: unselectedVariant ?? this.unselectedVariant,
    manyLabels: manyLabels ?? this.manyLabels,
    padding: padding ?? this.padding,
    chipSpacing: chipSpacing ?? this.chipSpacing,
    runSpacing: runSpacing ?? this.runSpacing,
    wrapAlignment: wrapAlignment ?? this.wrapAlignment,
  );

  @override
  bool operator ==(Object other) =>
      other is ChipGroupConfig &&
      other.isScrollable == isScrollable &&
      other.unselectedVariant == unselectedVariant &&
      other.manyLabels == manyLabels &&
      other.padding == padding &&
      other.chipSpacing == chipSpacing &&
      other.runSpacing == runSpacing &&
      other.wrapAlignment == wrapAlignment;

  @override
  int get hashCode => Object.hash(
    isScrollable,
    unselectedVariant,
    manyLabels,
    padding,
    chipSpacing,
    runSpacing,
    wrapAlignment,
  );
}
