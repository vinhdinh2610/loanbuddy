import 'package:flutter/material.dart';
import '../../theme/onboarding_theme.dart';
import '../../widgets/onboarding/primary_button.dart';
import '../../widgets/onboarding/page_indicator.dart';

/// Màn hình 3: Hoàn tất, sẵn sàng vào Trang chủ (song ngữ Việt/Anh)
class SuccessScreen extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onBack;
  final bool isEnglish;

  const SuccessScreen({
    super.key,
    required this.onStart,
    required this.onBack,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnboardingColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, color: OnboardingColors.textPrimary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const Spacer(flex: 2),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: OnboardingColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: OnboardingColors.accent, size: 52),
              ),
              const SizedBox(height: 24),
              Text(
                isEnglish ? "You're all set!" : 'Tất cả đã sẵn sàng!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: OnboardingColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                isEnglish ? 'Start calculating your loans now' : 'Bắt đầu tính toán khoản vay của bạn ngay',
                textAlign: TextAlign.center,
                style: OnboardingTextStyles.body,
              ),
              const Spacer(flex: 3),
              PrimaryButton(label: isEnglish ? 'Start' : 'Bắt đầu', onPressed: onStart),
              const SizedBox(height: 24),
              const PageIndicator(currentIndex: 2, totalPages: 3),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
