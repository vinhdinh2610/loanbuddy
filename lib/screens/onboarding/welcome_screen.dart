import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/onboarding_theme.dart';
import '../../widgets/onboarding/primary_button.dart';
import '../../widgets/onboarding/page_indicator.dart';
import '../../widgets/onboarding/consent_dialog.dart';
import '../../widgets/onboarding/manage_options_dialog.dart';

const _personalizedAdsKey = 'personalized_ads_enabled';

/// Màn hình 2: Cảm ơn + thông báo quảng cáo (song ngữ Việt/Anh)
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final bool isEnglish;

  const WelcomeScreen({
    super.key,
    required this.onContinue,
    required this.onBack,
    required this.isEnglish,
  });

  Future<void> _savePersonalizedAds(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_personalizedAdsKey, enabled);
  }

  void _handleContinue(BuildContext context) {
    ConsentDialog.show(
      context,
      isEnglish: isEnglish,
      onAgree: () async {
        Navigator.of(context).pop();
        await _savePersonalizedAds(true);
        onContinue();
      },
      onManageOptions: () {
        Navigator.of(context).pop();
        ManageOptionsDialog.show(
          context,
          isEnglish: isEnglish,
          onSave: (enabled) async {
            Navigator.of(context).pop();
            await _savePersonalizedAds(enabled);
            onContinue();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnboardingColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, color: OnboardingColors.textPrimary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/AppIcon.png',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: isEnglish ? 'Thank you for choosing\n' : 'Cảm ơn bạn đã tin tưởng\n',
                      style: const TextStyle(color: OnboardingColors.textPrimary),
                    ),
                    const TextSpan(text: 'Loan', style: TextStyle(color: OnboardingColors.primary)),
                    const TextSpan(text: 'Buddy', style: TextStyle(color: OnboardingColors.accent)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isEnglish
                    ? 'LoanBuddy helps you calculate loans, compare repayment plans, track repayment schedules, and make smarter financial decisions.'
                    : 'LoanBuddy giúp bạn tính toán khoản vay, so sánh phương án trả nợ, theo dõi lịch trả nợ và đưa ra quyết định tài chính thông minh hơn.',
                textAlign: TextAlign.center,
                style: OnboardingTextStyles.body,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: OnboardingColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: OnboardingColors.accent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: OnboardingColors.accent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isEnglish
                            ? 'This app is supported by ads to keep the service free for you.'
                            : 'Ứng dụng có quảng cáo để duy trì dịch vụ miễn phí này cho bạn.',
                        style: const TextStyle(fontSize: 12.5, color: OnboardingColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: isEnglish ? 'Continue' : 'Tiếp tục',
                onPressed: () => _handleContinue(context),
              ),
              const SizedBox(height: 24),
              const PageIndicator(currentIndex: 1, totalPages: 3),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
