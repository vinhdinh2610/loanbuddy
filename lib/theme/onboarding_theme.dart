import 'package:flutter/material.dart';

/// Bảng màu cho luồng Onboarding của LoanBuddy
/// Phong cách: Minimal & Elegant - Xanh đậm chủ đạo + Vàng gold làm điểm nhấn
class OnboardingColors {
  static const Color primary = Color(0xFF1B4332); // Xanh đậm
  static const Color accent = Color(0xFFD4AF37); // Vàng gold
  static const Color background = Color(0xFFF4F1EA); // Nền kem nhạt
  static const Color card = Color(0xFFFFFFFF); // Thẻ trắng
  static const Color textPrimary = Color(0xFF1B4332);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E0D5);
}

/// Typography theo spec: Title 32 Bold, Subtitle 18 Medium, Body 16 Regular, Button 18 SemiBold
class OnboardingTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: OnboardingColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: OnboardingColors.textSecondary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: OnboardingColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: OnboardingColors.accent,
  );
}
