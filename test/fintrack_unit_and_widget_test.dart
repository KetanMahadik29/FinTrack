import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fintrack/main.dart';
import 'package:fintrack/models/transaction_model.dart';
import 'package:fintrack/providers/transaction_provider.dart';

void main() {
  group('FinTrack Responsive & Widget Tests', () {
    testWidgets('Renders properly on Mobile viewport with bottom navigation after login', (tester) async {
      tester.view.physicalSize = const Size(390, 844); // iPhone 12/13/14 viewport
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const FinTrackApp());
      await tester.pumpAndSettle();

      // Starts on Login page
      expect(find.text('Welcome Back'), findsOneWidget);
      await tester.tap(find.text('Quick Demo Sign-In'));
      await tester.pumpAndSettle();

      // Check Mobile NavigationBar exists
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Transactions'), findsWidgets);
      expect(find.text('Analytics'), findsWidgets);
      expect(find.text('Settings'), findsWidgets);
    });

    testWidgets('Tab switching between Dashboard, Transactions, and Settings works', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const FinTrackApp());
      await tester.pumpAndSettle();

      // Log in
      await tester.tap(find.text('Quick Demo Sign-In'));
      await tester.pumpAndSettle();

      // Switch to Transactions
      await tester.tap(find.text('Transactions').first);
      await tester.pumpAndSettle();
      expect(find.text('Manage, track, and categorize all your financial movements.'), findsOneWidget);

      // Switch to Analytics
      await tester.tap(find.text('Analytics').first);
      await tester.pumpAndSettle();
      expect(find.text('Financial Analytics'), findsOneWidget);

      // Switch to Settings
      await tester.tap(find.text('Settings').first);
      await tester.pumpAndSettle();
      expect(find.text('Settings & Preferences'), findsOneWidget);
    });
  });

  group('TransactionProvider Unit Tests', () {
    test('Starts with empty transactions and updates balance correctly when item is added', () {
      final provider = TransactionProvider();
      
      expect(provider.transactions.isEmpty, isTrue);
      expect(provider.totalBalance, 0.0);
      expect(provider.totalIncome, 0.0);
      expect(provider.totalExpenses, 0.0);

      // Add new income
      provider.addTransaction(
        TransactionItem(
          id: 'test_1',
          title: 'Consulting Bonus',
          amount: 1500.0,
          type: TransactionType.income,
          category: TransactionCategory.freelance,
          date: DateTime.now(),
        ),
      );

      expect(provider.totalIncome, 1500.0);
      expect(provider.totalBalance, 1500.0);
      expect(provider.transactions.length, 1);
    });
  });
}
