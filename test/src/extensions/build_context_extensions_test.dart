import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FlowinThemeBuildContext', () {
    testWidgets('flowinTokens returns FlowinTokens from theme', (tester) async {
      late FlowinTokens tokens;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            tokens = context.flowinTokens;
            return const SizedBox();
          },
        ),
      );

      expect(tokens, isA<FlowinTokens>());
    });

    testWidgets('spacing and semanticColors resolve from tokens', (
      tester,
    ) async {
      late FlowinSpacing spacing;
      late FlowinSemanticColors semanticColors;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            spacing = context.spacing;
            semanticColors = context.semanticColors;
            return const SizedBox();
          },
        ),
      );

      expect(spacing, isA<FlowinSpacing>());
      expect(semanticColors, isA<FlowinSemanticColors>());
    });

    testWidgets('theme returns the current ThemeData', (tester) async {
      late ThemeData theme;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            theme = context.theme;
            return const SizedBox();
          },
        ),
      );

      expect(theme, isA<ThemeData>());
      expect(theme.extension<FlowinTokens>(), isNotNull);
    });

    testWidgets('colorScheme and textTheme resolve from theme', (tester) async {
      late ColorScheme colorScheme;
      late TextTheme textTheme;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            colorScheme = context.colorScheme;
            textTheme = context.textTheme;
            return const SizedBox();
          },
        ),
      );

      expect(colorScheme, isA<ColorScheme>());
      expect(textTheme, isA<TextTheme>());
    });
  });
}
