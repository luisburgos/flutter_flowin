# flutter_flowin example

A profile editor built with Flowin: a preview card that updates as you type,
an accent picker, two labelled fields, and a save action gated on validation.

It exists to show the smallest complete thing — how the theme is installed and
how a screen is assembled from components and tokens. See
[`lib/main.dart`](lib/main.dart).

```sh
cd example
flutter run
```

## What it demonstrates

- **Installing the theme.** `FlowinTheme.light` and `FlowinTheme.dark` on a
  `MaterialApp` is the whole setup. Everything below is then styled by the
  theme, native Material widgets included.
- **One import.** `package:flutter_flowin/flutter_flowin.dart` re-exports
  Flutter's material library, so it is the only import the app needs.
- **Reading tokens from context.** `context.spacing` for layout and
  `context.textTheme` for type, rather than hard-coded numbers.
- **Components.** `FlowinAppBar`, `FlowinCard`, `FlowinLabeledTextField`,
  `FlowinColorPickerField` and `FlowinButton` working together.
- **Contrast resolution.** `AccessibleColorConfig` picks readable foreground
  text for a color the user chose, which cannot be assumed light or dark.

## Looking for every component?

This is deliberately one screen. The [`showcase/`](../showcase) app catalogues
every component, foundation and variant, and is published to GitHub Pages.
