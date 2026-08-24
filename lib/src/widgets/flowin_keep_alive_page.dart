import 'package:flutter/material.dart';

/// {@template flowin_keep_alive_page}
/// Keeps a lazily-built page alive when its scroller would otherwise dispose
/// it.
///
/// [PageView] and [TabBarView] build pages on demand and dispose them once
/// they scroll far enough away, which discards their state — scroll
/// positions, text in progress, expanded sections. Wrapping a page in this
/// pins it via [AutomaticKeepAliveClientMixin] so returning to it finds it as
/// it was left.
///
/// Give it a [PageStorageKey] when the scroller recycles positions, so the
/// framework can match the kept state back to the right page.
/// {@endtemplate}
class FlowinKeepAlivePage extends StatefulWidget {
  /// {@macro flowin_keep_alive_page}
  const FlowinKeepAlivePage({required this.child, super.key});

  /// The page content to keep alive.
  final Widget child;

  @override
  State<FlowinKeepAlivePage> createState() => _FlowinKeepAlivePageState();
}

class _FlowinKeepAlivePageState extends State<FlowinKeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
