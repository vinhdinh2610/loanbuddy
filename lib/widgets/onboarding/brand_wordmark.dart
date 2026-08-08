import 'package:flutter/material.dart';
import '../../theme/onboarding_theme.dart';

/// Hiển thị chữ "LoanBuddy" với "Loan" màu xanh lá và "Buddy" màu vàng gold.
/// Dùng ở bất kỳ đâu cần hiện tên app dạng chữ (logo screen, header, v.v).
class BrandWordmark extends StatelessWidget {
  final double fontSize;
  final FontWeight fontWeight;

  const BrandWordmark({
    super.key,
    this.fontSize = 32,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        children: const [
          TextSpan(text: 'Loan', style: TextStyle(color: OnboardingColors.primary)),
          TextSpan(text: 'Buddy', style: TextStyle(color: OnboardingColors.accent)),
        ],
      ),
    );
  }
}
