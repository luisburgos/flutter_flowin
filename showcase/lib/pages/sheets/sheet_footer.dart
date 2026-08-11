import 'package:flowin_showcase/pages/sheets/sheet_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Resolves a [FooterChoice] to the widget that fills the sheet's footer slot.
///
/// [onPressed] fires from every action, so the modal can pop while the inline
/// preview does nothing. Returns null for [FooterChoice.none] so the sheet
/// omits the slot rather than reserving space for it.
Widget? buildSheetFooter(FooterChoice choice, VoidCallback onPressed) =>
    switch (choice) {
      FooterChoice.none => null,
      FooterChoice.single => FlowinActionSheetFooter(
        right: FlowinButton.filled(
          size: FlowinButtonSize.md,
          onPressed: onPressed,
          label: 'Continue',
        ),
      ),
      FooterChoice.pair => FlowinActionSheetFooter(
        left: FlowinButton.tonal(
          size: FlowinButtonSize.md,
          onPressed: onPressed,
          label: 'Cancel',
        ),
        right: FlowinButton.filled(
          size: FlowinButtonSize.md,
          onPressed: onPressed,
          label: 'Confirm',
        ),
      ),
    };
