import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  // Flowin ships no custom divider: the native Divider is styled by the theme's
  // dividerTheme. These tests assert that the theme drives its appearance.
  group('Divider (theme-driven)', () {
    testWidgets('color and thickness come from the dividerTheme', (
      tester,
    ) async {
      await tester.pumpApp(const Divider());
      final divider = DividerTheme.of(
        tester.element(find.byType(Divider)),
      );
      final scheme = FlowinTheme.light.colorScheme;
      expect(divider.color, scheme.outlineVariant);
      expect(divider.thickness, FlowinDesignBorders.regular);
    });

    testWidgets(
      'overriding the dividerTheme changes the divider (theme-only styling)',
      (tester) async {
        const customColor = Color(0xFF445566);
        const customThickness = 4.0;
        final theme = FlowinTheme.light.copyWith(
          dividerTheme: const DividerThemeData(
            color: customColor,
            thickness: customThickness,
          ),
        );

        await tester.pumpApp(const Divider(), theme: theme);

        final divider = DividerTheme.of(
          tester.element(find.byType(Divider)),
        );
        expect(divider.color, customColor);
        expect(divider.thickness, customThickness);
      },
    );
  });
}
