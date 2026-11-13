import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive_builder.dart';
import '../../providers/auth_provider.dart';

class AppTopbar extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onOpenDrawer;
  final VoidCallback onAddTransaction;

  const AppTopbar({
    super.key,
    required this.title,
    required this.subtitle,
    this.onOpenDrawer,
    required this.onAddTransaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = ResponsiveBuilder.isMobile(context);
    final auth = context.watch<AuthProvider>();

    final backgroundColor = isDark ? AppColors.darkCardBackground : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      height: AppDimensions.topbarHeight,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? AppDimensions.md : AppDimensions.lg,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Mobile/Tablet hamburger menu
          if (onOpenDrawer != null) ...[
            IconButton(
              onPressed: onOpenDrawer,
              icon: const Icon(Icons.menu_rounded),
              tooltip: 'Open Menu',
              color: isDark ? Colors.white : AppColors.text,
            ),
            const SizedBox(width: 8),
          ],

          // Title & Subtitle
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isMobile)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Date badge (hidden on small mobile screens)
          if (!isMobile) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF162032) : AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    Formatters.date(DateTime.now()),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkText : AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Theme toggle button
          IconButton(
            onPressed: () => auth.toggleDarkMode(!auth.isDarkMode),
            icon: Icon(
              auth.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
              size: 20,
            ),
            tooltip: auth.isDarkMode ? 'Switch to Light' : 'Switch to Dark',
            color: isDark ? Colors.amber : AppColors.textMuted,
          ),

          const SizedBox(width: 6),

          // Add transaction button (only on mobile topbar, since desktop has sidebar button)
          if (isMobile) ...[
            IconButton.filled(
              onPressed: onAddTransaction,
              icon: const Icon(Icons.add_rounded, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(8),
              ),
              tooltip: 'Add Transaction',
            ),
          ],
        ],
      ),
    );
  }
}
