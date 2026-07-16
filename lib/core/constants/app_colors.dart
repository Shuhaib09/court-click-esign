import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevents creating instances of this class

  static const Color primary = Color(0xFF4A0E2E);      // dark maroon (headers, buttons)
  static const Color primaryLight = Color(0xFF6B1B47);
  static const Color background = Color(0xFFF5F5F7);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF8A8A8E);

  static const Color success = Color(0xFF2ECC71);   // Signed / Success states
  static const Color pending = Color(0xFFF5A623);   // Pending states
  static const Color failed = Color(0xFFE74C3C);    // Failed states

  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFill = Color(0xFFFAFAFA);
}