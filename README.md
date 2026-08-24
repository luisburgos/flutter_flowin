# Flutter Flowin

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

A Flutter design system built on design tokens and a Material-mapped theme,
with a component library of buttons, inputs, chips, tabs, cards and sheets.

### 🔎 [**Try the live showcase →**](https://luisburgos.github.io/flutter_flowin/)

Every component and token, in light and dark, running in your browser. No
install required.

## Installation 💻

```sh
flutter pub add flutter_flowin
```

Or add it to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_flowin: ^0.1.0
```

Then hand the theme to your `MaterialApp` — that is the whole setup:

```dart
import 'package:flutter_flowin/flutter_flowin.dart';

MaterialApp(
  theme: FlowinTheme.light,
  darkTheme: FlowinTheme.dark,
  home: const HomeScreen(),
);
```

The package re-exports Flutter's material library, so that single import is all
a Flowin screen needs. See [`example/`](example) for a complete app.

---

## Features ✨

- **Framework-first theming** — colors map onto `ColorScheme`, typography onto `TextTheme`, and component appearance onto Material component themes, so native widgets are styled without per-instance overrides
- **`FlowinTokens` theme extension** — the tokens Material does not model (spacing scale, semantic status colors, base shadow, default icon size) ride on `ThemeData` via `ThemeExtension<T>`
- **Light and dark themes** — `FlowinTheme.light` and `FlowinTheme.dark` build both from one token set, with brightness-appropriate semantic colors and shadows
- **Design foundations** — primitive tokens for colors, typography, spacing, radius, borders, shadows, icons, and icon sizing, plus an accessible-color helper for contrast-safe pairings
- **BuildContext extensions** — `context.flowinTokens`, `context.spacing`, `context.semanticColors`, alongside `context.theme`, `context.colorScheme`, and `context.textTheme`
- **Component library** — buttons, inputs, color pickers, chips and chip groups, tabs, app bars, cards, and action sheets
- **Primitives entry point** — behavioral building blocks with no visual identity of their own (e.g. `FlowinFadePage`, the cross-fade page transition) via `package:flutter_flowin/primitives.dart`, kept below the catalogued component surface

## Usage 🚀

Wrap your app with the theme:

```dart
import 'package:flutter_flowin/flutter_flowin.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlowinTheme.light,
      darkTheme: FlowinTheme.dark,
      home: const MyHomePage(),
    );
  }
}
```

Use widgets in your app:

```dart
FlowinButton.filled(
  onPressed: () {},
  label: 'Click me',
);
```

Access tokens via context extensions:

```dart
final spacing = context.spacing.md;              // 16
final success = context.semanticColors.success;
final shadow = context.flowinTokens.shadow;
```

---

## Showcase 🖼️

The showcase is a gallery of every component — buttons, inputs, color pickers,
chips, tabs, app bars, cards, and action sheets — grouped by area, with a live
light/dark toggle. It is deployed on every push to `main`:

**<https://luisburgos.github.io/flutter_flowin/>**

To run it locally from [`showcase/`](showcase):

```sh
cd showcase && fvm flutter run
```

---

## Contributing 🤝

Setup, the pre-push hook, CI, tests and the changelog workflow are documented in
[`CONTRIBUTING.md`](CONTRIBUTING.md).

---

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
