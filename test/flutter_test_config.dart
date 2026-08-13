import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

/// Global test configuration, auto-loaded by `flutter test`.
///
/// Initializes the binding so theme construction is deterministic in tests.
/// Inter is a bundled asset font, so no runtime font fetching is involved.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await testMain();
}
