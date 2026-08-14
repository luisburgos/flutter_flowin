import 'package:flowin_showcase/theme_mode_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeModeController', () {
    test('follows the system appearance on launch', () {
      final controller = ThemeModeController();

      expect(controller.value, ThemeMode.system);
      expect(controller.isDark(Brightness.dark), isTrue);
    });

    test('toggling from system flips what is on screen', () {
      final controller = ThemeModeController()..toggle(Brightness.dark);

      expect(controller.value, ThemeMode.light);
    });
  });
}
