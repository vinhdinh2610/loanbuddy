import 'package:flutter/material.dart';
import '../../theme/onboarding_theme.dart';

/// Thẻ chọn ngôn ngữ dạng radio card (VD: 🇻🇳 Tiếng Việt)
class LanguageCard extends StatelessWidget {
  final String flagEmoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCard({
    super.key,
    required this.flagEmoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: OnboardingColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? OnboardingColors.primary : OnboardingColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(flagEmoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? OnboardingColors.primary : OnboardingColors.border,
            ),
          ],
        ),
      ),
    );
  }
}
