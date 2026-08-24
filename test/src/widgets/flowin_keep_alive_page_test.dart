// Test files favor non-const constructors for readability.
// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_flowin/primitives.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

/// A page whose state is visible in its label, so losing it is observable.
class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  var _count = 0;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => setState(() => _count++),
      child: Text('count: $_count'),
    );
  }
}

void main() {
  group('FlowinKeepAlivePage', () {
    testWidgets('page state survives paging away and back', (tester) async {
      final controller = PageController();
      addTearDown(controller.dispose);

      await tester.pumpApp(
        PageView(
          controller: controller,
          children: [
            FlowinKeepAlivePage(
              key: PageStorageKey<String>('page_0'),
              child: _Counter(),
            ),
            FlowinKeepAlivePage(
              key: PageStorageKey<String>('page_1'),
              child: Center(child: Text('Page 2')),
            ),
          ],
        ),
      );

      await tester.tap(find.text('count: 0'));
      await tester.pump();
      expect(find.text('count: 1'), findsOneWidget);

      controller.jumpToPage(1);
      await tester.pumpAndSettle();
      expect(find.text('Page 2'), findsOneWidget);

      controller.jumpToPage(0);
      await tester.pumpAndSettle();

      // The kept-alive page returns as it was left, not rebuilt from scratch.
      expect(find.text('count: 1'), findsOneWidget);
    });

    testWidgets('without the wrapper the same page loses its state', (
      tester,
    ) async {
      final controller = PageController();
      addTearDown(controller.dispose);

      await tester.pumpApp(
        PageView(
          controller: controller,
          children: [
            _Counter(),
            Center(child: Text('Page 2')),
          ],
        ),
      );

      await tester.tap(find.text('count: 0'));
      await tester.pump();
      expect(find.text('count: 1'), findsOneWidget);

      controller.jumpToPage(1);
      await tester.pumpAndSettle();
      controller.jumpToPage(0);
      await tester.pumpAndSettle();

      // The control case: this is the loss the wrapper exists to prevent.
      expect(find.text('count: 0'), findsOneWidget);
    });
  });
}
