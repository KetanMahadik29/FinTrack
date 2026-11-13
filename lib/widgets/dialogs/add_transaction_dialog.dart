import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/formatters.dart';
import '../../models/transaction_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';

class AddTransactionDialog extends StatefulWidget {
  final TransactionItem? initialTransaction;

  const AddTransactionDialog({super.key, this.initialTransaction});

  static Future<void> show(BuildContext context, {TransactionItem? transaction}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AddTransactionDialog(initialTransaction: transaction),
    );
  }

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;

  late TransactionType _type;
  late TransactionCategory _category;
  late DateTime _selectedDate;

  bool get _isEditing => widget.initialTransaction != null;

  @override
  void initState() {
    super.initState();
    final tx = widget.initialTransaction;
    _titleController = TextEditingController(text: tx?.title ?? '');
    _amountController = TextEditingController(
      text: tx != null ? tx.amount.toStringAsFixed(2) : '',
    );
    _notesController = TextEditingController(text: tx?.notes ?? '');
    _type = tx?.type ?? TransactionType.expense;
    _category = tx?.category ?? TransactionCategory.food;
    _selectedDate = tx?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final parsedAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an amount greater than 0'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final txProvider = context.read<TransactionProvider>();

    if (_isEditing) {
      final updated = widget.initialTransaction!.copyWith(
        title: _titleController.text.trim(),
        amount: parsedAmount,
        type: _type,
        category: _category,
        date: _selectedDate,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      txProvider.updateTransaction(updated);
    } else {
      final newTx = TransactionItem(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        amount: parsedAmount,
        type: _type,
        category: _category,
        date: _selectedDate,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      txProvider.addTransaction(newTx);
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Transaction updated successfully' : 'Transaction added successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currencySymbol = context.watch<AuthProvider>().currencySymbol;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isEditing ? 'Edit Transaction' : 'New Transaction',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Transaction Type Segmented Toggle (Income / Expense)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF162032) : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTypeOption(
                          type: TransactionType.expense,
                          label: 'Expense',
                          icon: Icons.arrow_downward_rounded,
                          activeColor: AppColors.error,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _buildTypeOption(
                          type: TransactionType.income,
                          label: 'Income',
                          icon: Icons.arrow_upward_rounded,
                          activeColor: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Amount Field
                Text(
                  'Amount ($currencySymbol)',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Center(
                        widthFactor: 0.0,
                        child: Text(
                          currencySymbol,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                    hintText: '0.00',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Title Field
                Text('Title / Payee', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Grocery Shopping, Freelance Gig',
                    prefixIcon: Icon(Icons.edit_note_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                Text('Category', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                DropdownButtonFormField<TransactionCategory>(
                  value: _category,
                  dropdownColor: isDark ? AppColors.darkCardBackground : Colors.white,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: TransactionCategory.values.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Row(
                        children: [
                          Icon(cat.icon, size: 18, color: cat.color),
                          const SizedBox(width: 10),
                          Text(cat.label),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newCat) {
                    if (newCat != null) setState(() => _category = newCat);
                  },
                ),
                const SizedBox(height: 16),

                // Date Picker field
                Text('Date', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      color: isDark ? const Color(0xFF162032) : Colors.white,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text(
                          Formatters.date(_selectedDate),
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down, color: AppColors.textLight),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes Field
                Text('Notes (Optional)', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Additional details or receipt notes...',
                  ),
                ),
                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _type == TransactionType.income
                            ? AppColors.success
                            : AppColors.primary,
                      ),
                      child: Text(_isEditing ? 'Save Changes' : 'Add Transaction'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeOption({
    required TransactionType type,
    required String label,
    required IconData icon,
    required Color activeColor,
  }) {
    final isSelected = _type == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => setState(() => _type = type),
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? activeColor.withOpacity(0.25) : activeColor.withOpacity(0.12))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: isSelected ? Border.all(color: activeColor, width: 1.5) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? activeColor : (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
