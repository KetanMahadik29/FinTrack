import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive_builder.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/cards/modern_card.dart';
import '../../widgets/charts/category_pie_chart.dart';
import '../../widgets/charts/income_expense_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = ResponsiveBuilder.isDesktop(context);
    final isMobile = ResponsiveBuilder.isMobile(context);

    final txProvider = context.watch<TransactionProvider>();
    final currencySymbol = context.watch<AuthProvider>().currencySymbol;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppDimensions.md : AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Financial Analytics',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gain in-depth insights into your spending habits and savings trends.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),

          // Overview KPI badges
          if (isMobile) ...[
            _buildMetricTile(
              context,
              title: 'Net Savings Rate',
              value: '${txProvider.savingsRate.toStringAsFixed(1)}%',
              sub: 'Target: >20.0%',
              color: AppColors.primary,
              icon: Icons.savings_outlined,
            ),
            const SizedBox(height: 12),
            _buildMetricTile(
              context,
              title: 'Average Monthly Spend',
              value: Formatters.currency(
                txProvider.totalExpenses / 6,
                symbol: currencySymbol,
              ),
              sub: 'Based on 6 mo. data',
              color: AppColors.error,
              icon: Icons.credit_card_outlined,
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    context,
                    title: 'Net Savings Rate',
                    value: '${txProvider.savingsRate.toStringAsFixed(1)}%',
                    sub: 'Target: >20.0%',
                    color: AppColors.primary,
                    icon: Icons.savings_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricTile(
                    context,
                    title: 'Average Monthly Spend',
                    value: Formatters.currency(
                      txProvider.totalExpenses / 6,
                      symbol: currencySymbol,
                    ),
                    sub: 'Based on 6 mo. data',
                    color: AppColors.error,
                    icon: Icons.credit_card_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricTile(
                    context,
                    title: 'Active Categories',
                    value: '${txProvider.categorySpendingBreakdown.length}',
                    sub: 'Expense categories',
                    color: const Color(0xFF10B981),
                    icon: Icons.pie_chart_outline_rounded,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),

          // Main Comparison Chart
          ModernCard(
            height: 380,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Monthly Cash Flow (Income vs Expense)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Past 6 Months',
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
          const SizedBox(height: 24),

          // Savings Trend Line Chart + Category Distribution Row
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Savings Trend Line Chart
                Expanded(
                  flex: 6,
                  child: ModernCard(
                    height: 380,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Savings Trend',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Net monthly accumulation over time',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _buildSavingsLineChart(context, txProvider, currencySymbol),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Spending Breakdown
                Expanded(
                  flex: 4,
                  child: ModernCard(
                    height: 380,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category Distribution',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
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
                  Text(
                    'Savings Trend',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildSavingsLineChart(context, txProvider, currencySymbol),
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
                    'Category Distribution',
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
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required String title,
    required String value,
    required String sub,
    required Color color,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ModernCard(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsLineChart(
    BuildContext context,
    TransactionProvider txProvider,
    String currencySymbol,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final monthly = txProvider.monthlyComparisonData;

    final spots = <FlSpot>[];
    for (int i = 0; i < monthly.length; i++) {
      final net = monthly[i].income - monthly[i].expense;
      spots.add(FlSpot(i.toDouble(), net > 0 ? net : 0));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < monthly.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      monthly[index].monthLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              getTitlesWidget: (value, meta) {
                return Text(
                  Formatters.compactCurrency(value, symbol: currencySymbol),
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withOpacity(0.12),
            ),
          ),
        ],
      ),
    );
  }
}
