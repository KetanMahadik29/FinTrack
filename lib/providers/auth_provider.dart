import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  UserModel _user = UserModel(
    id: 'user_1',
    name: 'Alex Johnson',
    email: 'alex@fintrack.io',
    currencyCode: 'USD',
    currencySymbol: '\$',
  );
  bool _isAuthenticated = false; // Starts false so the user lands on the Login screen first
  bool _isLoading = false;

  UserModel get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _user.isDarkMode;
  String get currencySymbol => _user.currencySymbol;
  String get currencyCode => _user.currencyCode;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    final savedUser = await _storageService.loadUser();
    if (savedUser != null) {
      _user = savedUser;
    }
    _isAuthenticated = await _storageService.getAuthStatus();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    _user = _user.copyWith(email: email);
    _isAuthenticated = true;
    _isLoading = false;

    await _storageService.saveUser(_user);
    await _storageService.setAuthStatus(true);
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    _user = _user.copyWith(name: name, email: email);
    _isAuthenticated = true;
    _isLoading = false;

    await _storageService.saveUser(_user);
    await _storageService.setAuthStatus(true);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    await _storageService.setAuthStatus(false);
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? email}) async {
    _user = _user.copyWith(
      name: name ?? _user.name,
      email: email ?? _user.email,
    );
    await _storageService.saveUser(_user);
    notifyListeners();
  }

  Future<void> updateCurrency(String code, String symbol) async {
    _user = _user.copyWith(
      currencyCode: code,
      currencySymbol: symbol,
    );
    await _storageService.saveUser(_user);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool isDark) async {
    _user = _user.copyWith(isDarkMode: isDark);
    await _storageService.saveUser(_user);
    notifyListeners();
  }
}
