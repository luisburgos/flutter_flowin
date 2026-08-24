import 'package:flutter_flowin/flutter_flowin.dart';

/// A single entry in the showcase index.
class ShowcaseEntry {
  /// {@macro showcase_entry}
  const ShowcaseEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.builder,
    this.coverArt,
  });

  /// The page title.
  final String title;

  /// A one-line description of what the page covers.
  final String subtitle;

  /// The leading semantic icon.
  final FDIcons icon;

  /// Builds the destination page.
  final WidgetBuilder builder;

  /// Builds an optional lowframer cover art rendered on the entry's card.
  ///
  /// When present the card leads with the art instead of [icon]; entries
  /// without one keep the icon-only look, so migration is per-card.
  final WidgetBuilder? coverArt;
}
