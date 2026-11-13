import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fintrack/main.dart';

void main() {
  testWidgets('FinTrack starts on Login page and loads empty Dashboard after login', (WidgetTester tester) async {
    // Set desktop screen resolution
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FinTrackApp());
    await tester.pumpAndSettle();

    // 1. Initial Screen MUST be Login Page
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign In to Dashboard'), findsOneWidget);
    expect(find.text('Quick Demo Sign-In'), findsOneWidget);

    // 2. Perform Login via Quick Demo Sign-In
    await tester.tap(find.text('Quick Demo Sign-In'));
    await tester.pumpAndSettle();

    // 3. Verify Dashboard loads with NO entries ($0.00)
    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.text('\$0.00'), findsWidgets);
    expect(find.text('No transactions recorded yet.'), findsOneWidget);
    expect(find.text('No cash flow data yet'), findsOneWidget);
  });
}
