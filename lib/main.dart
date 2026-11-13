import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'widgets/layout/main_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FinTrackApp());
}

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'FinTrack - Personal Finance Dashboard',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: auth.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const RootNavigationHandler(),
          );
        },
      ),
    );
  }
}

class RootNavigationHandler extends StatefulWidget {
  const RootNavigationHandler({super.key});

  @override
  State<RootNavigationHandler> createState() => _RootNavigationHandlerState();
}

class _RootNavigationHandlerState extends State<RootNavigationHandler> {
  bool _showRegister = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isAuthenticated) {
      if (_showRegister) {
        return RegisterScreen(
          onNavigateToLogin: () => setState(() => _showRegister = false),
        );
      }
      return LoginScreen(
        onNavigateToRegister: () => setState(() => _showRegister = true),
      );
    }

    return const MainScaffold();
  }
}
