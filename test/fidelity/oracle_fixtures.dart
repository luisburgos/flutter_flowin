// Resolved-style fixtures extracted from the production flowin_design package
// (fidelity oracle: Archive/flowin_design @ fidelity-oracle-0.3.0 / 9e3a513).
//
// Each constant records the value the production component actually resolves
// at runtime, with a citation to the archive file it was read from. Fidelity
// tests assert flutter_flowin renders the same values under FlowinTheme.
//
// These are intentionally raw doubles/roles rather than references to
// flutter_flowin tokens: the point is to pin the ORACLE's numbers, so a
// token change in flutter_flowin cannot silently move the expectation.

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Buttons — fd_button.dart / fd_button_size.dart / fd_button_utils.dart
// ---------------------------------------------------------------------------

/// Per-size metrics for FDButton/FDIconButton (fd_button_size.dart).
///
/// `fixedSize` is the button height; `outerPadding` is the transparent
/// wrapper padding around the button (vertical-only for FDButton,
/// all-sides for FDIconButton); `iconSize` is the resolved icon size value.
class OracleButtonSize {
  const OracleButtonSize({
    required this.fixedSize,
    required this.innerPadding,
    required this.outerPadding,
    required this.iconSize,
  });

  final double fixedSize;
  final EdgeInsets innerPadding;
  final double outerPadding;
  final double iconSize;
}

/// xs: h32, inner 12/8, outer 8, icon sm(16). (fd_button_size.dart:17-35,
/// fd_button_utils.dart:55-58)
const oracleButtonXs = OracleButtonSize(
  fixedSize: 32,
  innerPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  outerPadding: 8,
  iconSize: 16,
);

/// sm: h40, inner 16/10, outer 4, icon md(20). Default size.
/// (fd_button_size.dart, fd_button_utils.dart:60-63)
const oracleButtonSm = OracleButtonSize(
  fixedSize: 40,
  innerPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  outerPadding: 4,
  iconSize: 20,
);

/// md: h56, inner 24/16, outer 0, icon lg(24). (fd_button_utils.dart:64-67)
const oracleButtonMd = OracleButtonSize(
  fixedSize: 56,
  innerPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  outerPadding: 0,
  iconSize: 24,
);

/// Variant color roles (fd_button_utils.dart:16-29). Values are resolved
/// against the ambient ColorScheme by the tests.
///
/// NOTE: production has NO `outline` variant — FDButtonVariant is
/// filled | tonal | text | destructive. flutter_flowin's added `outline`
/// variant is a deviation with no oracle to match.
enum OracleButtonVariantRole { filled, tonal, text, destructive }

/// Disabled state (fd_button.dart:110-112): fg = onSurface @ 0.38,
/// bg = onSurface @ 0.12.
const oracleButtonDisabledFgAlpha = 0.38;
const oracleButtonDisabledBgAlpha = 0.12;

/// Gap between icon and label inside a button row (fd_button.dart:140).
const oracleButtonIconLabelGap = 8.0;

// ---------------------------------------------------------------------------
// FDIconButton — fd_icon_button.dart
// ---------------------------------------------------------------------------

/// The icon button's outer padding is **all-sides**, unlike FDButton's
/// vertical-only wrapper:
///
/// ```dart
/// // fd_icon_button.dart:74  (icon button — all sides)
/// padding: padding ?? EdgeInsets.all(size.padding),
/// // fd_button.dart:129      (regular button — vertical only)
/// padding: padding ?? EdgeInsets.symmetric(vertical: size.padding),
/// ```
///
/// Same `size.padding` source (8 / 4 / 0), different geometry. The two are
/// easy to conflate; they are deliberately different in production.
EdgeInsets oracleIconButtonOuterPadding(double sizePadding) =>
    EdgeInsets.all(sizePadding);

/// Square footprint: both `minimumSize` and `fixedSize` are
/// `size.fixedSize` (fd_icon_button.dart:88-89), so the button is a circle of
/// exactly that side length with zero inner padding.
const EdgeInsets oracleIconButtonInnerPadding = EdgeInsets.zero;

// ---------------------------------------------------------------------------
// FDItemButton — fd_item_button.dart
// ---------------------------------------------------------------------------

