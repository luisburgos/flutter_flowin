import 'package:flowin_showcase/app_info/app_version_info.dart';

/// Resolves the version of the design system the showcase is running against.
// ignore: one_member_abstracts
abstract interface class IAppInfoService {
  /// The running design-system version.
  Future<AppVersionInfo> versionInfo();
}
