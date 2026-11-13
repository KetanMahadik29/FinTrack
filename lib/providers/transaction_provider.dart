import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/demo_data.dart';
import '../models/transaction_model.dart';
import '../services/storage_service.dart';

class MonthlyFinanceData {
  final String monthLabel;
  final double income;
  final double expense;

  MonthlyFinanceData({
    required this.monthLabel,
    required this.income,
    required this.expense,
  });
}

class CategorySpendData {
  final TransactionCategory category;
  final double amount;
  final double percentage;

  CategorySpendData({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}

class TransactionProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<TransactionItem> _transactions = [];
  bool _isLoading = true;

  // Filters & Search state
  String _searchQuery = '';
  TransactionType? _selectedTypeFilter;
  TransactionCategory? _selectedCategoryFilter;

  List<TransactionItem> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  TransactionType? get selectedTypeFilter => _selectedTypeFilter;
  TransactionCategory? get selectedCategoryFilter => _selectedCategoryFilter;

  TransactionProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    final saved = await _storageService.loadTransactions();
    if (saved != null) {
      _transactions = saved;
    } else {
      _transactions = []; // Starts with NO entries
      await _storageService.saveTransactions(_transactions);
    }

    _isLoading = false;
    notifyListeners();
  }

  // Filtered transactions for the transactions screen
  List<TransactionItem> get filteredTransactions {
    return _transactions.where((tx) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = tx.title.toLowerCase().contains(query);
        final matchesCategory = tx.category.label.toLowerCase().contains(query);
        final matchesNotes = tx.notes?.toLowerCase().contains(query) ?? false;
        if (!matchesTitle && !matchesCategory && !matchesNotes) {
          return false;
        }
      }

      // Type filter
      if (_selectedTypeFilter != null && tx.type != _selectedTypeFilter) {
        return false;
      }

      // Category filter
      if (_selectedCategoryFilter != null && tx.category != _selectedCategoryFilter) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionItem> get recentTransactions {
    final sorted = List<TransactionItem>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(6).toList();
  }

  // Financial Metrics
  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalBalance => totalIncome - totalExpenses;

  double get totalSavings {
    final balance = totalBalance;
    return balance > 0 ? balance : 0.0;
  }

  double get savingsRate {
    if (totalIncome <= 0) return 0;
    final rate = ((totalIncome - totalExpenses) / totalIncome) * 100;
    return rate > 0 ? rate : 0;
  }

  // CRUD Operations
  Future<void> addTransaction(TransactionItem item) async {
    _transactions.insert(0, item);
    await _storageService.saveTransactions(_transactions);
    notifyListeners();
  }

  Future<void> updateTransaction(TransactionItem updatedItem) async {
    final index = _transactions.indexWhere((t) => t.id == updatedItem.id);
    if (index != -1) {
      _transactions[index] = updatedItem;
      await _storageService.saveTransactions(_transactions);
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _storageService.saveTransactions(_transactions);
    notifyListeners();
  }

  Future<void> resetToDemoData() async {
    _transactions = DemoData.getSampleTransactions();
    await _storageService.saveTransactions(_transactions);
    notifyListeners();
  }

  // Filter controls
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setTypeFilter(TransactionType? type) {
    _selectedTypeFilter = type;
    notifyListeners();
  }

  void setCategoryFilter(TransactionCategory? category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedTypeFilter = null;
    _selectedCategoryFilter = null;
    notifyListeners();
  }

  // Analytics Helpers
  List<CategorySpendData> get categorySpendingBreakdown {
    final expenseTxs = _transactions.where((t) => t.type == TransactionType.expense);
    final totalExp = totalExpenses;
    if (totalExp == 0) return [];

    final Map<TransactionCategory, double> map = {};
    for (final tx in expenseTxs) {
      map[tx.category] = (map[tx.category] ?? 0) + tx.amount;
    }

    final list = map.entries.map((entry) {
      return CategorySpendData(
        category: entry.key,
        amount: entry.value,
        percentage: (entry.value / totalExp) * 100,
      );
    }).toList();

    list.sort((a, b) => b.amount.compareTo(a.amount));
    return list;
  }

  List<MonthlyFinanceData> get monthlyComparisonData {
    final now = DateTime.now();
    final List<MonthlyFinanceData> result = [];

    // Last 6 months
    for (int i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final monthLabel = DateFormat('MMM').format(monthDate);

      double monthlyInc = 0;
      double monthlyExp = 0;

      for (final tx in _transactions) {
        if (tx.date.year == monthDate.year && tx.date.month == monthDate.month) {
          if (tx.type == TransactionType.income) {
            monthlyInc += tx.amount;
          } else {
            monthlyExp += tx.amount;
          }
        }
      }

      result.add(MonthlyFinanceData(
        monthLabel: monthLabel,
        income: monthlyInc,
        expense: monthlyExp,
      ));
    }

    return result;
  }
}
