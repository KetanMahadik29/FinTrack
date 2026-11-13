import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive_builder.dart';
import '../../models/transaction_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/cards/modern_card.dart';
import '../../widgets/cards/summary_metric_card.dart';
import '../../widgets/charts/category_pie_chart.dart';
import '../../widgets/charts/income_expense_chart.dart';
import '../../widgets/dialogs/add_transaction_dialog.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateToTransactions;

  const DashboardScreen({super.key, required this.onNavigateToTransactions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = ResponsiveBuilder.isDesktop(context);
    final isMobile = ResponsiveBuilder.isMobile(context);

    final txProvider = context.watch<TransactionProvider>();
    final auth = context.watch<AuthProvider>();
    final currencySymbol = auth.currencySymbol;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppDimensions.md : AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner & Quick Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${auth.user.name.split(' ').first}! 👋',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Here's an overview of your financial health today.",
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isDesktop) ...[
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => AddTransactionDialog.show(context),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Transaction'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // 1. KPI Summary Metric Cards Grid
          _buildMetricsGrid(context, txProvider, currencySymbol),
          const SizedBox(height: 24),

          // 2. Visual Charts Row (Income vs Expense + Category Breakdown)
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Income vs Expense Bar Chart (65% width)
                Expanded(
                  flex: 65,
                  child: ModernCard(
                    height: 380,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Income vs Expense',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Last 6 Months',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: IncomeExpenseChart(
                            monthlyData: txProvider.monthlyComparisonData,
                            currencySymbol: currencySymbol,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Spending by Category Pie Chart (35% width)
                Expanded(
                  flex: 35,
                  child: ModernCard(
                    height: 380,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spending Breakdown',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: CategoryPieChart(
                              categoryData: txProvider.categorySpendingBreakdown,
                              currencySymbol: currencySymbol,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else ...[
            // Stacked for Tablet / Mobile
            ModernCard(
              height: 340,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Income vs Expense',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Last 6 Months',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: IncomeExpenseChart(
                      monthlyData: txProvider.monthlyComparisonData,
                      currencySymbol: currencySymbol,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spending Breakdown',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CategoryPieChart(
                    categoryData: txProvider.categorySpendingBreakdown,
                    currencySymbol: currencySymbol,
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // 3. Recent Transactions Section
          ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Recent Transactions',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: onNavigateToTransactions,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (txProvider.recentTransactions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No transactions recorded yet.',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: txProvider.recentTransactions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final tx = txProvider.recentTransactions[index];
                      final isIncome = tx.type == TransactionType.income;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: tx.category.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          ),
                          child: Icon(tx.category.icon, color: tx.category.color, size: 20),
                        ),
                        title: Text(
                          tx.title,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        subtitle: Text(
                          '${tx.category.label} • ${Formatters.date(tx.date)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                          ),
                        ),
                        trailing: Text(
                          '${isIncome ? '+' : '-'}${Formatters.currency(tx.amount, symbol: currencySymbol)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isIncome ? AppColors.success : AppColors.error,
                          ),
                        ),
                        onTap: () => AddTransactionDialog.show(context, transaction: tx),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(
    BuildContext context,
    TransactionProvider txProvider,
    String currencySymbol,
  ) {
    final width = MediaQuery.of(context).size.width;

    final isEmpty = txProvider.transactions.isEmpty;

    final cards = [
      SummaryMetricCard(
        title: 'Total Balance',
        formattedAmount: Formatters.currency(txProvider.totalBalance, symbol: currencySymbol),
        icon: Icons.account_balance_rounded,
        iconColor: AppColors.primary,
        iconBgColor: AppColors.primary.withOpacity(0.12),
        trendText: isEmpty ? null : (txProvider.totalBalance >= 0 ? '+0.0%' : '-0.0%'),
        isPositiveTrend: txProvider.totalBalance >= 0,
      ),
      SummaryMetricCard(
        title: 'Total Income',
        formattedAmount: Formatters.currency(txProvider.totalIncome, symbol: currencySymbol),
        icon: Icons.trending_up_rounded,
        iconColor: AppColors.success,
        iconBgColor: AppColors.success.withOpacity(0.12),
        trendText: isEmpty ? null : '+0.0%',
        isPositiveTrend: true,
      ),
      SummaryMetricCard(
        title: 'Total Expenses',
        formattedAmount: Formatters.currency(txProvider.totalExpenses, symbol: currencySymbol),
        icon: Icons.trending_down_rounded,
        iconColor: AppColors.error,
        iconBgColor: AppColors.error.withOpacity(0.12),
        trendText: isEmpty ? null : '-0.0%',
        isPositiveTrend: false,
      ),
      SummaryMetricCard(
        title: 'Total Savings',
        formattedAmount: Formatters.currency(txProvider.totalSavings, symbol: currencySymbol),
        icon: Icons.savings_outlined,
        iconColor: const Color(0xFF8B5CF6),
        iconBgColor: const Color(0xFF8B5CF6).withOpacity(0.12),
        trendText: isEmpty ? null : '${txProvider.savingsRate.toStringAsFixed(1)}% rate',
        isPositiveTrend: true,
      ),
    ];

    if (width >= 1200) {
      // 4 columns in 1 row on large desktop
      return Row(
        children: cards
            .map((c) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: cards.last == c ? 0 : 16,
                    ),
                    child: c,
                  ),
                ))
            .toList(),
      );
    } else if (width >= 650) {
      // 2x2 grid on tablet
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 16),
              Expanded(child: cards[1]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: cards[2]),
              const SizedBox(width: 16),
              Expanded(child: cards[3]),
            ],
          ),
        ],
      );
    } else {
      // Stacked or 2x2 for mobile
      return Column(
        children: cards
            .map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: c,
                ))
            .toList(),
      );
    }
  }
}
