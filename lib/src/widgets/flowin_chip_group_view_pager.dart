import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';
import 'package:flutter_flowin/src/widgets/flowin_chip.dart';
import 'package:flutter_flowin/src/widgets/flowin_chip_group.dart';

/// {@template flowin_chip_group_view_page}
/// One tab in a [FlowinChipGroupViewPager]: a chip [label] plus a lazily-built
/// [builder] for its page.
/// {@endtemplate}
class FlowinChipGroupViewPage {
  /// {@macro flowin_chip_group_view_page}
  const FlowinChipGroupViewPage({required this.label, required this.builder});

  /// Convenience for a static child.
  factory FlowinChipGroupViewPage.child({
    required String label,
    required Widget child,
  }) => FlowinChipGroupViewPage(label: label, builder: (_) => child);

  /// The chip label for this page.
  final String label;

  /// Builds the page content.
  final WidgetBuilder builder;
}

/// {@template flowin_chip_group_view_pager}
/// A [FlowinChipGroup] wired to a [PageView]: tapping a chip animates to its
/// page, and swiping pages updates the selected chip.
///
/// Pages are built lazily and (optionally) kept alive to preserve their state.
/// {@endtemplate}
class FlowinChipGroupViewPager extends StatefulWidget {
  /// {@macro flowin_chip_group_view_pager}
  const FlowinChipGroupViewPager({
    required this.items,
    this.initialIndex = 0,
    this.onIndexChanged,
    this.keepPagesAlive = true,
    this.isScrollable = true,
    this.unselectedVariant = FlowinChipVariant.unselected,
    this.animateDuration = const Duration(milliseconds: 280),
    this.animateCurve = Curves.easeOutCubic,
    this.pagePhysics = const BouncingScrollPhysics(),
    this.pageController,
    this.chipGroupController,
    this.chipBuilder,
    this.chipsPadding,
    this.chipSpacing,
    this.chipRunSpacing,
    this.chipWrapAlignment = WrapAlignment.start,
    super.key,
  }) : assert(
         items.length > 0,
         'FlowinChipGroupViewPager requires at least one item.',
       );

  /// The pages, in order.
  final List<FlowinChipGroupViewPage> items;

  /// The initially-selected page.
  ///
  /// Ignored when [pageController] / [chipGroupController] are supplied (the
  /// external controllers carry their own initial state).
  final int initialIndex;

  /// Called whenever the selected page changes.
  final ValueChanged<int>? onIndexChanged;

  /// Whether to keep built pages alive.
  final bool keepPagesAlive;

  /// Whether the chip row scrolls horizontally.
  final bool isScrollable;

  /// The variant used for unselected chips.
  final FlowinChipVariant unselectedVariant;

  /// The page-transition duration when a chip is tapped.
  final Duration animateDuration;

  /// The page-transition curve when a chip is tapped.
  final Curve animateCurve;

  /// The scroll physics for **both** of this component's scrollers — the page
  /// view and the chip row.
  ///
  /// The two sit one above the other and scroll the same axis, so letting them
  /// differ would put two horizontal scrollers with different feel on the same
  /// screen. One knob governs both; the chip row accepts its own physics for
  /// standalone use, and this forwards to it.
  final ScrollPhysics? pagePhysics;

  /// An optional external page controller (controlled mode). When null, the
  /// component creates and owns one internally. A caller-supplied controller is
  /// **not** disposed by this component.
  final PageController? pageController;

  /// An optional external chip-selection controller (controlled mode). When
  /// null, the component creates and owns one internally. A caller-supplied
  /// controller is **not** disposed by this component.
  final FlowinChipGroupController? chipGroupController;

  /// Optional custom chip builder forwarded to the chip row. When null, chips
  /// render from their labels through the themed chip row.
  final FlowinChipBuilder? chipBuilder;

  /// Optional padding forwarded to the chip row. When null, the chip row's own
  /// default padding applies.
  final EdgeInsets? chipsPadding;

  /// Optional inter-chip spacing forwarded to the chip row. When null, the chip
  /// row's own default spacing applies.
  final double? chipSpacing;

  /// Optional vertical spacing between wrapped chip rows, forwarded to the chip
  /// row. Only applies when [isScrollable] is false.
  final double? chipRunSpacing;

  /// How wrapped chip rows align, forwarded to the chip row. Only applies when
  /// [isScrollable] is false.
  final WrapAlignment chipWrapAlignment;

  @override
  State<FlowinChipGroupViewPager> createState() =>
      _FlowinChipGroupViewPagerState();
}

class _FlowinChipGroupViewPagerState extends State<FlowinChipGroupViewPager> {
  late final int _initialIndex = widget.initialIndex.clamp(
    0,
    widget.items.length - 1,
  );

  late final PageController _pageController =
      widget.pageController ?? PageController(initialPage: _initialIndex);
  late final bool _ownsPageController = widget.pageController == null;

  late final FlowinChipGroupController _chipController =
      widget.chipGroupController ??
      FlowinChipGroupController(initialIndex: _initialIndex);
  late final bool _ownsChipController = widget.chipGroupController == null;

  @override
  void dispose() {
    // Only dispose controllers this component created; caller-owned ones are
    // the caller's responsibility.
    if (_ownsPageController) _pageController.dispose();
    if (_ownsChipController) _chipController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    unawaited(
      _pageController.animateToPage(
        index,
        duration: widget.animateDuration,
        curve: widget.animateCurve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: FlowinDesignSpace.space300,
      // Stretch the chip row to the pager's width. A wrapped row sizes itself
      // to its widest line, so without this the whole block would be centred
      // by the column and its leading alignment would be invisible.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlowinChipGroup(
          labels: [for (final item in widget.items) item.label],
          controller: _chipController,
          unselectedVariant: widget.unselectedVariant,
          isScrollable: widget.isScrollable,
          onSelected: _goToPage,
          chipBuilder: widget.chipBuilder,
          padding:
              widget.chipsPadding ??
              const EdgeInsets.symmetric(
                horizontal: FlowinDesignSpace.space300,
              ),
          chipSpacing: widget.chipSpacing ?? FlowinDesignSpace.space200,
          physics: widget.pagePhysics,
          chipRunSpacing: widget.chipRunSpacing,
          wrapAlignment: widget.chipWrapAlignment,
        ),
        const Divider(),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: widget.pagePhysics,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              _chipController.index = index;
              widget.onIndexChanged?.call(index);
            },
            itemBuilder: (context, index) {
              final page = widget.items[index].builder(context);
              if (!widget.keepPagesAlive) return page;
              return _KeepAlive(
                key: PageStorageKey<String>('flowin_chip_page_$index'),
                child: page,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child, super.key});

  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
