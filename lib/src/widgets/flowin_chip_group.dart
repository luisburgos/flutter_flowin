import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';
import 'package:flutter_flowin/src/widgets/flowin_chip.dart';

/// {@template flowin_chip_group_controller}
/// Drives and reports the selected index of a [FlowinChipGroup].
///
/// Pass one to use the group in *controlled* mode; omit it and the group
/// manages its own (*uncontrolled* mode).
/// {@endtemplate}
class FlowinChipGroupController extends ChangeNotifier {
  /// {@macro flowin_chip_group_controller}
  FlowinChipGroupController({int initialIndex = 0})
    : _index = initialIndex < 0 ? 0 : initialIndex;

  int _index;

  /// The currently selected index.
  int get index => _index;

  set index(int value) {
    if (_index == value) return;
    _index = value;
    notifyListeners();
  }
}

/// Builds a custom chip for [FlowinChipGroup] at `index`.
///
/// Receives the item's `label`, its current `isSelected` state, and the
/// `onSelected` callback the chip must invoke to request selection. Return any
/// widget (typically a [FlowinChip]) — this overrides the default label chip.
///
/// The positional params follow the conventional Flutter builder shape
/// (index, value, state, callback), so the positional bool is intentional.
typedef FlowinChipBuilder =
    Widget Function(
      int index,
      String label,
      // Conventional builder shape; positional bool is intentional.
      // ignore: avoid_positional_boolean_parameters
      bool isSelected,
      ValueChanged<bool> onSelected,
    );

/// {@template flowin_chip_group}
/// A single-select row (or wrap) of [FlowinChip]s.
///
/// Material has no single-select chip-group widget, so selection is managed
/// here via a [FlowinChipGroupController] (controlled or uncontrolled). Each
/// chip's visuals come from the theme's `chipTheme`; only the group layout
/// (spacing, padding, scroll) is custom.
///
/// By default each option renders as a themed label chip. Supply [chipBuilder]
/// to render custom chip content while keeping the simple [labels] path.
/// {@endtemplate}
class FlowinChipGroup extends StatefulWidget {
  /// {@macro flowin_chip_group}
  const FlowinChipGroup({
    required this.labels,
    this.controller,
    this.initialSelectedIndex,
    this.unselectedVariant = FlowinChipVariant.unselected,
    this.onSelected,
    this.onSelectedLabel,
    this.onLongPress,
    this.chipBuilder,
    this.isScrollable = true,
    this.height,
    this.padding = const EdgeInsets.symmetric(
      horizontal: FlowinDesignSpace.space300,
    ),
    this.chipSpacing = FlowinDesignSpace.space200,
    this.chipRunSpacing,
    this.wrapAlignment = WrapAlignment.start,
    super.key,
  }) : assert(labels.length > 0, 'FlowinChipGroup requires at least one chip.');

  /// The chip labels, in order.
  final List<String> labels;

  /// An optional external controller (controlled mode).
  final FlowinChipGroupController? controller;

  /// The initial selected index when uncontrolled (ignored if [controller]
  /// is provided).
  final int? initialSelectedIndex;

  /// The variant used for unselected chips.
  final FlowinChipVariant unselectedVariant;

  /// Called with the newly selected index after a chip is tapped.
  final ValueChanged<int>? onSelected;

  /// Called with the newly selected label after a chip is tapped.
  ///
  /// Convenience alongside [onSelected]; both fire on the same tap.
  final ValueChanged<String>? onSelectedLabel;

  /// Called with the index of a long-pressed chip. Does not change selection.
  final ValueChanged<int>? onLongPress;

  /// Optional builder for custom chip content. When null, each option renders
  /// as a default themed label chip.
  final FlowinChipBuilder? chipBuilder;

  /// Whether the chips scroll horizontally. When false they [Wrap].
  final bool isScrollable;

  /// The fixed height of the row when scrollable.
  final double? height;

  /// Padding around the chips.
  final EdgeInsets padding;

  /// Spacing between chips.
  final double chipSpacing;

  /// Vertical spacing between wrapped rows, when not scrollable.
  ///
  /// Defaults to [chipSpacing] so wrapped rows are separated by the same gap
  /// that separates chips within a row. The legacy reference left this at
  /// [Wrap]'s own default (0), which let rows touch; a null run spacing here
  /// means "match [chipSpacing]", not "zero".
  final double? chipRunSpacing;

  /// How wrapped rows are aligned along the main axis, when not scrollable.
  ///
  /// Defaults to [WrapAlignment.start] so a partial last row lines up with the
  /// rows above it. The legacy reference centred them, which left a short final
  /// row floating out of alignment with the chips above; see
  /// `flowinChipGroupWrapAlignment`.
  final WrapAlignment wrapAlignment;

  @override
  State<FlowinChipGroup> createState() => _FlowinChipGroupState();
}

class _FlowinChipGroupState extends State<FlowinChipGroup> {
  late FlowinChipGroupController _controller;
  late bool _ownsController;

  @override
  void initState() {
    super.initState();
    _attachController();
  }

  void _attachController() {
    if (widget.controller == null) {
      final initial = (widget.initialSelectedIndex ?? 0).clamp(
        0,
        widget.labels.length - 1,
      );
      _controller = FlowinChipGroupController(initialIndex: initial);
      _ownsController = true;
    } else {
      _controller = widget.controller!;
      _ownsController = false;
    }
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(FlowinChipGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_onChanged);
      if (_ownsController) _controller.dispose();
      _attachController();
    }
    final maxIndex = widget.labels.length - 1;
    if (_controller.index > maxIndex) _controller.index = maxIndex;
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _select(int index) {
    _controller.index = index;
    widget.onSelected?.call(index);
    widget.onSelectedLabel?.call(widget.labels[index]);
  }

  Widget _buildChip(int index) {
    final isSelected = index == _controller.index;
    final label = widget.labels[index];
    // Conforms to the chip's ValueChanged<bool> onSelected contract; the bool
    // (desired selection) is ignored since tapping always selects.
    // ignore: avoid_positional_boolean_parameters
    void onSelected(bool _) => _select(index);

    final chip =
        widget.chipBuilder?.call(index, label, isSelected, onSelected) ??
        FlowinChip(
          label: Text(label),
          variant: isSelected
              ? FlowinChipVariant.selected
              : widget.unselectedVariant,
          onSelected: onSelected,
        );

    if (widget.onLongPress == null) return chip;
    return GestureDetector(
      onLongPress: () => widget.onLongPress!.call(index),
      child: chip,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isScrollable) {
      return Padding(
        padding: widget.padding,
        child: Wrap(
          alignment: widget.wrapAlignment,
          spacing: widget.chipSpacing,
          runSpacing: widget.chipRunSpacing ?? widget.chipSpacing,
          children: [
            for (var i = 0; i < widget.labels.length; i++) _buildChip(i),
          ],
        ),
      );
    }

    return SizedBox(
      height: widget.height ?? FlowinDesignSpace.space1200,
      child: ListView.separated(
        padding: widget.padding,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.labels.length,
        separatorBuilder: (_, _) => SizedBox(width: widget.chipSpacing),
        itemBuilder: (_, index) => Center(child: _buildChip(index)),
      ),
    );
  }
}
