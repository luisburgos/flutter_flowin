import 'package:flowin_showcase/pages/sheets/bodies/sheet_form_body.dart';
import 'package:flowin_showcase/pages/sheets/bodies/sheet_list_body.dart';
import 'package:flowin_showcase/pages/sheets/bodies/sheet_score_panel.dart';
import 'package:flowin_showcase/pages/sheets/bodies/sheet_text_body.dart';
import 'package:flowin_showcase/pages/sheets/sheet_config.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Resolves a [BodyChoice] to the widget that fills the sheet's body slot.
///
/// Returns null for [BodyChoice.none] rather than an empty box, so the sheet
/// omits the slot entirely and its column closes the gap.
Widget? buildSheetBody(BodyChoice choice) => switch (choice) {
  BodyChoice.none => null,
  BodyChoice.text => const SheetTextBody(),
  BodyChoice.form => const SheetFormBody(),
  BodyChoice.list => const SheetListBody(),
  // Unwrapped on purpose: nothing insets it, so it reaches the card edge.
  BodyChoice.fullBleed => const SheetScorePanel(),
};
