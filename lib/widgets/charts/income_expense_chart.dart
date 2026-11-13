import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/transaction_provider.dart';

class IncomeExpenseChart extends StatelessWidget {
  final List<MonthlyFinanceData> monthlyData;
  final String currencySymbol;

  const IncomeExpenseChart({
    super.key,
    required this.monthlyData,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (monthlyData.isEmpty) {
      return const Center(child: Text('No transaction history available'));
    }

    final hasData = monthlyData.any((m) => m.income > 0 || m.expense > 0);
    if (!hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 44,
              color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
            ),
            const SizedBox(height: 10),
            Text(
              'No cash flow data yet',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add transactions to visualize income vs expense comparison',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
              ),
            ),
          ],
        ),
      );
    }

    double maxY = 0;
    for (final m in monthlyData) {
      if (m.income > maxY) maxY = m.income;
      if (m.expense > maxY) maxY = m.expense;
    }
    maxY = (maxY * 1.25).clamp(1000, 50000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLegendItem('Income', AppColors.success),
            const SizedBox(width: 16),
            _buildLegendItem('Expense', AppColors.error),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => isDark ? const Color(0xFF1E293B) : Colors.black87,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final isIncome = rodIndex == 0;
                    final type = isIncome ? 'Income' : 'Expense';
                    final value = rod.toY;
                    return BarTooltipItem(
                      '$type\n${Formatters.currency(value, symbol: currencySymbol)}',
                      TextStyle(
                        color: isIncome ? AppColors.success : const Color(0xFFFF6B6B),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      return Text(
                        Formatters.compactCurrency(value, symbol: currencySymbol),
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                          fontSize: 11,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < monthlyData.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            monthlyData[index].monthLabel,
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              barGroups: List.generate(monthlyData.length, (index) {
                final data = monthlyData[index];
                return BarChartGroupData(
                  x: index,
                  barsSpace: 6,
                  barRods: [
                    BarChartRodData(
                      toY: data.income,
                      color: AppColors.success,
                      width: 14,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: data.expense,
                      color: AppColors.error,
                      width: 14,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
