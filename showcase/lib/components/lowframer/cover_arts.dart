import 'package:flowin_showcase/components/lowframer/lowframer.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// The Buttons card art: a stack of pill silhouettes, one accented.
class ButtonsCoverArt extends StatelessWidget {
  /// {@macro buttons_cover_art}
  const ButtonsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          LowframerBox.pill(color: palette.accent, width: 72, height: 16),
          LowframerBox.pill(color: palette.fill, width: 96, height: 16),
          LowframerBox.pill(
            color: palette.background,
            borderColor: palette.fillStrong,
            width: 56,
            height: 16,
          ),
        ],
      ),
    );
  }
}

/// The Chips card art: two wrapped rows of chip silhouettes, one accented.
class ChipsCoverArt extends StatelessWidget {
  /// {@macro chips_cover_art}
  const ChipsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(color: palette.accent, width: 40),
              LowframerBox.pill(color: palette.fill, width: 52),
            ],
          ),
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(color: palette.fill, width: 56),
              LowframerBox.pill(color: palette.fill, width: 36),
            ],
          ),
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(color: palette.fill, width: 44),
              LowframerBox.pill(color: palette.fill, width: 60),
            ],
          ),
        ],
      ),
    );
  }
}

/// The Icon buttons card art: a row of circles, one accented.
class IconButtonsCoverArt extends StatelessWidget {
  /// {@macro icon_buttons_cover_art}
  const IconButtonsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          LowframerBox.pill(color: palette.accent, width: 22, height: 22),
          LowframerBox.pill(color: palette.fill, width: 22, height: 22),
          LowframerBox.pill(
            color: palette.background,
            borderColor: palette.fillStrong,
            width: 22,
            height: 22,
          ),
          LowframerBox.pill(color: palette.fill, width: 22, height: 22),
        ],
      ),
    );
  }
}

/// The Item buttons card art: full-width stacked rows, one accented.
class ItemButtonsCoverArt extends StatelessWidget {
  /// {@macro item_buttons_cover_art}
  const ItemButtonsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [
          LowframerBox(color: palette.accent, height: 18, radius: 5),
          LowframerBox(color: palette.fill, height: 18, radius: 5),
          LowframerBox(color: palette.fill, height: 18, radius: 5),
        ],
      ),
    );
  }
}

/// The Chip groups card art: one chip row running off the frame's edge.
class ChipGroupsCoverArt extends StatelessWidget {
  /// {@macro chip_groups_cover_art}
  const ChipGroupsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          LowframerBox.line(color: palette.fillStrong, width: 28),
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(color: palette.accent, width: 40),
              LowframerBox.pill(color: palette.fill, width: 48),
              // Runs to the frame's edge: the group scrolls, and a clipped
              // last chip is the wireframe shorthand for that.
              Expanded(
                child: LowframerBox.pill(
                  color: palette.fill,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The Chip view pagers card art: a chip row over a page with dots below.
class ChipPagersCoverArt extends StatelessWidget {
  /// {@macro chip_pagers_cover_art}
  const ChipPagersCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 7,
        children: [
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(color: palette.accent, width: 36),
              LowframerBox.pill(color: palette.fill, width: 36),
            ],
          ),
          Expanded(
            child: LowframerBox(
              color: palette.fill,
              height: double.infinity,
              radius: 5,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              LowframerBox.pill(color: palette.fillStrong, width: 5, height: 5),
              LowframerBox.pill(color: palette.fill, width: 5, height: 5),
              LowframerBox.pill(color: palette.fill, width: 5, height: 5),
            ],
          ),
        ],
      ),
    );
  }
}

/// The Input fields card art: a label over one large bordered surface.
class InputFieldsCoverArt extends StatelessWidget {
  /// {@macro input_fields_cover_art}
  const InputFieldsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [
          LowframerBox.line(color: palette.fillStrong, width: 34),
          LowframerBox(
            color: palette.background,
            borderColor: palette.accent,
            height: 52,
            radius: 6,
          ),
        ],
      ),
    );
  }
}

