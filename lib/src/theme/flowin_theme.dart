import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';
import 'package:flutter_flowin/src/theme/flowin_tokens.dart';

/// {@template flowin_theme}
/// Builds the Flowin [ThemeData] for light and dark.
///
/// The design philosophy: lean on the Flutter framework. Colors map onto
/// [ColorScheme], typography onto [TextTheme], and component appearance onto
/// the relevant component themes ([FilledButtonThemeData], [ChipThemeData],
/// [DividerThemeData], …). Non-Material tokens live in the [FlowinTokens]
/// extension. The result is that native widgets — and the thin Flowin widgets
/// that compose them — are styled entirely by the theme, with no per-instance
/// styling.
/// {@endtemplate}
class FlowinTheme {
  /// {@macro flowin_theme}
  // Unreachable private constructor — this is a static-only utility class that
  // is never instantiated.
  const FlowinTheme._(); // coverage:ignore-line

  /// The light [ThemeData].
  static ThemeData get light =>
      _build(FlowinDesignSchemes.light, const FlowinTokens.light());

  /// The dark [ThemeData].
  static ThemeData get dark =>
      _build(FlowinDesignSchemes.dark, const FlowinTokens.dark());

  static ThemeData _build(ColorScheme colorScheme, FlowinTokens tokens) {
    // Initializes the icon library here rather than leaving it to the first
    // FDIcon.build. On web in debug (DDC), linking it from inside a deep
    // widget build exhausts the JS stack — see [FDIcons.warmUp]. A theme is
    // always built before any icon renders, and at a far shallower stack, so
    // this makes consuming apps immune without requiring a main() call.
    FDIcons.warmUp();

    final textTheme = FlowinTypefaces.baseline().apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    // Flowin buttons are pill-shaped: the corner radius always resolves to
    // half the button's height, so the ends stay perfectly semicircular at
    // every size. A fixed radius cannot do that — radius400 (16) read as a
    // rounded rectangle on anything taller than 32.
    //
    // Left to Material's own default rather than set here, because that
    // default IS StadiumBorder, and the legacy package set no shape either —
    // so inheriting it is what production actually rendered.
    // FlowinItemButton is the exception: it pins radius400 on its own
    // ButtonStyle, because a full-width row reads as a surface, not a pill.
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: FlowinDesignSpace.space400,
      vertical: FlowinDesignSpace.space300,
    );
    final buttonTextStyle = textTheme.labelLarge;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      extensions: [tokens],

      // --- Component themes: encode what the legacy FD* widgets did
      // per-instance, so native widgets inherit Flowin styling. ---
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: buttonPadding,
          textStyle: buttonTextStyle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: buttonPadding,
          textStyle: buttonTextStyle,
          foregroundColor: colorScheme.onSurface,
          // FlowinDesignBorders.regular (1.0) is BorderSide's default width.
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: buttonPadding,
          textStyle: buttonTextStyle,
          // Stated rather than inherited, matching the outlined sibling.
          // Material defaults this to `primary`, which currently resolves to
          // the same value as `onSurface`, so leaving it unset renders
          // correctly today and diverges once the brand accent is chromatic.
          // FlowinIconButton's text variant binds `primary` deliberately.
          foregroundColor: colorScheme.onSurface,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: FlowinDesignBorders.regular,
        space: FlowinDesignSpace.space50,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: colorScheme.secondaryContainer,
        // Unselected border binds to the subtle-border role
        // (spec: borderSubtle).
        side: BorderSide(color: colorScheme.outlineVariant),
        // Production (fd_chip_label.dart) renders the label in labelSmall +
        // onSecondaryContainer in every state.
        labelStyle: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        secondaryLabelStyle: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        shape: const StadiumBorder(),
        // Production chip content padding is uniform space400.
        padding: const EdgeInsets.all(FlowinDesignSpace.space400),
        // Production has no extra label padding — Material would add 8 per
        // side on top of the content padding. See oracleChipBoxTolerance.
        labelPadding: EdgeInsets.zero,
        // Production's chip is a bare Container with no leading slot, so a
        // selected chip shows no checkmark; Material would insert one.
        showCheckmark: false,
      ),
      tabBarTheme: TabBarThemeData(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelMedium,
        // Deliberately tighter than Material's kTabLabelPadding (16 per
        // side), which clamps icon+label tabs so hard that mundane labels
        // ellipsize in fixed-width bars. See flowinTabLabelPaddingPerSide.
        labelPadding: const EdgeInsets.symmetric(
          horizontal: FlowinDesignSpace.space100,
        ),
        // tabAlignment is set per-instance by FlowinTabs rather than here:
        // `start` is only valid on a scrollable bar and asserts on a fixed
        // one, so it cannot be a single theme-level value.
      ),
      cardTheme: CardThemeData(
        color: colorScheme.secondaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FlowinDesignRadius.radius400),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FlowinDesignSpace.space400,
          vertical: FlowinDesignSpace.space300,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FlowinDesignRadius.radius400),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FlowinDesignRadius.radius400),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        // Stated rather than left to Material, which would tint the border
        // with its own disabled colour. The border role is unchanged when
        // disabled: a disabled field still reads as a field.
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FlowinDesignRadius.radius400),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FlowinDesignRadius.radius1000),
          ),
        ),
      ),
    );
  }
}
