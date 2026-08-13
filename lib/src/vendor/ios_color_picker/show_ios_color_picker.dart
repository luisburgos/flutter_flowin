import 'package:flutter/material.dart';

import 'color_observer.dart';
import 'ios_color_picker.dart';

/// Presents the iOS-style color picker as a modal bottom sheet.
///
/// Vendored from `ios_color_picker`'s `IOSColorPickerController`, reduced to
/// the cross-platform path. The upstream controller also exposes a native iOS
/// picker over a method channel; that path is omitted deliberately — it throws
/// `UnsupportedError` on web and Android, and a design system that ships to
/// every platform cannot call it unconditionally. See the README in this
/// directory.
class VendoredIOSColorPicker {
  /// The currently selected color, retained between presentations.
  Color selectedColor = Colors.green;

  /// Shows the picker, calling [onColorChanged] as the selection changes.
  ///
  /// [startingColor] seeds the picker; when null, [selectedColor] is used.
  void show({
    required BuildContext context,
    required ValueChanged<Color> onColorChanged,
    Color? startingColor,
  }) {
    colorController = ColorController(startingColor ?? selectedColor);
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black26,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return IosColorPicker(
          onColorSelected: (value) {
            selectedColor = value;
            onColorChanged(selectedColor);
          },
        );
      },
    );
  }

  /// Releases resources held by the picker.
  ///
  /// Nothing to release on this path: the upstream controller's `dispose`
  /// cancels the native picker's event-channel subscription, which this
  /// cross-platform path never opens. `colorController` is a library-level
  /// global that [show] reassigns each time, so disposing it here would break
  /// the next presentation. Kept so call sites can follow the usual
  /// create/dispose lifecycle.
  void dispose() {}
}
