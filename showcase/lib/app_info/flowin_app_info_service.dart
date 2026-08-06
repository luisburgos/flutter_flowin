import 'package:flowin_showcase/app_info/app_version_info.dart';
import 'package:flowin_showcase/app_info/i_app_info_service.dart';

/// The design system's version, mirroring `version:` in the package's
/// `pubspec.yaml`.
///
/// Hand-maintained, because `pubspec.yaml` is not readable at runtime and the
/// package has no codegen step. `app_version_test.dart` parses the pubspec and
/// fails when these drift, so the duplication cannot rot silently.
///
/// Deliberately **not** `package_info_plus`, which the sibling apps use: that
/// reports the *host application's* version — here the showcase shell's
/// `1.0.0+1` — and the number a bug report needs is the design system's.
const flowinVersion = '0.1.0';

/// The design system's build number, mirroring the `+<build>` suffix in the
/// package's `pubspec.yaml`.
const flowinBuildNumber = '1';

/// Reports the version of `flutter_flowin` the showcase is built against.
class FlowinAppInfoService implements IAppInfoService {
  /// {@macro flowin_app_info_service}
  const FlowinAppInfoService();

  @override
  Future<AppVersionInfo> versionInfo() async => const AppVersionInfo(
    version: flowinVersion,
    buildNumber: flowinBuildNumber,
  );
}
