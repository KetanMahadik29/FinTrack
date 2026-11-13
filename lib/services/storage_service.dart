import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _keyTransactions = 'fintrack_transactions_v2';
  static const String _keyUser = 'fintrack_user_v2';
  static const String _keyAuthStatus = 'fintrack_is_logged_in_v2';

  Future<void> saveTransactions(List<TransactionItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => item.toJson()).toList();
    await prefs.setString(_keyTransactions, jsonEncode(jsonList));
  }

  Future<List<TransactionItem>?> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyTransactions);
    if (data == null) return null;
    try {
      final List<dynamic> list = jsonDecode(data);
      return list.map((json) => TransactionItem.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  Future<UserModel?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyUser);
    if (data == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<void> setAuthStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAuthStatus, isLoggedIn);
  }

  Future<bool> getAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAuthStatus) ?? false; // Always default to false so Login screen is shown first!
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTransactions);
    await prefs.remove(_keyUser);
    await prefs.remove(_keyAuthStatus);
  }
}
