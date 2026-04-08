import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('URCLINIC Employee'),
          ),
        ),
      ),
    );

    expect(find.text('URCLINIC Employee'), findsOneWidget);
  });
}
