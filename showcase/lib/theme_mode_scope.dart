import 'package:flutter_flowin/flutter_flowin.dart';

/// The app-wide [ThemeMode], shared by every page.
///
/// A [ValueNotifier] rather than page-local state so the toggle reads and
/// writes one source of truth: switching the theme from a nested page updates
/// the app root and every other page at once, with no state to keep in sync.
///
/// Starts at [ThemeMode.system]; the first toggle makes the mode explicit.
class ThemeModeController extends ValueNotifier<ThemeMode> {
  /// {@macro theme_mode_controller}
  ThemeModeController([super.initial = ThemeMode.system]);

  /// Whether the dark theme is rendering.
  ///
  /// Takes the ambient brightness because under [ThemeMode.system] the answer
  /// is the platform's, not [value]'s.
  bool isDark(Brightness platformBrightness) => switch (value) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system => platformBrightness == Brightness.dark,
  };

  /// Flips to the opposite of what is currently on screen.
  void toggle(Brightness platformBrightness) =>
      value = isDark(platformBrightness) ? ThemeMode.light : ThemeMode.dark;
}

/// Publishes a [ThemeModeController] to the widget tree.
///
/// Extends [InheritedNotifier] so dependents rebuild when the mode changes;
/// pages reach it with [ThemeModeScope.of].
class ThemeModeScope extends InheritedNotifier<ThemeModeController> {
  /// {@macro theme_mode_scope}
  const ThemeModeScope({
    required ThemeModeController super.notifier,
    required super.child,
    super.key,
  });

  /// The nearest [ThemeModeController].
  ///
  /// Asserts rather than returning null: every page in this app is mounted
  /// under the scope, so a miss is a wiring bug, not a state to handle.
  static ThemeModeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeModeScope>();
    assert(scope != null, 'No ThemeModeScope found above this widget.');
    return scope!.notifier!;
  }
}

/// The theme toggle button, rendered in every page's app bar.
///
/// Reads and writes [ThemeModeScope], so it shows the same state and produces
/// the same effect from anywhere in the app.
class ThemeModeToggle extends StatelessWidget {
  /// {@macro theme_mode_toggle}
  const ThemeModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeModeScope.of(context);
    // Via MediaQuery so the icon updates if the device appearance changes.
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = controller.isDark(brightness);

    return FlowinIconButton.text(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () => controller.toggle(brightness),
    );
  }
}
