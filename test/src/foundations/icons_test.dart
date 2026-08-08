// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FDIcon', () {
    testWidgets('renders an Icon with the semantic iconData', (tester) async {
      await tester.pumpApp(FDIcon(icon: FDIcons.share));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, FDIcons.share.iconData);
    });

    testWidgets('defaults to FlowinDesignIconSize.defaultSize', (tester) async {
      await tester.pumpApp(FDIcon(icon: FDIcons.plus));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, FlowinDesignIconSize.defaultSize.value);
      expect(icon.weight, FlowinDesignIconSize.defaultSize.stroke);
    });

    testWidgets('applies the provided color, size and stroke weight', (
      tester,
    ) async {
      const color = Color(0xFF112233);
      const size = FlowinDesignIconSize.lg;
      await tester.pumpApp(
        FDIcon(icon: FDIcons.trash, color: color, size: size),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, color);
      expect(icon.size, size.value);
      expect(icon.weight, size.stroke);
    });

    testWidgets('falls back to ambient IconTheme when color is null', (
      tester,
    ) async {
      await tester.pumpApp(FDIcon(icon: FDIcons.x));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, isNull);
    });

    testWidgets('a null size yields null size and weight', (tester) async {
      await tester.pumpApp(FDIcon(icon: FDIcons.done, size: null));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, isNull);
      expect(icon.weight, isNull);
    });
  });

  group('FDIcons.toIcon', () {
    test('builds an FDIcon for the semantic icon with no overrides', () {
      final icon = FDIcons.spark.toIcon();
      expect(icon.icon, FDIcons.spark);
      expect(icon.size, isNull);
      expect(icon.color, isNull);
    });

    test('forwards the provided size and color', () {
      const color = Color(0xFF445566);
      const size = FlowinDesignIconSize.sm;
      final icon = FDIcons.edit.toIcon(size: size, color: color);
      expect(icon.icon, FDIcons.edit);
      expect(icon.size, size);
      expect(icon.color, color);
    });
  });

  group('FDIcons.iconData', () {
    test('maps every semantic icon to its concrete Lucide icon', () {
      expect(FDIcons.board.iconData, LucideIcons.rows2);
      expect(FDIcons.timeline.iconData, LucideIcons.route);
      expect(FDIcons.edit.iconData, LucideIcons.settings2);
      expect(FDIcons.paint.iconData, LucideIcons.palette);
      expect(FDIcons.trash.iconData, LucideIcons.trash);
      expect(FDIcons.share.iconData, LucideIcons.share);
      expect(FDIcons.plus.iconData, LucideIcons.plus);
      expect(FDIcons.timer.iconData, LucideIcons.timer);
      expect(FDIcons.arrowRightLeft.iconData, LucideIcons.arrowRightLeft);
      expect(FDIcons.arrowDownUp.iconData, LucideIcons.arrowDownUp);
      expect(FDIcons.settings.iconData, LucideIcons.settings);
      expect(FDIcons.more.iconData, LucideIcons.ellipsisVertical);
      expect(FDIcons.x.iconData, LucideIcons.x);
      expect(FDIcons.setNeutral.iconData, LucideIcons.circleDashed);
      expect(FDIcons.scanFace.iconData, LucideIcons.scanFace);
      expect(FDIcons.restart.iconData, LucideIcons.rotateCcw);
      expect(FDIcons.back.iconData, LucideIcons.arrowLeft);
      expect(FDIcons.done.iconData, LucideIcons.circleCheck);
      expect(FDIcons.spark.iconData, LucideIcons.sparkles);
    });
  });

  group('FDIcons.warmUp', () {
    // The bug it guards against only reproduces on web (DDC), where the icon
    // library is linked lazily on first access. There is no way to assert that
    // from the VM, so this pins the two properties that must hold everywhere:
    // it resolves an icon, and it is safe to call more than once.
    test('resolves the backing icon library without throwing', () {
      expect(FDIcons.warmUp, returnsNormally);
      expect(FDIcons.board.iconData, LucideIcons.rows2);
    });

    test('is idempotent', () {
      FDIcons.warmUp();
      expect(FDIcons.warmUp, returnsNormally);
    });
  });
}