/// Uniform content padding (fd_item_button.dart:67).
const oracleItemButtonPadding = EdgeInsets.all(16);

/// minimumSize is Size.fromHeight(md.fixedSize) (build passes md).
const oracleItemButtonMinHeight = 56.0;

/// Corner radius (fd_item_button.dart:65) — radius400.
const oracleItemButtonRadius = 16.0;

/// Icon size in PRODUCTION — 24. `FDItemButton.build` hardcodes the *button*
/// size `FDButtonSize.md` (fd_item_button.dart:42), and the legacy button
/// scale maps that button step to *icon* step `lg`
/// (fd_button_size.dart: `md => FlowinDesignIconSize.lg`), so
/// `iconSize: size.iconSize.value` resolves 24 — not the 20 that
/// `FlowinDesignIconSize.defaultSize` (md) would suggest. Two enums, two
/// different "defaults"; verified by measuring the rendered glyph, not by
/// reading the chain.
const oracleItemButtonIconSize = 24.0;

/// ACCEPTED DEVIATION — row icon size (decided 2026-08-04).
///
/// flutter_flowin ships **20**, not production's [oracleItemButtonIconSize]
/// (24). The v1 contract binds the row icon directly to `{iconSize.md}` so it
/// reads as a leading affordance instead of competing with the `labelLarge`
/// label; production's 24 was a side effect of routing the icon through the
/// *button* size scale rather than a stated design intent.
///
/// This is the first fixture where flutter_flowin is treated as the **source
/// of truth over production**: the design system is the new origin, and the
/// archived package is being deprecated. The oracle constant above is kept
/// deliberately — it records what production renders (an unchangeable
/// historical fact about a frozen tag), so the divergence stays visible
/// rather than being erased.
///
/// Scope is item-button ONLY. The `FlowinButton` per-size icon mapping
/// (xs → 16, sm → 20, md → 24) is unchanged and still asserted against the
/// oracle.
const specItemButtonIconSize = 20.0;

/// Content alignment (fd_item_button.dart:63) and text style (:72).
const Alignment oracleItemButtonAlignment = Alignment.centerLeft;
const oracleItemButtonTextStyleRole = 'labelLarge';

// ---------------------------------------------------------------------------
// FdChip — fd_chip.dart / fd_chip_label.dart
// ---------------------------------------------------------------------------

/// Default content padding: EdgeInsets.all(space400) (fd_chip.dart:103).
const oracleChipPadding = EdgeInsets.all(16);

/// Pill shape: BorderRadius.circular(FlowinDesignRadius.full).
const oracleChipRadius = 9999.0;

/// Dimmed variant opacity (fd_chip.dart FdChipVariant.opacity).
const oracleChipDimmedOpacity = 0.5;

/// PRODUCTION binding (fd_chip.dart:85-92): the unselected chip border is
/// colorScheme.secondaryContainer, NOT outlineVariant. The June-06 spec
/// conformance report (flowin_pm C1) said the opposite — spec says
/// outlineVariant; production ships secondaryContainer. flutter_flowin
/// currently follows the SPEC. This fixture pins PRODUCTION; the fidelity
/// test for it documents the conflict for the manual-validation gate.
const oracleChipUnselectedBorderRole = 'secondaryContainer';

/// Selected chip: bg secondaryContainer, border = bg (fd_chip.dart:81-89).
const oracleChipSelectedBgRole = 'secondaryContainer';

/// Label (fd_chip_label.dart): labelSmall + onSecondaryContainer, with a
/// tight strut (height 1, leading 0) so padding drives chip height.
const oracleChipLabelStrut = StrutStyle(height: 1, leading: 0);

