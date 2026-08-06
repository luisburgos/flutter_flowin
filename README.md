# Flutter Flowin

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Flowin Design UI flutter package

## Installation 💻

**❗ In order to start using Flutter Flowin you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

This package is not published to pub.dev (`publish_to: none`), so depend on it
by git reference:

```yaml
dependencies:
  flutter_flowin:
    git:
      url: https://github.com/luisburgos/flutter_flowin.git
      ref: 0.1.0
```

Or by path, when working on the package and a consuming app side by side:

```yaml
dependencies:
  flutter_flowin:
    path: ../flutter_flowin
```

---

## Features ✨

- **Framework-first theming** — colors map onto `ColorScheme`, typography onto `TextTheme`, and component appearance onto Material component themes, so native widgets are styled without per-instance overrides
- **`FlowinTokens` theme extension** — the tokens Material does not model (spacing scale, semantic status colors, base shadow, default icon size) ride on `ThemeData` via `ThemeExtension<T>`
- **Light and dark themes** — `FlowinTheme.light` and `FlowinTheme.dark` build both from one token set, with brightness-appropriate semantic colors and shadows
- **Design foundations** — primitive tokens for colors, typography, spacing, radius, borders, shadows, icons, and icon sizing, plus an accessible-color helper for contrast-safe pairings
- **BuildContext extensions** — `context.flowinTokens`, `context.spacing`, `context.semanticColors`, alongside `context.theme`, `context.colorScheme`, and `context.textTheme`
- **Component library** — buttons, inputs, color pickers, chips and chip groups, tabs, app bars, cards, and action sheets

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

## Components 🧱

Every component below has a page in the [`showcase/`](showcase) app — a runnable
gallery grouped by area, with a live light/dark toggle:

```sh
cd showcase && fvm flutter run
```

**Buttons & actions**

- `FlowinButton` — primary/secondary button over Material's filled and outlined variants
- `FlowinIconButton` — icon-only action
- `FlowinItemButton` — full-width list-row action
- `FlowinActionSheet` — modal sheet, with `FlowinActionSheetHeader` and `FlowinActionSheetFooter`

**Inputs**

- `FlowinTextField` — styled text input
- `FlowinInputField` — input wrapper with decoration and states
- `FlowinLabeledTextField` — labeled input pairing
- `FlowinColorPickerField` — color selection field
- `FlowinInlineColorPicker` — inline color swatch picker
- `FlowinColorRadialButton` — radial color swatch button

**Navigation**

- `FlowinAppBar` — app bar styled from tokens
- `FlowinTabAppBar` — app bar with an integrated tab strip
- `FlowinTabs` / `FlowinTabItem` — tab bar and its items

**Grouping & layout**

- `FlowinCard` — surface container, with `FlowinCardBorderRadius` presets
- `FlowinChip` — selectable chip
- `FlowinChipGroup` / `FlowinChipGroupController` — chip set with selection state
- `FlowinChipGroupViewPager` / `FlowinChipGroupViewPage` — chip group driving a paged view

---

## Continuous Integration 🤖

Flutter Flowin comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link] but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using the [Very Good Workflows][very_good_coverage_link].

---

## Local development 🪝

This project pins its Flutter SDK with [FVM][fvm_link] (`.fvmrc` → Flutter `3.44.0`). **Run all Flutter/Dart commands through `fvm`** (e.g. `fvm flutter test`, `fvm dart format .`) so you use the pinned SDK rather than whatever is first on your `PATH`.

A **pre-push git hook** (managed by [lefthook][lefthook_link]) mirrors the CI gates — `dart format`, `flutter analyze`, `flutter test`, and a markdown spell-check ([cspell][cspell_link]) — and **blocks the push** if any fail, so problems are caught locally before a PR is opened. The Flutter/Dart commands run via `fvm`. The spell-check uses a local/global `cspell` if available and falls back to `npx cspell`; if neither is installed it is skipped locally (CI still enforces it).

First-time setup after cloning:

```sh
fvm install        # fetch the pinned Flutter SDK declared in .fvmrc
lefthook install   # wire the git hooks (see https://lefthook.dev to install the binary)
```

The hook configuration lives in [`lefthook.yml`](lefthook.yml). To run it on demand without pushing:

```sh
lefthook run pre-push
```

---

## Running Tests 🧪

For first time users, install the [very_good_cli][very_good_cli_link]:

```sh
dart pub global activate very_good_cli
```

To run all unit tests:

```sh
very_good test --coverage
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[cspell_link]: https://cspell.org
[flutter_install_link]: https://docs.flutter.dev/get-started/install
[fvm_link]: https://fvm.app
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[lefthook_link]: https://lefthook.dev
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
