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
/// reports whatever the *host application* declares, and the number a bug
/// report needs is the design system's. The showcase currently declares the
/// same version, so the two agree today — but they agree by convention, not by
/// construction, and nothing stops the shell from being versioned separately.
/// Reading the package's own version keeps the label correct either way.
const flowinVersion = '0.3.0';

/// The design system's build number, mirroring the `+<build>` suffix in the
/// package's `pubspec.yaml`. Empty when the version carries no suffix, as it
/// does today: a build number is meaningless for a library.
const flowinBuildNumber = '';

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
