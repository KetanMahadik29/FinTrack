import 'package:flutter/material.dart';

class AppColors {
  // Brand colors from context.md
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF8B80F9);
  static const Color background = Color(0xFFF7F8FC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF202238);
  static const Color success = Color(0xFF16A34A);
  static const Color error = Color(0xFFDC4545);

  // Additional supporting colors for modern SaaS UI
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color surfaceMuted = Color(0xFFF1F5F9);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkTextMuted = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  // Gradient accents
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC4545)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
