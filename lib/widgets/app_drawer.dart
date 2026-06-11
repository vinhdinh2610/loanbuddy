import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/history_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/feedback_screen.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  const AppDrawer({super.key, required this.currentIndex});

  static const _gold = Color(0xFFE8A020);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App branding
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/images/AppIcon.png',
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Tên + slogan
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Loan',
                                  style: TextStyle(color: Color(0xFF1B4332)),
                                ),
                                TextSpan(
                                  text: 'Buddy',
                                  style: TextStyle(color: Color(0xFFE8A020)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Vay thông minh, Tương lai vững vàng',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF888888),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade100),
            const SizedBox(height: 8),

            // Trang chủ
            _menuItem(context,
                icon: Icons.home_outlined,
                label: 'Trang chủ',
                index: 0,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }),

            // Lịch sử
            _menuItem(context,
                icon: Icons.history_outlined,
                label: 'Lịch sử tra cứu',
                index: 1,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HistoryScreen()));
                }),

            // Cài đặt
            _menuItem(context,
                icon: Icons.settings_outlined,
                label: 'Cài đặt',
                index: 2,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SettingsScreen()));
                }),

            // Góp ý
            _menuItem(context,
                icon: Icons.feedback_outlined,
                label: 'Góp ý',
                index: 3,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FeedbackScreen()));
                }),

            const Spacer(),
            Divider(height: 1, color: Colors.grey.shade100),
            const SizedBox(height: 4),

            // Chính sách bảo mật
            _menuItem(context,
                icon: Icons.privacy_tip_outlined,
                label: 'Chính sách bảo mật',
                index: 99,
                onTap: () async {
                  Navigator.pop(context);
                  final uri = Uri.parse(
                      'https://loanbuddy-privacy.tiiny.site');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }),

            // Điều khoản sử dụng
            _menuItem(context,
                icon: Icons.description_outlined,
                label: 'Điều khoản sử dụng',
                index: 100,
                onTap: () async {
                  Navigator.pop(context);
                  final uri = Uri.parse(
                      'https://doc-hosting.flycricket.io/loanbuddy-terms-of-use/e443fea3-5a2c-4500-a68b-fe19a0aa13f2/terms');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }),

            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                'LoanBuddy v1.0.0',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _gold.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(icon,
              size: 20,
              color: isSelected ? _gold : const Color(0xFF1B4332)),
          const SizedBox(width: 14),
          Text(label,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFF1B4332))),
        ]),
      ),
    );
  }
}