import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/transaction_provider.dart';

class CategoryPieChart extends StatefulWidget {
  final List<CategorySpendData> categoryData;
  final String currencySymbol;

  const CategoryPieChart({
    super.key,
    required this.categoryData,
    required this.currencySymbol,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.categoryData.isEmpty) {
      return Center(
        child: Text(
          'No expense data to analyze yet',
          style: TextStyle(
            color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
          ),
        ),
      );
    }

    final topCategories = widget.categoryData.take(5).toList();

    return Column(
      children: [
        // Pie / Donut Chart
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      _touchedIndex = -1;
                      return;
                    }
                    _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 3,
              centerSpaceRadius: 46,
              sections: List.generate(topCategories.length, (i) {
                final isTouched = i == _touchedIndex;
                final data = topCategories[i];
                final radius = isTouched ? 48.0 : 40.0;

                return PieChartSectionData(
                  color: data.category.color,
                  value: data.amount,
                  title: '${data.percentage.toStringAsFixed(0)}%',
                  radius: radius,
                  titleStyle: TextStyle(
                    fontSize: isTouched ? 13 : 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Legend list
        ...topCategories.map((data) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: data.category.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.category.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkText : AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  Formatters.currency(data.amount, symbol: widget.currencySymbol),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.text,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${data.percentage.toStringAsFixed(0)}%)',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
