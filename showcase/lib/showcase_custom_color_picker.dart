import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:ios_color_picker/ios_color_picker.dart';

/// A [FlowinCustomColorPicker] backed by the `ios_color_picker` package.
///
/// This is the showcase's own wiring, not part of the design system: it adapts
/// the package's iOS-style picker into the `Future<Color?>` contract
/// [FlowinColorPickerField.onPickCustomColor] expects. Any app can do the same
/// with its picker of choice — copy this file as the starting point.
///
/// The picker reports each change through [IosColorPicker.onColorSelected]; we
/// track the latest and hand it back when the modal closes. The package's
/// [IOSColorPickerController] also presents this picker, but it swallows the
/// sheet's future, so we present the exported widget directly to await the
/// result.
Future<Color?> showcaseCustomColorPicker(
  BuildContext context,
  Color? current,
) {
  var picked = current;

  return showModalBottomSheet<Color?>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black26,
    isScrollControlled: true,
    builder: (context) => IosColorPicker(
      onColorSelected: (value) => picked = value,
    ),
  ).then((_) => picked);
}
