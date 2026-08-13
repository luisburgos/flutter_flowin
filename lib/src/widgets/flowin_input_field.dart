import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/foundations/foundations.dart';
import 'package:flutter_flowin/src/widgets/flowin_card.dart';

/// The minimum height of a [FlowinInputField] surface.
const double kFlowinInputFieldMinHeight = FlowinDesignSpace.space1600;

/// The maximum height of a [FlowinInputField] content area.
const double kFlowinInputFieldContentMaxHeight = FlowinDesignSpace.space1000;

/// The gap between a [FlowinInputField] label and its surface.
const double kFlowinInputFieldLabelGap = FlowinDesignSpace.space200;

/// {@template flowin_input_field}
/// A labelled field: a label stacked **above** an arbitrary [child], on a
/// bordered surface.
///
/// This is the generic labelled-field primitive. Stacking is not configurable —
/// every labelled field in the system places its label above the content, so
/// the arrangement is absorbed here rather than surfaced as an option. The
/// field owns the label's text style, the gap beneath it, and the surface
/// (border, radius, padding); the child carries its own contract. Colors and
/// text styles come from the theme.
///
/// `FlowinLabeledTextField` is the thin convenience over this that fills the
/// child slot with a `FlowinTextField`.
/// {@endtemplate}
class FlowinInputField extends StatelessWidget {
  /// {@macro flowin_input_field}
  const FlowinInputField({
    required this.child,
    this.label,
    this.surface = true,
    super.key,
  });

  /// The label shown above the surface. When null, only the [child] renders.
  final String? label;

  /// The field content.
  final Widget child;

  /// Whether to wrap [child] in the bordered field surface.
  ///
  /// Defaults to true. Set it to false when the child already draws its own
  /// chrome — a themed text entry carries the field border and fill from
  /// `inputDecorationTheme`, so surfacing it again would double the border.
  /// The label treatment is unaffected either way.
  final bool surface;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final content = surface
        ? FlowinCard(
            // Default radius (medium / radius400) — the Flowin field radius.
            size: const Size.fromHeight(kFlowinInputFieldMinHeight),
            backgroundColor: Colors.transparent,
            borderSide: BorderSide(color: colorScheme.outlineVariant),
            padding: const EdgeInsets.symmetric(
              vertical: FlowinDesignSpace.space300,
              horizontal: FlowinDesignSpace.space400,
            ),
            child: SizedBox(
              height: kFlowinInputFieldContentMaxHeight,
              child: Align(child: child),
            ),
          )
        : child;

    if (label == null) return content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label!,
          style: textTheme.labelMedium?.copyWith(color: colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: kFlowinInputFieldLabelGap),
        content,
      ],
    );
  }
}
