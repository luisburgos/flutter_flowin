import 'package:flowin_showcase/app_info/app_version_info.dart';
import 'package:flowin_showcase/app_info/flowin_app_info_service.dart';
import 'package:flowin_showcase/app_info/i_app_info_service.dart';
import 'package:flutter_flowin/flutter_flowin.dart';

/// Footer label showing the design-system version, e.g. `v0.1.0 (1)`.
///
/// Renders muted and centered. Stays blank until the version resolves so it
/// never flashes a spinner; a failed lookup also renders blank, since a missing
/// version is not worth an error state on a catalogue screen.
class AppVersionLabel extends StatelessWidget {
  /// {@macro app_version_label}
  const AppVersionLabel({
    this.service = const FlowinAppInfoService(),
    this.padding,
    super.key,
  });

  /// Resolves the version. Injectable so tests can supply a fake.
  final IAppInfoService service;

  /// Overrides the default padding around the label.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<AppVersionInfo>(
      future: service.versionInfo(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        if (info == null) return const SizedBox.shrink();

        return Padding(
          padding:
              padding ??
              const EdgeInsets.symmetric(
                vertical: FlowinDesignSpace.space300,
                horizontal: FlowinDesignSpace.space400,
              ),
          child: Text(
            info.display,
            textAlign: TextAlign.center,
            style: theme.textTheme.captionLarge.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        );
      },
    );
  }
}
