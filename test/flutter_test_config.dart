import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

/// Global test configuration, auto-loaded by `flutter test`.
///
/// Initializes the binding so theme construction is deterministic in tests.
/// Inter and Supreme are bundled asset fonts, so no runtime font fetching is
/// involved.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await testMain();
}
