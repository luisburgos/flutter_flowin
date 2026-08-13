import 'package:flutter/material.dart';
import 'package:flutter_flowin_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the example app builds and renders its form', (tester) async {
    await tester.pumpWidget(const ExampleApp());

    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('No name yet'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Ada Lovelace');
    await tester.pump();

    expect(find.text('Ada Lovelace'), findsWidgets);
  });
}
