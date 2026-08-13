// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FlowinIconButton', () {
    testWidgets('renders its icon', (tester) async {
      await tester.pumpApp(
        FlowinIconButton(onPressed: () {}, icon: Icon(Icons.add)),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        FlowinIconButton(
          onPressed: () => tapped = true,
          icon: Icon(Icons.add),
        ),
      );
      await tester.tap(find.byType(FlowinIconButton));
      expect(tapped, isTrue);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpApp(
        FlowinIconButton(onPressed: null, icon: Icon(Icons.add)),
      );
      final button = tester.widget<IconButton>(find.byType(IconButton));
      expect(button.onPressed, isNull);
    });

    group('every variant stays legible in both brightnesses', () {
      // The `variant maps to the right color roles` group below asserts WHICH
      // role each variant uses. That stays green when the pairing itself is
      // unreadable, because a role is still that role whatever it resolves to.
      // These assert the property the roles exist to deliver.
      //
      // One case per testWidgets, never a loop inside one. A loop that
      // re-pumps within a single test body reads a partly-stale tree, which
      // manufactured a contrast failure that does not occur at runtime — see
      // flowin_pm#19, closed as a false alarm.
      final opaqueVariants = <String, FlowinIconButton Function()>{
        'filled': () =>
            FlowinIconButton(onPressed: () {}, icon: Icon(Icons.add)),
        'tonal': () =>
            FlowinIconButton.tonal(onPressed: () {}, icon: Icon(Icons.add)),
        'destructive': () => FlowinIconButton.destructive(
          onPressed: () {},
          icon: Icon(Icons.delete),
        ),
      };

      for (final (brightness, dark) in flowinThemes) {
        for (final entry in opaqueVariants.entries) {
          testWidgets('${entry.key} on its own fill, $brightness', (
            tester,
          ) async {
            await tester.pumpApp(
              entry.value(),
              theme: flowinThemeFor(dark: dark),
            );
            final style = tester
                .widget<IconButton>(find.byType(IconButton))
                .style!;
            expectLegible(
              style.foregroundColor!.resolve({})!,
              style.backgroundColor!.resolve({})!,
              // An icon is a non-text element.
              compliance: ContrastCompliance.uiComponent,
            );
          });
        }

        testWidgets('text on the surface behind it, $brightness', (
          tester,
        ) async {
          // Its fill is transparent, so what it must contrast with is the
          // surface it sits on, not its own background.
          final theme = flowinThemeFor(dark: dark);
          await tester.pumpApp(
            FlowinIconButton.text(onPressed: () {}, icon: Icon(Icons.add)),
            theme: theme,
          );
          final style = tester
              .widget<IconButton>(find.byType(IconButton))
              .style!;
          expect(style.backgroundColor!.resolve({}), Colors.transparent);
          expectLegible(
            style.foregroundColor!.resolve({})!,
            theme.colorScheme.surface,
            compliance: ContrastCompliance.uiComponent,
          );
        });

        testWidgets('the rendered icon inherits that foreground, $brightness', (
          tester,
        ) async {
          // Asserting the button's style is not enough on its own: the icon
          // takes its colour from the ambient IconTheme, so a style the icon
          // ignored would still pass the assertions above.
          final theme = flowinThemeFor(dark: dark);
          await tester.pumpApp(
            FlowinIconButton.text(onPressed: () {}, icon: Icon(Icons.add)),
            theme: theme,
          );
          final rendered = IconTheme.of(
            tester.element(find.byIcon(Icons.add)),
          ).color!;
          expect(
            rendered,
            tester
                .widget<IconButton>(find.byType(IconButton))
                .style!
                .foregroundColor!
                .resolve({}),
          );
          expectLegible(
            rendered,
            theme.colorScheme.surface,
            compliance: ContrastCompliance.uiComponent,
          );
        });
      }
    });

    group('variant maps to the right color roles', () {
      testWidgets('filled uses primary', (tester) async {
        await tester.pumpApp(
          FlowinIconButton(onPressed: () {}, icon: Icon(Icons.add)),
        );
        final theme = FlowinTheme.light;
        final button = tester.widget<IconButton>(find.byType(IconButton));
        final bg = button.style?.backgroundColor?.resolve({});
        expect(bg, theme.colorScheme.primary);
      });

      testWidgets('destructive uses errorContainer', (tester) async {
        await tester.pumpApp(
          FlowinIconButton.destructive(
            onPressed: () {},
            icon: Icon(Icons.delete),
          ),
        );
        final theme = FlowinTheme.light;
        final button = tester.widget<IconButton>(find.byType(IconButton));
        final bg = button.style?.backgroundColor?.resolve({});
        expect(bg, theme.colorScheme.errorContainer);
      });

      testWidgets('tonal uses secondaryContainer roles', (tester) async {
        await tester.pumpApp(
          FlowinIconButton.tonal(onPressed: () {}, icon: Icon(Icons.add)),
        );
        final theme = FlowinTheme.light;
        final button = tester.widget<IconButton>(find.byType(IconButton));
        final bg = button.style?.backgroundColor?.resolve({});
        final fg = button.style?.foregroundColor?.resolve({});
        expect(bg, theme.colorScheme.secondaryContainer);
        expect(fg, theme.colorScheme.onSecondaryContainer);
      });

      testWidgets('text is transparent with primary foreground', (
        tester,
      ) async {
        await tester.pumpApp(
          FlowinIconButton.text(onPressed: () {}, icon: Icon(Icons.add)),
        );
        final theme = FlowinTheme.light;
        final button = tester.widget<IconButton>(find.byType(IconButton));
        final bg = button.style?.backgroundColor?.resolve({});
        final fg = button.style?.foregroundColor?.resolve({});
        expect(bg, Colors.transparent);
        expect(fg, theme.colorScheme.primary);
      });
    });

    for (final size in FlowinButtonSize.values) {
      testWidgets('renders at size ${size.name}', (tester) async {
        await tester.pumpApp(
          FlowinIconButton(
            onPressed: () {},
            size: size,
            icon: Icon(Icons.add),
          ),
        );
        expect(find.byType(FlowinIconButton), findsOneWidget);
      });
    }

    testWidgets(
      'circular shape comes from the theme, not the widget '
      '(theme-only styling)',
      (tester) async {
        const customRadius = 6.0;
        final theme = FlowinTheme.light.copyWith(
          iconButtonTheme: IconButtonThemeData(
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(customRadius),
              ),
            ),
          ),
        );

        await tester.pumpApp(
          FlowinIconButton(onPressed: () {}, icon: Icon(Icons.add)),
          theme: theme,
        );

        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(IconButton),
            matching: find.byType(Material),
          ),
        );
        expect(
          material.shape,
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(customRadius),
          ),
        );
      },
    );
  });
}
