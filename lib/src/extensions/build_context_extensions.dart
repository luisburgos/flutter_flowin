import 'package:flutter/material.dart';
import 'package:flutter_flowin/src/theme/flowin_semantic_colors.dart';
import 'package:flutter_flowin/src/theme/flowin_spacing.dart';
import 'package:flutter_flowin/src/theme/flowin_tokens.dart';

/// Convenience accessors for the Flowin theme from a [BuildContext].
extension FlowinThemeBuildContext on BuildContext {
  /// The current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// The current Material [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// The current Material [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// The Flowin design tokens registered on the theme.
  FlowinTokens get flowinTokens => Theme.of(this).extension<FlowinTokens>()!;

  /// The Flowin spacing scale.
  FlowinSpacing get spacing => flowinTokens.spacing;

  /// The Flowin semantic status colors (success / warning / info).
  FlowinSemanticColors get semanticColors => flowinTokens.semanticColors;
}
