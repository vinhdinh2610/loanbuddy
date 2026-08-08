import 'package:flutter/material.dart';
import '../../theme/onboarding_theme.dart';

/// Chấm tròn hiển thị vị trí hiện tại trong luồng onboarding (VD: ● ○ ○)
class PageIndicator extends StatelessWidget {
  final int currentIndex; // bắt đầu từ 0
  final int totalPages;

  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? OnboardingColors.primary : OnboardingColors.border,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
