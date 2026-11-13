import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_builder.dart';
import '../../screens/analytics/analytics_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/transactions/transactions_screen.dart';
import '../dialogs/add_transaction_dialog.dart';
import 'app_sidebar.dart';
import 'app_topbar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  NavigationTab _currentTab = NavigationTab.dashboard;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onSelectTab(NavigationTab tab) {
    setState(() {
      _currentTab = tab;
    });
    // If drawer is open on mobile/tablet, close it
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }

  void _openAddTransactionModal() {
    AddTransactionDialog.show(context);
  }

  String get _currentTabTitle {
    switch (_currentTab) {
      case NavigationTab.dashboard:
        return 'Dashboard';
      case NavigationTab.transactions:
        return 'Transactions';
      case NavigationTab.analytics:
        return 'Analytics & Reports';
      case NavigationTab.settings:
        return 'Settings';
    }
  }

  String get _currentTabSubtitle {
    switch (_currentTab) {
      case NavigationTab.dashboard:
        return 'Overview of cashflow, balances and recent transactions';
      case NavigationTab.transactions:
        return 'Track, filter and manage all your inflows and outflows';
      case NavigationTab.analytics:
        return 'Interactive charts, spending breakdown and trends';
      case NavigationTab.settings:
        return 'Manage user profile, preferred currency and appearance';
    }
  }

  Widget _buildBody() {
    switch (_currentTab) {
      case NavigationTab.dashboard:
        return DashboardScreen(
          onNavigateToTransactions: () => _onSelectTab(NavigationTab.transactions),
        );
      case NavigationTab.transactions:
        return const TransactionsScreen();
      case NavigationTab.analytics:
        return const AnalyticsScreen();
      case NavigationTab.settings:
        return const SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBuilder.isDesktop(context);
    final isTablet = ResponsiveBuilder.isTablet(context);
    final isMobile = ResponsiveBuilder.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      // Mobile Drawer containing the complete Sidebar navigation
      drawer: isMobile || isTablet
          ? Drawer(
              child: AppSidebar(
                currentTab: _currentTab,
                onSelectTab: _onSelectTab,
                onAddTransaction: () {
                  Navigator.of(context).pop();
                  _openAddTransactionModal();
                },
                isCollapsed: false,
              ),
            )
          : null,
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _currentTab.index,
              onDestinationSelected: (index) {
                _onSelectTab(NavigationTab.values[index]);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.primary),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                  label: 'Transactions',
                ),
                NavigationDestination(
                  icon: Icon(Icons.pie_chart_outline_rounded),
                  selectedIcon: Icon(Icons.pie_chart_rounded, color: AppColors.primary),
                  label: 'Analytics',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded, color: AppColors.primary),
                  label: 'Settings',
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          // Desktop Fixed Full Sidebar
          if (isDesktop)
            AppSidebar(
              currentTab: _currentTab,
              onSelectTab: _onSelectTab,
              onAddTransaction: _openAddTransactionModal,
              isCollapsed: false,
            ),

          // Main Screen Area
          Expanded(
            child: Column(
              children: [
                AppTopbar(
                  title: _currentTabTitle,
                  subtitle: _currentTabSubtitle,
                  onOpenDrawer: (isMobile || isTablet)
                      ? () => _scaffoldKey.currentState?.openDrawer()
                      : null,
                  onAddTransaction: _openAddTransactionModal,
                ),
                Expanded(
                  child: SelectionArea(
                    child: _buildBody(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
