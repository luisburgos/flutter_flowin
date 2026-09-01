import 'package:flowin_showcase/components/showcase/cover_arts/cover_arts.dart';
import 'package:flowin_showcase/pages/buttons/buttons_page.dart';
import 'package:flowin_showcase/pages/buttons/icon_buttons_page.dart';
import 'package:flowin_showcase/pages/buttons/item_buttons_page.dart';
import 'package:flowin_showcase/pages/cards/cards_page.dart';
import 'package:flowin_showcase/pages/chips/chip_groups_page.dart';
import 'package:flowin_showcase/pages/chips/chip_pagers_page.dart';
import 'package:flowin_showcase/pages/chips/chips_page.dart';
import 'package:flowin_showcase/pages/dividers/dividers_page.dart';
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
import 'package:lowframer/lowframer.dart';
import 'package:showcaser/showcaser.dart';

/// The design tokens every component is built from.
///
/// Separated from [componentEntries] because a token is not a widget: these
/// pages answer "what values exist" rather than "what can I place on a
/// screen", and mixing the two makes both harder to scan.
final foundationEntries = <ShowcaseEntry>[
  ShowcaseEntry(
    title: 'Typography',
    subtitle: 'The Inter type scale, mapped onto Material roles',
    icon: FDIcons.edit.toIcon(),
    builder: (_) => const TypographyPage(),
    coverArt: (_) => const LowframerCover(child: TypographyCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Colors',
    subtitle: 'The palette mapped onto Material ColorScheme roles',
    icon: FDIcons.paint.toIcon(),
    builder: (_) => const ColorsPage(),
    coverArt: (_) => const LowframerCover(child: ColorsCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Spacing',
    subtitle: 'Semantic steps read from context.spacing',
    icon: FDIcons.arrowRightLeft.toIcon(),
    builder: (_) => const SpacingPage(),
    coverArt: (_) => const LowframerCover(child: SpacingCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Radius',
    subtitle: 'The corner-radius scale',
    icon: FDIcons.board.toIcon(),
    builder: (_) => const RadiusPage(),
    coverArt: (_) => const LowframerCover(child: RadiusCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Icons',
    subtitle: 'The semantic set, at any step of the size scale',
    icon: FDIcons.setNeutral.toIcon(),
    builder: (_) => const IconsPage(),
    coverArt: (_) => const LowframerCover(child: IconsCoverArt()),
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
    icon: FDIcons.done.toIcon(),
    builder: (_) => const ButtonsPage(),
    coverArt: (_) => const LowframerCover(child: ButtonsCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Icon buttons',
    subtitle: 'Circular, icon-only actions',
    icon: FDIcons.plus.toIcon(),
    builder: (_) => const IconButtonsPage(),
    coverArt: (_) => const LowframerCover(child: IconButtonsCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Item buttons',
    subtitle: 'Full-width, left-aligned list and menu rows',
    icon: FDIcons.timer.toIcon(),
    builder: (_) => const ItemButtonsPage(),
    coverArt: (_) => const LowframerCover(child: ItemButtonsCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Chips',
    subtitle: 'Selectable labels across every variant and state',
    icon: FDIcons.board.toIcon(),
    builder: (_) => const ChipsPage(),
    coverArt: (_) => const LowframerCover(child: ChipsCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Chip groups',
    subtitle: 'A row of chips with one selected, scrolling or wrapped',
    icon: FDIcons.arrowRightLeft.toIcon(),
    builder: (_) => const ChipGroupsPage(),
    coverArt: (_) => const LowframerCover(child: ChipGroupsCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Chip view pagers',
    subtitle: 'Chips that page between whole views',
    icon: FDIcons.timeline.toIcon(),
    builder: (_) => const ChipPagersPage(),
    coverArt: (_) => const LowframerCover(child: ChipPagersCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Input fields',
    subtitle: 'A label and a bordered surface around any content',
    icon: FDIcons.board.toIcon(),
    builder: (_) => const InputFieldsPage(),
    coverArt: (_) => const LowframerCover(child: InputFieldsCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Text fields',
    subtitle: 'Typed entry, on its own or under a label',
    icon: FDIcons.edit.toIcon(),
    builder: (_) => const TextFieldsPage(),
    coverArt: (_) => const LowframerCover(child: TextFieldsCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Colour swatches',
    subtitle: 'Picking a colour, as a single swatch or a whole field',
    icon: FDIcons.paint.toIcon(),
    builder: (_) => const SwatchesPage(),
    coverArt: (_) => const LowframerCover(child: SwatchesCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Cards & surfaces',
    subtitle: 'Smooth-cornered surfaces, and keeping their content readable',
    icon: FDIcons.timeline.toIcon(),
    builder: (_) => const CardsPage(),
    coverArt: (_) => const LowframerCover(child: CardsCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Dividers',
    subtitle: 'Theme-styled rules between stacked or side-by-side content',
    icon: FDIcons.arrowRightLeft.toIcon(),
    builder: (_) => const DividersPage(),
    coverArt: (_) => const LowframerCover(child: DividersCoverArt()),
  ),
  ShowcaseEntry(
    title: 'App bars',
    subtitle: 'Page chrome, shown in place because that is the only way',
    icon: FDIcons.arrowRightLeft.toIcon(),
    builder: (_) => const AppBarsPage(),
    coverArt: (_) => const LowframerCover(child: AppBarsCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Tabs',
    subtitle: 'Switching between peer sections, fixed or scrolling',
    icon: FDIcons.settings.toIcon(),
    builder: (_) => const TabsPage(),
    coverArt: (_) => const LowframerCover(child: TabsCoverArt()),
  ),
  ShowcaseEntry(
    title: 'Action sheets',
    subtitle: 'Modal sheets, headers, footers, confirmation flows',
    icon: FDIcons.more.toIcon(),
    builder: (_) => const SheetsPage(),
    coverArt: (_) => const LowframerCover(child: SheetsCoverArt()),
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
    icon: FDIcons.scanFace.toIcon(),
    builder: (_) => const ProfileExamplePage(),
    coverArt: (_) => const LowframerCover(child: ProfileExampleCoverArt()),
  ),
];
