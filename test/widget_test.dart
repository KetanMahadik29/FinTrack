import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fintrack/main.dart';

void main() {
  testWidgets('FinTrack dashboard loads successfully on desktop', (WidgetTester tester) async {
    // Set desktop screen resolution
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FinTrackApp());
    await tester.pumpAndSettle();

    // Verify brand title and dashboard elements
    expect(find.text('FinTrack'), findsWidgets);
    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.text('Total Income'), findsOneWidget);
    expect(find.text('Total Expenses'), findsOneWidget);
    expect(find.text('Total Savings'), findsOneWidget);
  });
}
