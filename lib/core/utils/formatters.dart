import 'package:intl/intl.dart';

class Formatters {
  static String currency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String compactCurrency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.compactCurrency(
      symbol: symbol,
      decimalDigits: 1,
    );
    return formatter.format(amount);
  }

  static String date(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  static String dateWithTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  static String monthYear(DateTime dateTime) {
    return DateFormat('MMMM yyyy').format(dateTime);
  }

  static String percentage(double val) {
    return '${val >= 0 ? '+' : ''}${val.toStringAsFixed(1)}%';
  }
}
