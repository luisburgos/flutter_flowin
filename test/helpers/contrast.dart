import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

/// Asserts [foreground] is legible on [background] at [compliance].
///
/// Prefer this over asserting a colour equals a named role. A role assertion
/// says *which* token was used and stays green when the pairing itself is
/// unreadable — a bright role on a bright surface is still that role. This
/// asserts the property the contract actually promises, so it survives a
/// palette change and catches pairings nobody thought to enumerate.
void expectLegible(
  Color foreground,
  Color background, {
  ContrastCompliance compliance = ContrastCompliance.normalText,
  String? reason,
}) {
  // Measured through the system's own function rather than a local copy of
  // the WCAG formula: a second implementation is exactly the drift the
  // accessible-colour layer was ported to eliminate.
  final ratio = flowinContrastRatio(foreground, background);
  expect(
    ratio,
    greaterThanOrEqualTo(compliance.minRatio),
    reason:
        reason ??
        'expected at least ${compliance.minRatio}:1 for ${compliance.name}, '
            'got ${ratio.toStringAsFixed(2)}:1',
  );
}

/// The two brightnesses, for tests that must hold in both.
///
/// Several defects have been brightness-specific — an elevation shadow that
/// glowed in dark mode, and card content that failed on *opposite* fills per
/// theme — and a test pinned to one brightness passes while the other breaks.
const flowinThemes = <(String, bool)>[('light', false), ('dark', true)];

/// The [ThemeData] for a [flowinThemes] entry.
ThemeData flowinThemeFor({required bool dark}) =>
    dark ? FlowinTheme.dark : FlowinTheme.light;
