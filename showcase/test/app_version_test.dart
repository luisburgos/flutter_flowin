import 'dart:convert';
import 'dart:io';

import 'package:flowin_showcase/app_info/app_version_info.dart';
import 'package:flowin_showcase/app_info/app_version_label.dart';
import 'package:flowin_showcase/app_info/fake_app_info_service.dart';
import 'package:flowin_showcase/app_info/flowin_app_info_service.dart';
import 'package:flowin_showcase/app_info/i_app_info_service.dart';
import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('flowinVersion', () {
    test('matches the version declared in the package pubspec', () {
      // The constant exists because pubspec.yaml is unreadable at runtime and
      // the package has no codegen step. That duplication is only safe while
      // something fails when the two disagree — this is that something.
      final pubspec = File('../pubspec.yaml').readAsStringSync();
      final declared = RegExp(
        r'^version:\s*(\S+)',
        multiLine: true,
      ).firstMatch(pubspec)?.group(1);

      expect(
        declared,
        isNotNull,
        reason: 'no version: line found in the package pubspec.yaml',
      );

      final expected = flowinBuildNumber.isEmpty
          ? flowinVersion
          : '$flowinVersion+$flowinBuildNumber';

      expect(
        declared,
        expected,
        reason:
            'flowin_app_info_service.dart is stale: the package declares '
            '$declared but the constants say $expected. Update '
            'flowinVersion / flowinBuildNumber to match.',
      );
    });
  });

  group('showcase pubspec', () {
    String versionIn(String path) => RegExp(
      r'^version:\s*(\S+)',
      multiLine: true,
    ).firstMatch(File(path).readAsStringSync())!.group(1)!;

    test('declares the same version as the package', () {
      // The showcase is versioned in lockstep with the design system it
      // catalogues: a screenshot or bug report naming one names the other.
      // Nothing enforces that in the tooling, so it is asserted here.
      expect(versionIn('pubspec.yaml'), versionIn('../pubspec.yaml'));
    });

    test('the README install snippet names the same version', () {
      // The README's `flutter_flowin: ^X.Y.Z` is the fifth version spot, and
      // the one every release forgot until this test existed: nothing in the
      // tooling reads it, so only an assertion keeps it honest.
      final readme = File('../README.md').readAsStringSync();
      final snippet = RegExp(
        r'flutter_flowin:\s*\^(\S+)',
      ).firstMatch(readme)?.group(1);

      expect(
        snippet,
        isNotNull,
        reason: 'no `flutter_flowin: ^X.Y.Z` snippet found in README.md',
      );
      expect(
        snippet,
        versionIn('../pubspec.yaml'),
        reason:
            'README.md is stale: the install snippet says ^$snippet but the '
            'package declares ${versionIn('../pubspec.yaml')}.',
      );
    });

    test('package.json declares the same version as the package', () {
      // conventional-changelog reads the version from package.json, not the
      // pubspec, and writes a section for whatever it finds. Left behind at a
      // previous version the command still succeeds — it silently rewrites the
      // released section instead of opening a new one. Nothing else catches
      // that, so it is asserted here alongside the showcase's own version.
      final packageJson =
          jsonDecode(File('../package.json').readAsStringSync())
              as Map<String, dynamic>;

      expect(packageJson['version'], versionIn('../pubspec.yaml'));
    });
  });

  group('AppVersionInfo.display', () {
    test('prefixes the version and parenthesises the build number', () {
      const info = AppVersionInfo(version: '0.1.0', buildNumber: '1');
      expect(info.display, 'v0.1.0 (1)');
    });

    test('omits empty parentheses when there is no build number', () {
      const info = AppVersionInfo(version: '0.1.0', buildNumber: '');
      expect(info.display, 'v0.1.0');
    });
  });

  group('AppVersionLabel', () {
    Widget harness(IAppInfoService service) => MaterialApp(
      theme: FlowinTheme.light,
      home: Scaffold(body: AppVersionLabel(service: service)),
    );

    testWidgets('renders the resolved version', (tester) async {
      await tester.pumpWidget(
        harness(
          const FakeAppInfoService(
            config: FakeAppInfoConfig(
              versionInfo: AppVersionInfo(version: '9.9.9', buildNumber: '42'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('v9.9.9 (42)'), findsOneWidget);
    });

    testWidgets('renders nothing while the version is pending', (tester) async {
      await tester.pumpWidget(
        harness(
          const FakeAppInfoService(
            config: FakeAppInfoConfig(delay: Duration(seconds: 1)),
          ),
        ),
      );
      // Deliberately not settled: a catalogue screen should not flash a
      // spinner or a placeholder while the version resolves.
      await tester.pump();

      expect(find.byType(Text), findsNothing);

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