/// The Colour swatches card art: a swatch grid with one selected.
class SwatchesCoverArt extends StatelessWidget {
  /// {@macro swatches_cover_art}
  const SwatchesCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget swatch({bool accent = false, bool outlined = false}) => LowframerBox(
      color: accent ? palette.accent : palette.fill,
      borderColor: outlined ? palette.fillStrong : null,
      width: 20,
      height: 20,
      radius: 5,
    );

    return LowframerWindow(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              swatch(accent: true),
              swatch(),
              swatch(),
              swatch(outlined: true),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [swatch(), swatch(outlined: true), swatch(), swatch()],
          ),
        ],
      ),
    );
  }
}

/// The Cards & surfaces card art: a filled and an outlined surface, side
/// by side, each with its caption line.
class CardsCoverArt extends StatelessWidget {
  /// {@macro cards_cover_art}
  const CardsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                LowframerBox(color: palette.fill, height: 46, radius: 6),
                LowframerBox.line(color: palette.fillStrong, width: 30),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                LowframerBox(
                  color: palette.background,
                  borderColor: palette.fillStrong,
                  height: 46,
                  radius: 6,
                ),
                LowframerBox.line(color: palette.fill, width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The Dividers card art: content lines separated by hairline rules.
class DividersCoverArt extends StatelessWidget {
  /// {@macro dividers_cover_art}
  const DividersCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          LowframerBox.line(color: palette.fill, width: 64),
          LowframerBox(color: palette.fillStrong, height: 1, radius: 0),
          LowframerBox.line(color: palette.fill, width: 48),
          LowframerBox(color: palette.accent, height: 1.5, radius: 0),
          LowframerBox.line(color: palette.fill, width: 56),
        ],
      ),
    );
  }
}

/// The App bars card art: leading and trailing controls around a title,
/// over quiet page content.
class AppBarsCoverArt extends StatelessWidget {
  /// {@macro app_bars_cover_art}
  const AppBarsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              LowframerBox.pill(color: palette.accent, width: 12),
              const Spacer(),
              LowframerBox.line(color: palette.fillStrong, width: 40),
              const Spacer(),
              LowframerBox.pill(color: palette.fill, width: 12),
            ],
          ),
          LowframerBox(color: palette.fillStrong, height: 1, radius: 0),
          LowframerBox.line(color: palette.fill, width: 90),
          LowframerBox.line(color: palette.fill, width: 70),
        ],
      ),
    );
  }
}

/// The Tabs card art: labels with an accent underline, over page content.
class TabsCoverArt extends StatelessWidget {
  /// {@macro tabs_cover_art}
  const TabsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            spacing: 12,
            children: [
              Column(
                spacing: 4,
                children: [
                  LowframerBox.line(color: palette.fillStrong, width: 30),
                  LowframerBox(
                    color: palette.accent,
                    width: 30,
                    height: 2,
                    radius: 1,
                  ),
                ],
              ),
              LowframerBox.line(color: palette.fill, width: 30),
              LowframerBox.line(color: palette.fill, width: 30),
            ],
          ),
          const SizedBox(height: 2),
          Expanded(
            child: LowframerBox(
              color: palette.fill,
              height: double.infinity,
              radius: 5,
            ),
          ),
        ],
      ),
    );
  }
}

/// The Action sheets card art: a sheet rising over dimmed page content,
/// grab handle on top.
class SheetsCoverArt extends StatelessWidget {
  /// {@macro sheets_cover_art}
  const SheetsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        children: [
          LowframerBox.line(color: palette.fill, width: 80),
          const Spacer(),
          LowframerBox(
            color: palette.background,
            borderColor: palette.fillStrong,
            height: 62,
            radius: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                LowframerBox.pill(
                  color: palette.fillStrong,
                  width: 20,
                  height: 3,
                ),
                LowframerBox.line(color: palette.fill, width: 60),
                LowframerBox.pill(color: palette.accent, width: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The Text fields card art: label lines over field boxes, one focused.
class TextFieldsCoverArt extends StatelessWidget {
  /// {@macro text_fields_cover_art}
  const TextFieldsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          LowframerBox.line(color: palette.fillStrong, width: 28),
          LowframerBox(
            color: palette.background,
            borderColor: palette.accent,
            height: 18,
            radius: 4,
          ),
          const SizedBox(height: 2),
          LowframerBox.line(color: palette.fillStrong, width: 40),
          LowframerBox(color: palette.fill, height: 18, radius: 4),
        ],
      ),
    );
  }
}