/// Rendered-box contract (decided 2026-08-04): keep composing Material's
/// ChoiceChip rather than hand-rolling production's GestureDetector+Container,
/// and neutralize Material's extras via the theme — `labelPadding` zero
/// (Material defaults to 8/side on top of the content padding) and
/// `materialTapTargetSize: shrinkWrap` (production has no 48pt tap-target
/// inflation).
///
/// Production's box (fd_chip.dart): tight-strut label (= fontSize tall;
/// labelSmall's height factor is already 1.0) + all-space400 padding + a 1px
/// border that Container draws OUTSIDE the padding box, adding 2 per axis.
/// Material paints the chip side inside, so the rendered box may differ by
/// exactly that border geometry — hence the ±2 tolerance below, the one
/// un-neutralizable difference.
///
/// ACCEPTED (documented, not asserted): ChoiceChip keeps its ink ripple —
/// production's GestureDetector has none. Kept deliberately for Material
/// feedback affordances.
const oracleChipBoxTolerance = 2.0;

/// Production chip height for a [labelHeight]-tall label: padding 16×2 +
/// border 1×2.
double oracleChipBoxHeight(double labelHeight) => labelHeight + 32 + 2;

/// Production chip width for a [labelWidth]-wide label: padding 16×2 +
/// border 1×2.
double oracleChipBoxWidth(double labelWidth) => labelWidth + 32 + 2;

// ---------------------------------------------------------------------------
// FDChipGroup / FDChipGroupViewPager — fd_chip_group*.dart
// ---------------------------------------------------------------------------

/// Row height (fd_chip_group.dart:183) — space1200.
const oracleChipGroupHeight = 48.0;

/// Horizontal list padding (fd_chip_group.dart:39-41) — space300.
const oracleChipGroupPadding = EdgeInsets.symmetric(horizontal: 12);

/// Gap between chips (fd_chip_group.dart:42) — space200.
const oracleChipGroupSpacing = 8.0;

/// PRODUCTION's wrapped-row gap — `FdChipGroup`'s non-scrollable branch sets
/// `Wrap.alignment` and `spacing` but never `runSpacing`
/// (fd_chip_group.dart:196-202), so Flutter's default 0 applies and wrapped
/// rows touch vertically.
const oracleChipGroupRunSpacing = 0.0;

/// ACCEPTED DEVIATION — wrapped-row gap (decided 2026-08-04).
///
/// flutter_flowin defaults `chipRunSpacing` to [oracleChipGroupSpacing]
/// instead, so wrapped rows are separated by the same gap that separates chips
/// within a row. Production's 0 was Flutter's default leaking through an unset
/// property, not a stated intent — the same shape of accident as the
/// item-button icon size, and visible as touching rows the moment a chip row
/// wraps.
///
const flowinChipGroupRunSpacing = 8.0;

/// PRODUCTION's wrap alignment (fd_chip_group.dart:198) — explicitly centred.
const WrapAlignment oracleChipGroupWrapAlignment = WrapAlignment.center;

/// ACCEPTED DEVIATION — wrap alignment (decided 2026-08-04).
///
/// flutter_flowin defaults to [WrapAlignment.start]. Centring is a real
/// production choice rather than an unset property, but it leaves a partial
/// last row floating out of line with the full rows above it — visible as soon
/// as a chip row wraps. Leading alignment keeps every row on the same left
/// edge. Callers can pass `wrapAlignment` to restore centring.
const WrapAlignment flowinChipGroupWrapAlignment = WrapAlignment.start;

/// PRODUCTION has no selected-state checkmark: `FdChip` renders its label
/// straight into a `Container` with no leading slot (fd_chip.dart:98-115).
///
/// ACCEPTED DEVIATION — resolved 2026-08-04 by *matching* production.
/// Material's `ChoiceChip` inserts a checkmark on selection by default; the
/// chip theme now sets `showCheckmark: false`. This was Material's own default
/// leaking
/// through an unset property — the same accident shape as the run spacing
/// above — not a deliberate difference.
const oracleChipShowsCheckmark = false;

/// View pager: chips row padding h space300, chip spacing space200,
/// column spacing space300 (fd_chip_group_view_pager.dart:38-41,183).
const oracleViewPagerColumnSpacing = 12.0;

/// Chip-row defaults proxied to the chip group
/// (fd_chip_group_view_pager.dart:38-41).
const oracleViewPagerChipsPadding = EdgeInsets.symmetric(horizontal: 12);
const oracleViewPagerChipSpacing = 8.0;

/// Page-turn animation defaults (fd_chip_group_view_pager.dart:47-49).
const oracleViewPagerAnimateDuration = Duration(milliseconds: 280);
const Curve oracleViewPagerAnimateCurve = Curves.easeOutCubic;

