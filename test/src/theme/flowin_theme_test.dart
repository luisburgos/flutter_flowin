import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  // Theme tests use testWidgets so they run inside the framework's guarded
  // zone, which tolerates google_fonts' benign async asset load. Runtime font
  // fetching is disabled globally in test/flutter_test_config.dart.
  group('FlowinTheme', () {
    group('light', () {
      testWidgets('returns a Material 3 ThemeData', (tester) async {
        expect(FlowinTheme.light, isA<ThemeData>());
        expect(FlowinTheme.light.useMaterial3, isTrue);
      });

      testWidgets('uses the light color scheme', (tester) async {
        expect(FlowinTheme.light.colorScheme.brightness, Brightness.light);
      });

      testWidgets('registers the FlowinTokens extension', (tester) async {
        expect(FlowinTheme.light.extension<FlowinTokens>(), isNotNull);
      });

      testWidgets('configures component themes (not per-instance styling)', (
        tester,
      ) async {
        final theme = FlowinTheme.light;
        expect(theme.filledButtonTheme.style, isNotNull);
        expect(theme.outlinedButtonTheme.style, isNotNull);
        expect(theme.textButtonTheme.style, isNotNull);
        expect(theme.dividerTheme.color, isNotNull);
        expect(theme.chipTheme, isNotNull);
        expect(theme.tabBarTheme, isNotNull);
      });

      testWidgets('applies a text theme', (tester) async {
        expect(FlowinTheme.light.textTheme.labelLarge, isNotNull);
      });
    });

    group('dark', () {
      testWidgets('returns a Material 3 ThemeData', (tester) async {
        expect(FlowinTheme.dark, isA<ThemeData>());
        expect(FlowinTheme.dark.useMaterial3, isTrue);
      });

      testWidgets('uses the dark color scheme', (tester) async {
        expect(FlowinTheme.dark.colorScheme.brightness, Brightness.dark);
      });

      testWidgets('registers the FlowinTokens extension', (tester) async {
        expect(FlowinTheme.dark.extension<FlowinTokens>(), isNotNull);
      });

      testWidgets('dark semantic colors differ from light', (tester) async {
        final light = FlowinTheme.light.extension<FlowinTokens>()!;
        final dark = FlowinTheme.dark.extension<FlowinTokens>()!;
        expect(
          light.semanticColors.success,
          isNot(dark.semanticColors.success),
        );
      });
    });

    group('component themes (light)', () {
      late ThemeData theme;
      late ColorScheme scheme;

      setUp(() {
        theme = FlowinTheme.light;
        scheme = theme.colorScheme;
      });

      testWidgets('scaffold background binds to the surface role', (
        tester,
      ) async {
        expect(theme.scaffoldBackgroundColor, scheme.surface);
      });

      testWidgets('text theme is recolored onto the onSurface role', (
        tester,
      ) async {
        expect(theme.textTheme.bodyLarge?.color, scheme.onSurface);
        expect(theme.textTheme.displayLarge?.color, scheme.onSurface);
      });

      testWidgets('outlined button binds foreground and side to roles', (
        tester,
      ) async {
        final style = theme.outlinedButtonTheme.style!;
        final foreground = style.foregroundColor?.resolve({});
        final side = style.side?.resolve({});
        expect(foreground, scheme.onSurface);
        expect(side?.color, scheme.outlineVariant);
      });

      testWidgets('text button binds its foreground to the on-surface role', (
        tester,
      ) async {
        // Left unbound, Material defaults this to `primary`. Under the
        // placeholder greys `primary` and `onSurface` are the same value, so
        // the omission rendered correctly and was invisible — until a
        // chromatic brand accent lands, at which point every text button
        // would turn accent-coloured at once.
        //
        // The text ICON button deliberately does bind `primary`; see its
        // contract. This asserts only the text button.
        expect(
          theme.textButtonTheme.style!.foregroundColor?.resolve({}),
          scheme.onSurface,
        );
      });

      testWidgets('icon button uses a circle border', (tester) async {
        final shape = theme.iconButtonTheme.style!.shape?.resolve({});
        expect(shape, isA<CircleBorder>());
      });

      testWidgets('divider binds color and thickness to tokens', (
        tester,
      ) async {
        expect(theme.dividerTheme.color, scheme.outlineVariant);
        expect(theme.dividerTheme.thickness, FlowinDesignBorders.regular);
        expect(theme.dividerTheme.space, FlowinDesignSpace.space50);
      });

      testWidgets('chip binds selected/unselected roles', (tester) async {
        final chip = theme.chipTheme;
        expect(chip.backgroundColor, Colors.transparent);
        expect(chip.selectedColor, scheme.secondaryContainer);
        expect(chip.side?.color, scheme.outlineVariant);
        expect(chip.labelStyle?.color, scheme.onSurface);
        expect(chip.secondaryLabelStyle?.color, scheme.onSecondaryContainer);
        expect(chip.shape, isA<StadiumBorder>());
      });

      testWidgets('tab bar hides its divider and styles labels', (
        tester,
      ) async {
        final tabBar = theme.tabBarTheme;
        final labelMedium = theme.textTheme.labelMedium;
        expect(tabBar.indicatorSize, TabBarIndicatorSize.tab);
        expect(tabBar.dividerColor, Colors.transparent);
        expect(tabBar.labelStyle?.fontSize, labelMedium?.fontSize);
        expect(tabBar.labelStyle?.color, labelMedium?.color);
        expect(
          tabBar.unselectedLabelStyle?.fontSize,
          labelMedium?.fontSize,
        );
        expect(tabBar.unselectedLabelStyle?.color, labelMedium?.color);
      });

      testWidgets('card binds color to the secondary-container role', (
        tester,
      ) async {
        expect(theme.cardTheme.color, scheme.secondaryContainer);
        expect(theme.cardTheme.elevation, 0);
        expect(theme.cardTheme.shape, isA<RoundedRectangleBorder>());
      });

      testWidgets('input decoration binds fill and borders to roles', (
        tester,
      ) async {
        final input = theme.inputDecorationTheme;
        expect(input.filled, isTrue);
        expect(input.fillColor, scheme.surface);
        expect(input.hintStyle?.color, scheme.onSurfaceVariant);
        final border = input.border! as OutlineInputBorder;
        expect(border.borderSide.color, scheme.outlineVariant);
        final enabled = input.enabledBorder! as OutlineInputBorder;
        expect(enabled.borderSide.color, scheme.outlineVariant);
      });

      testWidgets('bottom sheet binds background to the surface role', (
        tester,
      ) async {
        expect(theme.bottomSheetTheme.backgroundColor, scheme.surface);
        expect(theme.bottomSheetTheme.shape, isA<RoundedRectangleBorder>());
      });
    });

    group('applied to a widget tree', () {
      testWidgets('native widgets inherit Flowin styling', (tester) async {
        await tester.pumpApp(
          const Column(
            children: [
              FilledButton(onPressed: null, child: Text('filled')),
              OutlinedButton(onPressed: null, child: Text('outlined')),
              TextButton(onPressed: null, child: Text('text')),
              Divider(),
            ],
          ),
        );

        expect(find.text('filled'), findsOneWidget);
        expect(find.text('outlined'), findsOneWidget);
        expect(find.text('text'), findsOneWidget);
        expect(find.byType(Divider), findsOneWidget);
      });

      testWidgets('honours an explicit dark theme override', (tester) async {
        await tester.pumpApp(
          const SizedBox.shrink(),
          theme: FlowinTheme.dark,
        );

        final context = tester.element(find.byType(SizedBox));
        expect(Theme.of(context).colorScheme.brightness, Brightness.dark);
      });

      testWidgets('binds the shadow role to the base shadow colour', (
        tester,
      ) async {
        // The scheme's shadow role and the shadow actually rendered from the
        // FlowinTokens extension must agree. They drifted once: the role said
        // neutral700 while the rendered shadow said black, and nothing caught
        // it because no widget reads colorScheme.shadow — so the wrong value
        // sat dormant, waiting for the first consumer to reach for the
        // idiomatic Material path.
        expect(
          FlowinTheme.dark.colorScheme.shadow,
          FlowinDesignShadows.shadow100Dark.color,
        );
        expect(
          FlowinTheme.light.colorScheme.shadow,
          FlowinDesignShadows.shadow100.color,
        );
      });
    });
  });
}
