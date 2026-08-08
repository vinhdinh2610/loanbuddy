import 'package:flutter/material.dart';
import 'language_screen.dart';
import 'welcome_screen.dart';
import 'success_screen.dart';

/// Quản lý luồng 3 màn hình Onboarding (Chọn ngôn ngữ -> Cảm ơn -> Hoàn tất).
/// Dùng PageView, chuyển màn chỉ qua nút bấm (không vuốt tay).
/// Hỗ trợ song ngữ Việt/Anh thật sự (không chỉ lưu lựa chọn suông) và
/// có nút quay lại ở màn 2, 3.
///
/// CÁCH DÙNG trong main.dart:
/// ```dart
/// OnboardingFlow(
///   onFinished: () {
///     // Lưu cờ "đã xem onboarding" vào shared_preferences ở đây,
///     // rồi điều hướng sang HomeScreen.
///     Navigator.of(context).pushReplacement(
///       MaterialPageRoute(builder: (_) => const HomeScreen()),
///     );
///   },
/// )
/// ```
class OnboardingFlow extends StatefulWidget {
  final VoidCallback onFinished;

  const OnboardingFlow({super.key, required this.onFinished});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _controller = PageController();

  // 'vi' hoặc 'en'. Đây là state thật (có setState) nên khi đổi sẽ
  // rebuild lại WelcomeScreen/SuccessScreen với đúng ngôn ngữ.
  String _selectedLanguage = 'vi';

  bool get _isEnglish => _selectedLanguage == 'en';

  void _goToPage(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _onLanguageSelected(String lang) {
    setState(() => _selectedLanguage = lang);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        LanguageScreen(
          onLanguageSelected: _onLanguageSelected,
          onContinue: () => _goToPage(1),
        ),
        WelcomeScreen(
          isEnglish: _isEnglish,
          onContinue: () => _goToPage(2),
          onBack: () => _goToPage(0),
        ),
        SuccessScreen(
          isEnglish: _isEnglish,
          onStart: widget.onFinished,
          onBack: () => _goToPage(1),
        ),
      ],
    );
  }
}
