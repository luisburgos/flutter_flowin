# Vendored: ios_color_picker

Source: [`mokhselim/ios_color_picker`](https://github.com/mokhselim/ios_color_picker),
MIT licensed — the upstream `LICENSE` is preserved in this directory and its
copyright notice must stay with this code.

Vendored on 2026-08-13 from the `custom_picker/` half of the package.

## Why this is vendored rather than depended on

`flutter_flowin` previously depended on a **fork** of this package by git
reference. pub.dev rejects both `git:` and `path:` dependencies, so that pin
blocked publishing entirely.

Switching to the hosted `ios_color_picker: ^3.0.0` does not work either. Its
pubspec declares the web plugin entry point as:

```yaml
web:
  pluginClass: IosColorPickerWeb
  fileName: ios_color_picker_web.dart
```

Flutter resolves `fileName` relative to `lib/`, but the published package ships
that file at `lib/native_picker/ios_color_picker_web.dart`. The generated web
registrant therefore imports a path that does not exist, and web builds break.
The fork existed to fix exactly that, plus a missing `lib/ios_color_picker.dart`
entry point.

Vendoring the pure-Dart picker removes the dependency, so neither problem
applies.

## What was taken, and what was left

Taken: the whole `custom_picker/` tree — the cross-platform picker UI, its
palette, sliders, grid and area pickers, and the recent-colors history.

Left behind: the plugin machinery. The upstream package also exposes the
**native iOS system picker** over a method channel, backed by native code for
Android, iOS, macOS, Linux and Windows. That path is deliberately not vendored:

- `flutter_flowin` never called it. The only call site used
  `showIOSCustomColorPicker`, the cross-platform path.
- It throws `UnsupportedError` on web and on every non-iOS platform, so a
  design system shipping to all platforms could not call it unconditionally.
- Only a Flutter *plugin* may declare platform implementations. Vendoring it
  would mean converting this package into a plugin and owning native code for
  five platforms.

If the native iOS picker is ever wanted, that is the trade to reopen: it needs
a plugin dependency, not a wider copy of this directory.

`show_ios_color_picker.dart` in this directory is not upstream's file. It is a
reduced `IOSColorPickerController` carrying only the cross-platform
presentation, written for this vendoring.

## Maintenance

No upstream fixes flow in. The code is self-contained UI and stable, but it is
now ours. The web-registration bug above is worth reporting upstream as a
courtesy even though we no longer depend on the package.

Tracked in luisburgos/flowin_pm#40.
