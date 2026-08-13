import 'package:flutter_flowin/flutter_flowin.dart';

/// The app-wide [ThemeMode], shared by every page.
///
/// A [ValueNotifier] rather than page-local state so the toggle reads and
/// writes one source of truth: switching the theme from a nested page updates
/// the app root and every other page at once, with no state to keep in sync.
class ThemeModeController extends ValueNotifier<ThemeMode> {
  /// {@macro theme_mode_controller}
  ThemeModeController([super.initial = ThemeMode.light]);

  /// Whether the app is currently rendering the dark theme.
  bool get isDark => value == ThemeMode.dark;

  /// Flips between the light and dark themes.
  void toggle() => value = isDark ? ThemeMode.light : ThemeMode.dark;
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
    return FlowinIconButton.text(
      icon: Icon(controller.isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: controller.toggle,
    );
  }
}
