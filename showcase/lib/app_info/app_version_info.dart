/// Immutable snapshot of the design system's version, decoupled from however
/// it is sourced so the rest of the app never depends on that mechanism.
///
/// [version] is the semantic version (e.g. `0.1.0`) and [buildNumber] is the
/// build number (e.g. `1`). Together they mirror the
/// `version: <version>+<build>` field in the package's `pubspec.yaml`.
class AppVersionInfo {
  /// {@macro app_version_info}
  const AppVersionInfo({required this.version, required this.buildNumber});

  /// The semantic version, without a leading `v`.
  final String version;

  /// The build number, or empty when none is declared.
  final String buildNumber;

  /// User-facing form rendered as `vMAJOR.MINOR.PATCH (buildNumber)`,
  /// e.g. `v0.1.0 (1)`. The `v` prefix is always present; when the build
  /// number is empty only the prefixed version is shown, with no trailing
  /// empty parentheses (e.g. `v0.1.0`).
  String get display {
    final prefixed = 'v$version';
    return buildNumber.isEmpty ? prefixed : '$prefixed ($buildNumber)';
  }
}
