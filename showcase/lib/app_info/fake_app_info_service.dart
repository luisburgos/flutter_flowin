import 'package:flowin_showcase/app_info/app_version_info.dart';
import 'package:flowin_showcase/app_info/i_app_info_service.dart';

/// Behavior configuration for [FakeAppInfoService].
///
/// Carries the canned [AppVersionInfo] to return and an optional [delay] so
/// tests can exercise the loading state of widgets that await
/// [IAppInfoService.versionInfo].
class FakeAppInfoConfig {
  /// {@macro fake_app_info_config}
  const FakeAppInfoConfig({
    this.versionInfo = const AppVersionInfo(version: '0.0.0', buildNumber: '0'),
    this.delay = Duration.zero,
  });

  /// Default config: resolves a placeholder version immediately.
  const FakeAppInfoConfig.active() : this();

  /// The version to resolve.
  final AppVersionInfo versionInfo;

  /// How long to wait before resolving, for exercising the pending state.
  final Duration delay;
}

/// Fake [IAppInfoService] returning a canned [AppVersionInfo], so widget tests
/// can drive the label without depending on the real version.
class FakeAppInfoService implements IAppInfoService {
  /// {@macro fake_app_info_service}
  const FakeAppInfoService({this.config = const FakeAppInfoConfig.active()});

  /// Behavior configuration.
  final FakeAppInfoConfig config;

  @override
  Future<AppVersionInfo> versionInfo() async {
    if (config.delay != Duration.zero) {
      await Future<void>.delayed(config.delay);
    }
    return config.versionInfo;
  }
}
