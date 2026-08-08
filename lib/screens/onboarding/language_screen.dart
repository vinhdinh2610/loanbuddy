import 'package:flutter/material.dart';
import '../../theme/onboarding_theme.dart';
import '../../widgets/onboarding/language_card.dart';
import '../../widgets/onboarding/primary_button.dart';
import '../../widgets/onboarding/page_indicator.dart';
import '../../widgets/onboarding/brand_wordmark.dart';

/// Màn hình 1: Chọn ngôn ngữ
class LanguageScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final ValueChanged<String> onLanguageSelected; // 'vi' hoặc 'en'

  const LanguageScreen({
    super.key,
    required this.onContinue,
    required this.onLanguageSelected,
  });

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = 'vi'; // mặc định Tiếng Việt

  bool get _isEnglish => _selected == 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnboardingColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/AppIcon.png',
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const BrandWordmark(fontSize: 32, fontWeight: FontWeight.bold),
              const SizedBox(height: 6),
              Text(
                _isEnglish ? 'Smart loan assistant' : 'Trợ lý vay thông minh',
                style: OnboardingTextStyles.subtitle,
              ),
              const Spacer(flex: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _isEnglish ? 'Choose language' : 'Chọn ngôn ngữ',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: OnboardingColors.textPrimary),
                ),
              ),
              const SizedBox(height: 12),
              LanguageCard(
                flagEmoji: '🇻🇳',
                label: 'Tiếng Việt',
                isSelected: _selected == 'vi',
                onTap: () => setState(() => _selected = 'vi'),
              ),
              const SizedBox(height: 10),
              LanguageCard(
                flagEmoji: '🇺🇸',
                label: 'English',
                isSelected: _selected == 'en',
                onTap: () => setState(() => _selected = 'en'),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: _isEnglish ? 'Continue' : 'Tiếp tục',
                onPressed: () {
                  widget.onLanguageSelected(_selected);
                  widget.onContinue();
                },
              ),
              const SizedBox(height: 24),
              const PageIndicator(currentIndex: 0, totalPages: 3),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
