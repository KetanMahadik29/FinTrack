import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';

enum NavigationTab { dashboard, transactions, analytics, settings }

class AppSidebar extends StatelessWidget {
  final NavigationTab currentTab;
  final Function(NavigationTab) onSelectTab;
  final VoidCallback onAddTransaction;
  final bool isCollapsed;

  const AppSidebar({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
    required this.onAddTransaction,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();

    final backgroundColor = isDark ? AppColors.darkCardBackground : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      width: isCollapsed ? AppDimensions.sidebarCollapsedWidth : AppDimensions.sidebarWidth,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          right: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: isCollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // Logo & Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 12 : 24,
              vertical: 24,
            ),
            child: Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FinTrack',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.text,
                            letterSpacing: -0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Finance Hub',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1),

          // Primary Quick Action: + New Transaction
          Padding(
            padding: EdgeInsets.all(isCollapsed ? 12 : 20),
            child: isCollapsed
                ? IconButton.filled(
                    onPressed: onAddTransaction,
                    icon: const Icon(Icons.add_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                    ),
                    tooltip: 'New Transaction',
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAddTransaction,
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('New Transaction'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                      ),
                    ),
                  ),
          ),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 16, vertical: 8),
              children: [
                _buildNavItem(
                  context,
                  tab: NavigationTab.dashboard,
                  title: 'Dashboard',
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context,
                  tab: NavigationTab.transactions,
                  title: 'Transactions',
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long_rounded,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context,
                  tab: NavigationTab.analytics,
                  title: 'Analytics',
                  icon: Icons.pie_chart_outline_rounded,
                  activeIcon: Icons.pie_chart_rounded,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context,
                  tab: NavigationTab.settings,
                  title: 'Settings',
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings_rounded,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // User Profile Card / Logout Footer
          Container(
            padding: EdgeInsets.all(isCollapsed ? 12 : 16),
            child: isCollapsed
                ? IconButton(
                    icon: const Icon(Icons.logout_rounded),
                    color: AppColors.error,
                    tooltip: 'Log out',
                    onPressed: () => auth.logout(),
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: Text(
                          auth.user.name.isNotEmpty ? auth.user.name[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              auth.user.email,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout_rounded, size: 20),
                        color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                        tooltip: 'Logout',
                        onPressed: () => auth.logout(),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required NavigationTab tab,
    required String title,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final isSelected = currentTab == tab;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedBg = AppColors.primary.withOpacity(0.12);
    const selectedColor = AppColors.primary;
    final unselectedColor = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return InkWell(
      onTap: () => onSelectTab(tab),
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCollapsed ? 12 : 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
