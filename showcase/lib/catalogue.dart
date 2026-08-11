import 'package:flowin_showcase/components/showcase/showcase_entry.dart';
import 'package:flowin_showcase/pages/buttons_page.dart';
import 'package:flowin_showcase/pages/cards_page.dart';
import 'package:flowin_showcase/pages/chips_page.dart';
import 'package:flowin_showcase/pages/form_page.dart';
import 'package:flowin_showcase/pages/foundations/colors_page.dart';
import 'package:flowin_showcase/pages/foundations/icons/icons_page.dart';
import 'package:flowin_showcase/pages/foundations/radius_page.dart';
import 'package:flowin_showcase/pages/foundations/spacing_page.dart';
import 'package:flowin_showcase/pages/foundations/typography_page.dart';
import 'package:flowin_showcase/pages/navigation_page.dart';
import 'package:flowin_showcase/pages/profile_example_page.dart';
import 'package:flowin_showcase/pages/sheets/sheets_page.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The design tokens every component is built from.
///
/// Separated from [componentEntries] because a token is not a widget: these
/// pages answer "what values exist" rather than "what can I place on a
/// screen", and mixing the two makes both harder to scan.
final foundationEntries = <ShowcaseEntry>[
  ShowcaseEntry(
    title: 'Typography',
    subtitle: 'Baseline (Inter) and brand (Supreme) type scales',
    icon: FDIcons.edit,
    builder: (_) => const TypographyPage(),
  ),
  ShowcaseEntry(
    title: 'Colors',
    subtitle: 'The palette mapped onto Material ColorScheme roles',
    icon: FDIcons.paint,
    builder: (_) => const ColorsPage(),
  ),
  ShowcaseEntry(
    title: 'Spacing',
    subtitle: 'Semantic steps read from context.spacing',
    icon: FDIcons.arrowRightLeft,
    builder: (_) => const SpacingPage(),
  ),
  ShowcaseEntry(
    title: 'Radius',
    subtitle: 'The corner-radius scale',
    icon: FDIcons.board,
    builder: (_) => const RadiusPage(),
  ),
  ShowcaseEntry(
    title: 'Icons',
    subtitle: 'The semantic set, at any step of the size scale',
    icon: FDIcons.setNeutral,
    builder: (_) => const IconsPage(),
  ),
];

/// The component catalogue — one entry per widget family.
///
/// Filed by what a thing *is*, not what it is used for, so a reader who arrives
/// with a component name in hand finds it where they expect. Realistic
/// compositions live in [exampleEntries] instead.
final componentEntries = <ShowcaseEntry>[
  ShowcaseEntry(
    title: 'Buttons',
    subtitle: 'Button, IconButton, ItemButton — all variants and sizes',
    icon: FDIcons.done,
    builder: (_) => const ButtonsPage(),
  ),
  ShowcaseEntry(
    title: 'Chips',
    subtitle: 'Chip, ChipGroup, ChipGroupViewPager',
    icon: FDIcons.board,
    builder: (_) => const ChipsPage(),
  ),
  ShowcaseEntry(
    title: 'Fields',
    subtitle: 'InputField, TextField, colour swatches',
    icon: FDIcons.edit,
    builder: (_) => const FormPage(),
  ),
  ShowcaseEntry(
    title: 'Cards & surfaces',
    subtitle: 'Card radii, shadows, dividers, semantic colors',
    icon: FDIcons.timeline,
    builder: (_) => const CardsPage(),
  ),
  ShowcaseEntry(
    title: 'App bars & tabs',
    subtitle: 'AppBar, TabAppBar, Tabs — each in a full-page demo',
    icon: FDIcons.arrowRightLeft,
    builder: (_) => const NavigationPage(),
  ),
  ShowcaseEntry(
    title: 'Action sheets',
    subtitle: 'Modal sheets, headers, footers, confirmation flows',
    icon: FDIcons.more,
    builder: (_) => const SheetsPage(),
  ),
];

/// Realistic screens assembled from the catalogue above.
///
/// An example earns a place here when the *composition* is the point — state
/// flowing between components, or a layout only visible at screen scale. It
/// reuses catalogued components rather than introducing new ones.
final exampleEntries = <ShowcaseEntry>[
  ShowcaseEntry(
    title: 'Create profile',
    subtitle: 'Labelled fields feeding a live preview, with a submit action',
    icon: FDIcons.scanFace,
    builder: (_) => const ProfileExamplePage(),
  ),
];