// ---------------------------------------------------------------------------
// FDDivider — fd_divider.dart
// ---------------------------------------------------------------------------

/// Divider height / VerticalDivider width — space50. Color: outlineVariant.
const oracleDividerExtent = 2.0;

// ---------------------------------------------------------------------------
// FDCard — fd_card.dart
// ---------------------------------------------------------------------------

/// Squircle corner smoothing (FlowinDesignRadius.iOSSmooth).
const oracleCardCornerSmoothing = 0.6;

/// Default background role when none is given: secondaryContainer.
const oracleCardDefaultBgRole = 'secondaryContainer';

// ---------------------------------------------------------------------------
// FDTabs / FDTabItem — fd_tabs.dart / fd_tab_item.dart
// ---------------------------------------------------------------------------

/// Default tab item height (fd_tabs.dart:5) — space1400.
const oracleTabItemHeight = 56.0;

/// Icon-to-label gap inside a tab item (fd_tab_item.dart SizedBox(width: 4)).
const oracleTabItemIconGap = 4.0;

/// Tab label style (fd_tab_item.dart): 14 / w500, ellipsized, single line.
const oracleTabLabelFontSize = 14.0;
const FontWeight oracleTabLabelFontWeight = FontWeight.w500;

/// ACCEPTED DEVIATION — tab labelPadding (decided 2026-08-04).
///
/// Neither production nor the spec sets `labelPadding`, so Material's
/// `kTabLabelPadding` (16 per side, constants.dart:54) applies and fixed-width
/// icon+label tabs ellipsize even mundane labels: on a 440pt screen, 3 tabs
/// leave 328/3 − 32 (label padding) − 28 (icon 24 + gap 4) = 49.3pt per
/// label — "Settings" clamps to "Setti…". Production ships the same
/// behaviour, so this was a product call, not a fidelity fix.
///
/// flutter_flowin deliberately tightens the theme's `labelPadding` to
/// space100 (4) per side, recovering 24pt per tab so typical labels fit.
const oracleTabLabelPaddingPerSide = 16.0; // production's effective value
const flowinTabLabelPaddingPerSide = 4.0; // the chosen deviation

/// ACCEPTED DEVIATION — per-item style injection (decided 2026-08-04).
///
/// Production's `FDTabs` REBUILDS each `FDTabItem` at the call site to inject
/// the bar height and hardcode the 14/w500 label style (fd_tabs.dart).
/// `FlowinTabs` is instead a thin, theme-driven `TabBar` composition: the tab
/// widgets pass through unchanged and the label style comes from
/// `tabBarTheme`.
///
/// This comment used to claim `labelMedium = 14/w500`, so the rendered result
/// "matched the oracle". That was false — `labelMedium` is 14/**w600** — and
/// the claim is why the divergence went unnoticed: the item hardcoded w500,
/// which outranked the theme, so a Flowin cell rendered w500 while a raw
/// `Tab` in the same bar rendered w600.
///
/// Resolved 2026-08-06 in favour of the type scale: the item no longer sets a
/// style, so every cell in the bar renders `labelMedium` (w600). See
/// [specTabLabelFontWeight].
const oracleTabsRebuildTheirItems = true;

/// ACCEPTED DEVIATION — tab label weight (decided 2026-08-06).
///
/// Production renders the tab label at [oracleTabLabelFontWeight] (w500) by
/// hardcoding it per item. v1 binds the label to the type scale instead, so
/// the weight reaches it through `tabBarTheme` and a Flowin cell and a raw
/// platform cell in the same bar agree. That makes the shipped weight w600.
const FontWeight specTabLabelFontWeight = FontWeight.w600;

// ---------------------------------------------------------------------------
// FDAppBar / FDTabAppBar — fd_app_bar.dart / fd_tab_app_bar.dart
// ---------------------------------------------------------------------------

/// Bar max height (space1400); leading/trailing square min (space1200);
/// top/left/right padding (space200). (fd_app_bar.dart:4-11)
const oracleAppBarHeight = 56.0;
const oracleAppBarContentMin = 48.0;
const oracleAppBarPadding = 8.0;

