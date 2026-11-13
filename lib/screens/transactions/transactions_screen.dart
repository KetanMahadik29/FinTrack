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
import '../../widgets/dialogs/add_transaction_dialog.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context, TransactionItem tx) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: Text('Are you sure you want to delete "${tx.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              context.read<TransactionProvider>().deleteTransaction(tx.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction deleted'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = ResponsiveBuilder.isDesktop(context);
    final isMobile = ResponsiveBuilder.isMobile(context);

    final txProvider = context.watch<TransactionProvider>();
    final currencySymbol = context.watch<AuthProvider>().currencySymbol;
    final filtered = txProvider.filteredTransactions;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppDimensions.md : AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transactions',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage, track, and categorize all your financial movements.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => AddTransactionDialog.show(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('New Transaction'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filters Bar Card
          ModernCard(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              children: [
                // Search field + Category filter
                if (isMobile) ...[
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => txProvider.setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Search transactions...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                txProvider.setSearchQuery('');
                              },
                            )
                          : null,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<TransactionCategory?>(
                    value: txProvider.selectedCategoryFilter,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      prefixIcon: Icon(Icons.category_outlined, size: 18),
                    ),
                    hint: const Text('All Categories'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ...TransactionCategory.values.map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.label),
                        ),
                      ),
                    ],
                    onChanged: (cat) => txProvider.setCategoryFilter(cat),
                  ),
                ] else
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) => txProvider.setSearchQuery(val),
                          decoration: InputDecoration(
                            hintText: 'Search transactions by name, payee or note...',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded),
                                    onPressed: () {
                                      _searchController.clear();
                                      txProvider.setSearchQuery('');
                                    },
                                  )
                                : null,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 4,
                        child: DropdownButtonFormField<TransactionCategory?>(
                          value: txProvider.selectedCategoryFilter,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            prefixIcon: Icon(Icons.category_outlined, size: 18),
                          ),
                          hint: const Text('All Categories'),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('All Categories'),
                            ),
                            ...TransactionCategory.values.map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.label),
                              ),
                            ),
                          ],
                          onChanged: (cat) => txProvider.setCategoryFilter(cat),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),

                // Type filter chips (All, Income, Expense)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'All (${txProvider.transactions.length})',
                        isSelected: txProvider.selectedTypeFilter == null,
                        onTap: () => txProvider.setTypeFilter(null),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Income',
                        isSelected: txProvider.selectedTypeFilter == TransactionType.income,
                        onTap: () => txProvider.setTypeFilter(TransactionType.income),
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Expense',
                        isSelected: txProvider.selectedTypeFilter == TransactionType.expense,
                        onTap: () => txProvider.setTypeFilter(TransactionType.expense),
                        color: AppColors.error,
                      ),
                      if (txProvider.searchQuery.isNotEmpty ||
                          txProvider.selectedTypeFilter != null ||
                          txProvider.selectedCategoryFilter != null) ...[
                        const SizedBox(width: 16),
                        TextButton.icon(
                          onPressed: () {
                            _searchController.clear();
                            txProvider.clearFilters();
                          },
                          icon: const Icon(Icons.filter_alt_off_rounded, size: 16),
                          label: const Text('Clear Filters'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Transaction List / Table
          if (filtered.isEmpty)
            ModernCard(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long_outlined,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No transactions found',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Try tweaking your search or filter options, or add a new transaction.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (isDesktop)
            // Desktop Styled Table
            ModernCard(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                child: DataTable(
                  horizontalMargin: 24,
                  columnSpacing: 28,
                  headingRowColor: WidgetStateProperty.all(
                    isDark ? const Color(0xFF162032) : AppColors.surfaceMuted,
                  ),
                  columns: const [
                    DataColumn(label: Text('Transaction / Payee', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.w700))),
                    DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700))),
                  ],
                  rows: filtered.map((tx) {
                    final isIncome = tx.type == TransactionType.income;

                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: tx.category.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(tx.category.icon, size: 16, color: tx.category.color),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    tx.title,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                  if (tx.notes != null && tx.notes!.isNotEmpty)
                                    Text(
                                      tx.notes!,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(tx.category.label, style: const TextStyle(fontSize: 13))),
                        DataCell(Text(Formatters.date(tx.date), style: const TextStyle(fontSize: 13))),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isIncome
                                  ? AppColors.success.withOpacity(0.1)
                                  : AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isIncome ? 'Income' : 'Expense',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isIncome ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${isIncome ? '+' : '-'}${Formatters.currency(tx.amount, symbol: currencySymbol)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isIncome ? AppColors.success : AppColors.error,
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                tooltip: 'Edit',
                                onPressed: () => AddTransactionDialog.show(context, transaction: tx),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                color: AppColors.error,
                                tooltip: 'Delete',
                                onPressed: () => _confirmDelete(context, tx),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            )
          else
            // Tablet & Mobile Responsive Card List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tx = filtered[index];
                final isIncome = tx.type == TransactionType.income;

                return ModernCard(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: tx.category.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(tx.category.icon, color: tx.category.color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.title,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${tx.category.label} • ${Formatters.date(tx.date)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                              ),
                            ),
                            if (tx.notes != null && tx.notes!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                tx.notes!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${isIncome ? '+' : '-'}${Formatters.currency(tx.amount, symbol: currencySymbol)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isIncome ? AppColors.success : AppColors.error,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => AddTransactionDialog.show(context, transaction: tx),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                color: AppColors.error,
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _confirmDelete(context, tx),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final activeColor = color ?? AppColors.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withOpacity(0.15)
              : (isDark ? const Color(0xFF162032) : AppColors.surfaceMuted),
          border: Border.all(
            color: isSelected ? activeColor : (isDark ? AppColors.darkBorder : AppColors.border),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? activeColor : (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
          ),
        ),
      ),
    );
  }
}
