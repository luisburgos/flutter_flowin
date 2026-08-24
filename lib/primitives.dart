/// Behavioural building blocks that are not catalogued components.
///
/// The main `flutter_flowin.dart` barrel is the design system's catalogued
/// surface: every widget it exports is expected to have a look of its own and
/// a card in the showcase. The widgets here are a tier below that — shared
/// primitives with behaviour but no visual identity, consumed by the
/// catalogued components and available to consumers building their own — so
/// they live behind this separate entry point instead of earning exclusion
/// entries in the catalogue sweep.
library;

export 'src/widgets/flowin_fade_page.dart';