/// TabAppBar footer divider: height == thickness == borders.regular (1),
/// color outlineVariant (fd_tab_app_bar.dart:33-42).
const oracleTabAppBarDividerThickness = 1.0;

/// ACCEPTED DEVIATION — status-bar inset (decided 2026-08-03).
///
/// Production's `FDAppBar` is a plain `Container` (not a
/// `PreferredSizeWidget`) with no status-bar inset. Volleyboard therefore
/// places it in `Scaffold.body` as the first child of a `Column` wrapped in
/// the app's own `SafeArea` — the *app* owns the inset.
///
/// `flutter_flowin` deliberately adopts **Material's** contract instead:
/// `FlowinAppBar` implements `PreferredSizeWidget`, goes in `Scaffold.appBar`,
/// and owns its own inset via `primary` (default true), exactly as
/// `AppBar` does (`app_bar.dart`: `if (widget.primary) appBar = SafeArea(...)`)
/// and `CupertinoNavigationBar`. Rationale: follow the framework convention
/// rather than reinvent it; `primary: false` restores production's behavior
/// for bars nested in an already-inset body.
///
/// `preferredSize` intentionally stays [oracleAppBarHeight] — `Scaffold` adds
/// `MediaQuery.padding.top` itself for any `PreferredSizeWidget`, so counting
/// it in the widget would double-pad.
///
/// Consequence tracked for adoption: volleyboard's two body-nested layouts
/// must move to `Scaffold.appBar` (or pass `primary: false`) when it migrates
/// off `flowin_design`.
const oracleAppBarOwnsStatusBarInset = false;

// ---------------------------------------------------------------------------
// FDInputField / FDTextField — fd_input_field*.dart / fd_text_field.dart
// ---------------------------------------------------------------------------

/// Container: FDCard radius400 squircle, height space1600, content max
/// height space1000, padding v space300 / h space400, transparent bg,
/// border outlineVariant. (fd_input_field.dart:40-67,
/// fd_input_field_constants.dart)
const oracleInputFieldHeight = 64.0;
const oracleInputFieldContentMaxHeight = 40.0;
const oracleInputFieldRadius = 16.0;
const oracleInputFieldPadding = EdgeInsets.symmetric(
  vertical: 12,
  horizontal: 16,
);

/// Stacked label: 4px horizontal inset, space200 gap to the container,
/// labelMedium + onSurface, ellipsized. (fd_input_field.dart:20-33)
const oracleInputFieldLabelInset = 4.0;
const oracleInputFieldLabelGap = 8.0;

/// NAME MAPPING — production `FDInputField` is the *stacked* labelled field,
/// so its counterpart is `FlowinLabeledTextField`, NOT `FlowinInputField`.
///
/// The v1 spec splits the legacy component in two:
///
/// * **labeled-text-field** (stacked, label above) — the production layout,
///   implemented by `FlowinLabeledTextField`. Its own contract records the
///   split: *"the legacy reference bundled the label as a leading sidebar …
///   v1 deliberately adopts a stacked (label-above) layout … The sidebar look
///   is not carried forward."*
/// * **input-field** (sidebar: fixed-width label column · divider · expanding
///   child) — a NEW layout primitive with no production predecessor,
///   implemented by `FlowinInputField`.
///
/// So this is one component renamed plus one component added — not the same
/// component built two different ways. Comparing `FDInputField` against
/// `FlowinInputField` by name is the mistake; the pairings below are correct.
///
/// Label→field gap in the stacked layout, matching production's
/// `spacing: space200` (fd_input_field.dart:24).
const oracleLabeledTextFieldGap = 8.0;

/// SPEC-ONLY (no production oracle) — the stacked input-field primitive.
///
/// These come from the v1 contract `design/components/input-field.md`
/// ("Sizes"), not from `flowin_design`. Production's `FDInputField` is the
/// *stacked labelled text field* and maps to `FlowinLabeledTextField`; the
/// generic arbitrary-child primitive has no production predecessor.
const specInputFieldSurfaceMinHeight = 64.0; // {space.1600}
const specInputFieldContentRowHeight = 40.0; // {space.1000}
const specInputFieldLabelGap = 8.0; // {space.200}
const specInputFieldInnerPadding = EdgeInsets.symmetric(
  horizontal: 16, // {space.400}
  vertical: 12, // {space.300}
);

