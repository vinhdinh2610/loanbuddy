import 'package:flutter/material.dart';
import '../../theme/onboarding_theme.dart';
import 'primary_button.dart';

/// Popup cho phép người dùng bật/tắt quảng cáo cá nhân hoá (song ngữ Việt/Anh).
class ManageOptionsDialog extends StatefulWidget {
  final bool isEnglish;
  final bool initialValue;
  final ValueChanged<bool> onSave;

  const ManageOptionsDialog({
    super.key,
    required this.isEnglish,
    required this.onSave,
    this.initialValue = true,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isEnglish,
    required ValueChanged<bool> onSave,
    bool initialValue = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ManageOptionsDialog(
        isEnglish: isEnglish,
        onSave: onSave,
        initialValue: initialValue,
      ),
    );
  }

  @override
  State<ManageOptionsDialog> createState() => _ManageOptionsDialogState();
}

class _ManageOptionsDialogState extends State<ManageOptionsDialog> {
  late bool _personalizedAds = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final isEnglish = widget.isEnglish;
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
              child: const Icon(Icons.tune, color: OnboardingColors.accent),
            ),
            const SizedBox(height: 16),
            Text(
              isEnglish ? 'Manage Options' : 'Quản lý tùy chọn',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: OnboardingColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              isEnglish
                  ? 'Choose whether ads shown in LoanBuddy can be personalized based on your activity.'
                  : 'Chọn xem quảng cáo hiển thị trong LoanBuddy có được cá nhân hoá dựa trên hoạt động của bạn hay không.',
              style: OnboardingTextStyles.body,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: OnboardingColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: OnboardingColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isEnglish ? 'Personalized ads' : 'Quảng cáo cá nhân hoá',
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: OnboardingColors.textPrimary),
                    ),
                  ),
                  Switch(
                    value: _personalizedAds,
                    activeColor: OnboardingColors.accent,
                    onChanged: (v) => setState(() => _personalizedAds = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: isEnglish ? 'Save choice' : 'Lưu lựa chọn',
              onPressed: () => widget.onSave(_personalizedAds),
            ),
          ],
        ),
      ),
    );
  }
}
