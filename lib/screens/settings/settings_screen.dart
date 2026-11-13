import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/responsive_builder.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/cards/modern_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar (\$)'},
    {'code': 'EUR', 'symbol': '€', 'name': 'Euro (€)'},
    {'code': 'GBP', 'symbol': '£', 'name': 'British Pound (£)'},
    {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee (₹)'},
    {'code': 'CAD', 'symbol': 'CA\$', 'name': 'Canadian Dollar (CA\$)'},
    {'code': 'AUD', 'symbol': 'AU\$', 'name': 'Australian Dollar (AU\$)'},
    {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen (¥)'},
  ];

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _nameController = TextEditingController(text: auth.user.name);
    _emailController = TextEditingController(text: auth.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthProvider>().updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _resetDemoData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Demo Data?'),
        content: const Text(
          'This will restore all default transactions and categories. Any custom changes will be replaced with fresh sample data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reset Data'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      await context.read<TransactionProvider>().resetToDemoData();
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Transactions reset to sample demo data'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = ResponsiveBuilder.isMobile(context);
    final auth = context.watch<AuthProvider>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppDimensions.md : AppDimensions.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Settings & Preferences',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Customize your account profile, currency, theme, and data.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),

            // Profile Card
            ModernCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: Text(
                            auth.user.name.isNotEmpty ? auth.user.name[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              fontSize: 22,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.user.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              auth.user.email,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    Text('Full Name', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 16),

                    Text('Email Address', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                      validator: (val) =>
                          val == null || !val.contains('@') ? 'Please enter valid email' : null,
                    ),
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        child: const Text('Save Profile Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App Preferences Card (Theme & Currency)
            ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application Preferences',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Currency Dropdown
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.payments_outlined, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Currency Display', style: TextStyle(fontWeight: FontWeight.w600)),
                            Text(
                              'Format balances and transactions with this currency',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: auth.currencyCode,
                        underline: const SizedBox.shrink(),
                        items: _currencies.map((curr) {
                          return DropdownMenuItem<String>(
                            value: curr['code'],
                            child: Text(curr['name']!),
                          );
                        }).toList(),
                        onChanged: (newCode) {
                          if (newCode != null) {
                            final match = _currencies.firstWhere((c) => c['code'] == newCode);
                            auth.updateCurrency(match['code']!, match['symbol']!);
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Theme Toggle
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.dark_mode_outlined, color: Color(0xFFF59E0B), size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Dark Mode Appearance', style: TextStyle(fontWeight: FontWeight.w600)),
                            Text(
                              'Switch between light and dark visual themes',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: auth.isDarkMode,
                        activeColor: AppColors.primary,
                        onChanged: (val) => auth.toggleDarkMode(val),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Data Management & Session Card
            ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data & Session',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.refresh_rounded, color: AppColors.info, size: 20),
                    ),
                    title: const Text('Reset Sample Demo Data', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Re-seed the initial income and expense transactions'),
                    trailing: OutlinedButton(
                      onPressed: _resetDemoData,
                      child: const Text('Reset'),
                    ),
                  ),
                  const Divider(height: 24),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                    ),
                    title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.error)),
                    subtitle: const Text('End your session and return to the login screen'),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                      onPressed: () => auth.logout(),
                      child: const Text('Log Out'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