/// ACCEPTED DEVIATION — the sidebar arrangement is retired (decided
/// 2026-08-04, flowin_pm#11).
///
/// `FlowinInputField` previously matched production's `FDInputField` layout: a
/// fixed-width label column ({space.1400}) beside a vertical divider, with the
/// child expanding alongside it and a {space.250} row gap. The sidebar is now
/// removed from the design system entirely — stacked (label-above) is the only
/// labelled-field shape — so those measures and the divider binding are gone
/// from the contract and from this fixture set.
///
/// The legacy package still ships the sidebar; apps migrating onto
/// flutter_flowin drop it as part of adoption. The oracle is unaffected: it
/// records what production renders, which does not change.
const specInputFieldSidebarRetired = true;

/// FDTextField hint: bodyLarge + onSurfaceVariant, collapsed decoration,
/// maxLines 1. (fd_text_field.dart:48-63)
const oracleTextFieldMaxLines = 1;

// ---------------------------------------------------------------------------
// FDActionSheet — fd_action_sheet.dart / _utils / widgets
// ---------------------------------------------------------------------------

/// Sheet card: margin t32/b24/lr16, bg surface, radius1000 squircle,
/// bottom padding 24, column spacing 16. (fd_action_sheet.dart:51-68)
const oracleSheetMargin = EdgeInsets.only(
  top: 32,
  bottom: 24,
  left: 16,
  right: 16,
);
const oracleSheetRadius = 40.0;
const oracleSheetBottomPadding = 24.0;
const oracleSheetColumnSpacing = 16.0;

/// Header/body/footer horizontal inset — space600. (fd_action_sheet.dart)
const oracleSheetContentInset = 24.0;

/// Footer row gap — space300. (fd_action_sheet_footer.dart:24)
const oracleSheetFooterSpacing = 12.0;

/// Close button: FDIconButton.tonal at xs (32) with an sm (16) icon.
/// (fd_action_sheet_header.dart:52-58)
const oracleSheetCloseButtonSize = 32.0;
const oracleSheetCloseIconSize = 16.0;

/// Modal defaults: transparent barrier-sheet background, maxWidth 480 on
/// wide viewports. (fd_action_sheet_utils.dart:17-46)
const oracleSheetMaxWidth = 480.0;

// ---------------------------------------------------------------------------
// FDColorRadialButton / FDColorPickerField
// ---------------------------------------------------------------------------

/// Default radial button size — space700. (fd_color_radial_button.dart:9)
const oracleColorRadialSize = 28.0;

/// Selected-ring geometry: ring width borders.extraBold (3), gap width
/// borders.bold (2), gap color defaults to `surface`.
/// (fd_color_radial_button.dart:11-13)
const oracleColorRadialBorderWidth = 3.0;
const oracleColorRadialGapWidth = 2.0;

/// Picker row: height space1000, item gap space400.
/// (fd_color_picker_field.dart:151-161)
const oracleColorPickerRowHeight = 40.0;
const oracleColorPickerRowSpacing = 16.0;

/// Predefined swatches carry a hairline shadow ring so they stay visible on
/// same-colored surfaces: shadow10 = neutral200 @ spreadRadius 1 in light
/// themes, outlineVariant in dark (fd_color_picker_field.dart:146-149,
/// production shadows.dart:10-21). The gradient (custom) swatch has no shadow.
///
/// ACCEPTED DEVIATION — swatch ORDER (corrected 2026-08-04).
///
/// The archived package renders the custom gradient swatch **leading**
/// (fd_color_picker_field.dart:157-183). The shipping product trails with it
/// instead — presets first, custom pinned to the trailing edge — and the v1
/// contract now states that, so flutter_flowin follows the contract.
///
/// An earlier revision of this comment had both halves backwards (it claimed
/// production trailed and the spec led). The archive was read correctly the
/// first time and mis-transcribed here; the order shipped in flutter_flowin
/// was never wrong.
const oracleSwatchShadowSpread = 1.0;
