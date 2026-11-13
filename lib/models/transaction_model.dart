import 'package:flutter/material.dart';

enum TransactionType { income, expense }

enum TransactionCategory {
  salary('Salary', Icons.work_outline, Color(0xFF10B981)),
  freelance('Freelance', Icons.computer_outlined, Color(0xFF06B6D4)),
  investment('Investment', Icons.trending_up, Color(0xFF8B5CF6)),
  food('Food & Dining', Icons.restaurant_outlined, Color(0xFFF59E0B)),
  shopping('Shopping', Icons.shopping_bag_outlined, Color(0xFFEC4899)),
  bills('Bills & Utilities', Icons.receipt_long_outlined, Color(0xFFEF4444)),
  entertainment('Entertainment', Icons.movie_outlined, Color(0xFF6366F1)),
  transport('Transport', Icons.directions_car_outlined, Color(0xFF3B82F6)),
  health('Health & Medical', Icons.favorite_outline, Color(0xFF14B8A6)),
  education('Education', Icons.school_outlined, Color(0xFF84CC16)),
  other('Other', Icons.category_outlined, Color(0xFF64748B));

  final String label;
  final IconData icon;
  final Color color;

  const TransactionCategory(this.label, this.icon, this.color);

  static TransactionCategory fromString(String val) {
    return TransactionCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase() || e.label.toLowerCase() == val.toLowerCase(),
      orElse: () => TransactionCategory.other,
    );
  }
}

class TransactionItem {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;
  final String? notes;

  TransactionItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
  });

  TransactionItem copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
    String? notes,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'category': category.name,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      category: TransactionCategory.fromString(json['category'] as String? ?? 'other'),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
    );
  }
}