/// The Typography card art: the type scale as lines of falling weight.
class TypographyCoverArt extends StatelessWidget {
  /// {@macro typography_cover_art}
  const TypographyCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [
          LowframerBox(color: palette.accent, width: 64, height: 10, radius: 3),
          LowframerBox(color: palette.fillStrong, width: 88, height: 6),
          LowframerBox.line(color: palette.fill, width: 110),
          LowframerBox.line(color: palette.fill, width: 96),
        ],
      ),
    );
  }
}

/// The Colors card art: large role tiles, one accented, one outlined.
class ColorsCoverArt extends StatelessWidget {
  /// {@macro colors_cover_art}
  const ColorsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget tile({bool accent = false, bool outlined = false}) => Expanded(
      child: LowframerBox(
        color: accent
            ? palette.accent
            : outlined
            ? palette.background
            : palette.fill,
        borderColor: outlined ? palette.fillStrong : null,
        height: double.infinity,
        radius: 5,
      ),
    );

    return LowframerWindow(
      child: Column(
        spacing: 6,
        children: [
          Expanded(
            child: Row(
              spacing: 6,
              children: [tile(accent: true), tile(), tile()],
            ),
          ),
          Expanded(
            child: Row(
              spacing: 6,
              children: [tile(), tile(outlined: true), tile()],
            ),
          ),
        ],
      ),
    );
  }
}

/// The Spacing card art: a staircase of lines, each one step further in.
class SpacingCoverArt extends StatelessWidget {
  /// {@macro spacing_cover_art}
  const SpacingCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget step(double indent, {bool accent = false}) => Padding(
      padding: EdgeInsets.only(left: indent),
      child: LowframerBox(
        color: accent ? palette.accent : palette.fill,
        width: 56,
        height: 8,
        radius: 3,
      ),
    );

    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [step(0, accent: true), step(16), step(36), step(64)],
      ),
    );
  }
}

/// The Radius card art: the same square at each step of the corner scale.
class RadiusCoverArt extends StatelessWidget {
  /// {@macro radius_cover_art}
  const RadiusCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget corner(double radius, {bool accent = false}) => LowframerBox(
      color: accent ? palette.accent : palette.fill,
      width: 34,
      height: 34,
      radius: radius,
    );

    return LowframerWindow(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [corner(2), corner(8), corner(999, accent: true)],
      ),
    );
  }
}

/// The Icons card art: a glyph grid, one accented.
class IconsCoverArt extends StatelessWidget {
  /// {@macro icons_cover_art}
  const IconsCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);

    Widget glyph({bool accent = false}) => LowframerBox.pill(
      color: accent ? palette.accent : palette.fill,
      width: 14,
      height: 14,
    );

    Widget row(List<Widget> glyphs) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: glyphs,
    );

    return LowframerWindow(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          row([glyph(), glyph(), glyph(), glyph()]),
          row([glyph(), glyph(accent: true), glyph(), glyph()]),
          row([glyph(), glyph(), glyph(), glyph()]),
        ],
      ),
    );
  }
}

/// The Create profile example art: an avatar and fields feeding a submit.
class ProfileExampleCoverArt extends StatelessWidget {
  /// {@macro profile_example_cover_art}
  const ProfileExampleCoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = LowframerPalette.of(context);
    return LowframerWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            spacing: 6,
            children: [
              LowframerBox.pill(
                color: palette.fillStrong,
                width: 18,
                height: 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  LowframerBox.line(color: palette.fillStrong, width: 44),
                  LowframerBox.line(color: palette.fill, width: 30),
                ],
              ),
            ],
          ),
          const Spacer(),
          LowframerBox(color: palette.fill, height: 14, radius: 4),
          LowframerBox(color: palette.fill, height: 14, radius: 4),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: LowframerBox.pill(color: palette.accent, width: 48),
          ),
        ],
      ),
    );
  }
}
