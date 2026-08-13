import 'package:flutter_flowin/flutter_flowin.dart';
import 'package:flutter_test/flutter_test.dart';

/// Extension on [WidgetTester] to pump a widget wrapped in [MaterialApp]
/// with the Flowin theme.
extension PumpApp on WidgetTester {
  /// Pumps [widget] wrapped in a [MaterialApp] with [FlowinTheme.light].
  Future<void> pumpApp(Widget widget, {ThemeData? theme}) {
    return pumpWidget(
      MaterialApp(
        theme: theme ?? FlowinTheme.light,
        home: Scaffold(body: widget),
      ),
    );
  }
}
