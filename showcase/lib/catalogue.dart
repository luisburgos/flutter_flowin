import 'package:flowin_showcase/components/showcase/showcase_entry.dart';
import 'package:flowin_showcase/pages/buttons/buttons_page.dart';
import 'package:flowin_showcase/pages/buttons/icon_buttons_page.dart';
import 'package:flowin_showcase/pages/buttons/item_buttons_page.dart';
import 'package:flowin_showcase/pages/cards/cards_page.dart';
import 'package:flowin_showcase/pages/chips/chip_groups_page.dart';
import 'package:flowin_showcase/pages/chips/chip_pagers_page.dart';
import 'package:flowin_showcase/pages/chips/chips_page.dart';
import 'package:flowin_showcase/pages/fields/input_fields_page.dart';
import 'package:flowin_showcase/pages/fields/swatches_page.dart';
import 'package:flowin_showcase/pages/fields/text_fields_page.dart';
import 'package:flowin_showcase/pages/foundations/colors_page.dart';
import 'package:flowin_showcase/pages/foundations/icons/icons_page.dart';
import 'package:flowin_showcase/pages/foundations/radius_page.dart';
import 'package:flowin_showcase/pages/foundations/spacing_page.dart';
import 'package:flowin_showcase/pages/foundations/typography_page.dart';
import 'package:flowin_showcase/pages/navigation/app_bars_page.dart';
import 'package:flowin_showcase/pages/navigation/tabs_page.dart';
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
    subtitle: 'Labelled actions across every variant, size and state',
    icon: FDIcons.done,
    builder: (_) => const ButtonsPage(),
  ),
  ShowcaseEntry(
    title: 'Icon buttons',
    subtitle: 'Circular, icon-only actions',
    icon: FDIcons.plus,
    builder: (_) => const IconButtonsPage(),
  ),
  ShowcaseEntry(
    title: 'Item buttons',
    subtitle: 'Full-width, left-aligned list and menu rows',
    icon: FDIcons.timer,
    builder: (_) => const ItemButtonsPage(),
  ),
  ShowcaseEntry(
    title: 'Chips',
    subtitle: 'Selectable labels across every variant and state',
    icon: FDIcons.board,
    builder: (_) => const ChipsPage(),
  ),
  ShowcaseEntry(
    title: 'Chip groups',
    subtitle: 'A row of chips with one selected, scrolling or wrapped',
    icon: FDIcons.arrowRightLeft,
    builder: (_) => const ChipGroupsPage(),
  ),
  ShowcaseEntry(
    title: 'Chip view pagers',
    subtitle: 'Chips that page between whole views',
    icon: FDIcons.timeline,
    builder: (_) => const ChipPagersPage(),
  ),
  ShowcaseEntry(
    title: 'Input fields',
    subtitle: 'A label and a bordered surface around any content',
    icon: FDIcons.board,
    builder: (_) => const InputFieldsPage(),
  ),
  ShowcaseEntry(
    title: 'Text fields',
    subtitle: 'Typed entry, on its own or under a label',
    icon: FDIcons.edit,
    builder: (_) => const TextFieldsPage(),
  ),
  ShowcaseEntry(
    title: 'Colour swatches',
    subtitle: 'Picking a colour, as a single swatch or a whole field',
    icon: FDIcons.paint,
    builder: (_) => const SwatchesPage(),
  ),
  ShowcaseEntry(
    title: 'Cards & surfaces',
    subtitle: 'Smooth-cornered surfaces, and the rules that separate content',
    icon: FDIcons.timeline,
    builder: (_) => const CardsPage(),
  ),
  ShowcaseEntry(
    title: 'App bars',
    subtitle: 'Page chrome, shown in place because that is the only way',
    icon: FDIcons.arrowRightLeft,
    builder: (_) => const AppBarsPage(),
  ),
  ShowcaseEntry(
    title: 'Tabs',
    subtitle: 'Switching between peer sections, fixed or scrolling',
    icon: FDIcons.settings,
    builder: (_) => const TabsPage(),
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
