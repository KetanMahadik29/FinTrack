import '../models/transaction_model.dart';
import '../models/user_model.dart';

class DemoData {
  static UserModel defaultUser = UserModel(
    id: 'demo_user',
    name: 'Alex Johnson',
    email: 'alex.fintrack@demo.io',
    currencyCode: 'USD',
    currencySymbol: '\$',
  );

  static List<TransactionItem> getSampleTransactions() {
    final now = DateTime.now();

    return [
      TransactionItem(
        id: 'tx_1',
        title: 'Monthly Tech Salary',
        amount: 5400.00,
        type: TransactionType.income,
        category: TransactionCategory.salary,
        date: now.subtract(const Duration(days: 2)),
        notes: 'Monthly direct deposit from Acme Corp',
      ),
      TransactionItem(
        id: 'tx_2',
        title: 'Modern Apartment Rent',
        amount: 1450.00,
        type: TransactionType.expense,
        category: TransactionCategory.bills,
        date: now.subtract(const Duration(days: 3)),
        notes: 'November rent payment',
      ),
      TransactionItem(
        id: 'tx_3',
        title: 'Whole Foods Grocery Store',
        amount: 184.50,
        type: TransactionType.expense,
        category: TransactionCategory.food,
        date: now.subtract(const Duration(days: 4)),
        notes: 'Organic groceries & weekly essentials',
      ),
      TransactionItem(
        id: 'tx_4',
        title: 'UI/UX Client Project',
        amount: 1250.00,
        type: TransactionType.income,
        category: TransactionCategory.freelance,
        date: now.subtract(const Duration(days: 5)),
        notes: 'Milestone 2 payment for dashboard redesign',
      ),
      TransactionItem(
        id: 'tx_5',
        title: 'Electric & High-Speed Internet',
        amount: 142.20,
        type: TransactionType.expense,
        category: TransactionCategory.bills,
        date: now.subtract(const Duration(days: 7)),
        notes: 'Utility bill auto-pay',
      ),
      TransactionItem(
        id: 'tx_6',
        title: 'Dividend Payout (VTI ETF)',
        amount: 320.00,
        type: TransactionType.income,
        category: TransactionCategory.investment,
        date: now.subtract(const Duration(days: 8)),
        notes: 'Quarterly index fund distribution',
      ),
      TransactionItem(
        id: 'tx_7',
        title: 'Dining out with Friends',
        amount: 98.75,
        type: TransactionType.expense,
        category: TransactionCategory.food,
        date: now.subtract(const Duration(days: 9)),
        notes: 'Italian dinner on Friday night',
      ),
      TransactionItem(
        id: 'tx_8',
        title: 'Nike Running Gear & Sneakers',
        amount: 165.00,
        type: TransactionType.expense,
        category: TransactionCategory.shopping,
        date: now.subtract(const Duration(days: 11)),
        notes: 'Marathon training shoes',
      ),
      TransactionItem(
        id: 'tx_9',
        title: 'Subway & Uber Commute',
        amount: 64.30,
        type: TransactionType.expense,
        category: TransactionCategory.transport,
        date: now.subtract(const Duration(days: 12)),
        notes: 'Weekly transit recharge',
      ),
      TransactionItem(
        id: 'tx_10',
        title: 'Online Cloud Computing Course',
        amount: 89.99,
        type: TransactionType.expense,
        category: TransactionCategory.education,
        date: now.subtract(const Duration(days: 14)),
        notes: 'Certification prep course',
      ),
      TransactionItem(
        id: 'tx_11',
        title: 'Cinema & Streaming Services',
        amount: 45.00,
        type: TransactionType.expense,
        category: TransactionCategory.entertainment,
        date: now.subtract(const Duration(days: 16)),
        notes: 'IMAX tickets & Netflix bundle',
      ),
      TransactionItem(
        id: 'tx_12',
        title: 'Dental Checkup & Cleaning',
        amount: 120.00,
        type: TransactionType.expense,
        category: TransactionCategory.health,
        date: now.subtract(const Duration(days: 20)),
        notes: 'Routine 6-month checkup',
      ),
    ];
  }
}
