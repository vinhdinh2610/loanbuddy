import 'package:flutter/material.dart';
import '../../theme/onboarding_theme.dart';
import 'primary_button.dart';

/// Popup xin phép hiển thị quảng cáo cá nhân hoá (song ngữ Việt/Anh).
///
/// LƯU Ý QUAN TRỌNG: Đây là giao diện minh hoạ luồng UI.
/// Khi tích hợp AdMob thật, nên dùng Google UMP SDK (User Messaging Platform)
/// thay vì popup tự thiết kế này, để đảm bảo tuân thủ đúng chính sách quảng cáo
/// và tự động hiển thị đúng nội dung theo luật từng khu vực (VD: GDPR ở châu Âu).
class ConsentDialog extends StatelessWidget {
  final VoidCallback onAgree;
  final VoidCallback onManageOptions;
  final bool isEnglish;

  const ConsentDialog({
    super.key,
    required this.onAgree,
    required this.onManageOptions,
    required this.isEnglish,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onAgree,
    required VoidCallback onManageOptions,
    required bool isEnglish,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConsentDialog(
        onAgree: onAgree,
        onManageOptions: onManageOptions,
        isEnglish: isEnglish,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: OnboardingColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: OnboardingColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.shield_outlined, color: OnboardingColors.accent),
            ),
            const SizedBox(height: 16),
            Text(
              isEnglish ? 'Your Privacy' : 'Quyền riêng tư của bạn',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: OnboardingColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              isEnglish
                  ? 'LoanBuddy and our advertising partners use data to personalize ads and improve your experience.'
                  : 'LoanBuddy và các đối tác quảng cáo dùng dữ liệu để cá nhân hoá quảng cáo và cải thiện trải nghiệm của bạn.',
              style: OnboardingTextStyles.body,
            ),
            const SizedBox(height: 20),
            PrimaryButton(label: isEnglish ? 'Agree' : 'Đồng ý', onPressed: onAgree),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: onManageOptions,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: OnboardingColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  isEnglish ? 'Manage Options' : 'Quản lý tùy chọn',
                  style: const TextStyle(fontSize: 16, color: OnboardingColors.textPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
