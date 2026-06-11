import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'feedback_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);
  static const _darkGreen = Color(0xFF1B4332);

  String _language = 'vi';

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Chức năng đang trong quá trình hoàn thiện'),
        backgroundColor: const Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('Chọn ngôn ngữ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _langOption('vi', '🇻🇳', 'Tiếng Việt'),
          const SizedBox(height: 10),
          _langOption('en', '🇬🇧', 'English'),
        ]),
      ),
    );
  }

  Widget _langOption(String code, String flag, String label) {
    final selected = _language == code;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (code != 'vi') {
          _showComingSoon();
        } else {
          setState(() => _language = code);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
            color: selected ? _gold.withOpacity(0.08) : const Color(0xFFF5F0E8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: selected ? _gold.withOpacity(0.4) : Colors.transparent)),
        child: Row(children: [
          Text(flag, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFF444444)))),
          if (selected)
            const Icon(Icons.check_rounded, color: _gold, size: 20),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          const Text('Cài Đặt',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 24),

          // Ngôn ngữ
          _sectionLabel('Ngôn ngữ'),
          _settingCard(children: [
            _settingRow(
              icon: Icons.language_outlined,
              label: 'Ngôn ngữ',
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(_language == 'vi' ? 'Tiếng Việt' : 'English',
                    style: const TextStyle(
                        fontSize: 13,
                        color: _gold,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                const Icon(Icons.unfold_more_rounded, color: _gold, size: 16),
              ]),
              onTap: _showLanguagePicker,
            ),
          ]),

          const SizedBox(height: 20),

          // Hỗ trợ
          _sectionLabel('Hỗ trợ'),
          _settingCard(children: [
            _settingRow(
              icon: Icons.workspace_premium_outlined,
              iconColor: _gold,
              label: 'Nâng cấp Pro',
              labelColor: _gold,
              onTap: _showComingSoon,
            ),
            _divider(),
            _settingRow(
              icon: Icons.feedback_outlined,
              iconColor: _darkGreen,
              label: 'Góp ý',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FeedbackScreen())),
            ),
            _divider(),
            _settingRow(
              icon: Icons.info_outline_rounded,
              label: 'Giới thiệu ứng dụng',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _AboutScreen())),
            ),
          ]),

          const SizedBox(height: 20),

          // Pháp lý
          _sectionLabel('Pháp lý'),
          _settingCard(children: [
            _settingRow(
              icon: Icons.privacy_tip_outlined,
              iconColor: _darkGreen,
              label: 'Chính sách bảo mật',
              onTap: () async {
                final uri = Uri.parse(
                    'https://loanbuddy-privacy.tiiny.site');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
            _divider(),
            _settingRow(
              icon: Icons.description_outlined,
              iconColor: _darkGreen,
              label: 'Điều khoản sử dụng',
              onTap: () async {
                final uri = Uri.parse(
                    'https://doc-hosting.flycricket.io/loanbuddy-terms-of-use/e443fea3-5a2c-4500-a68b-fe19a0aa13f2/terms');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ]),

          const SizedBox(height: 20),

          // Phiên bản
          Center(
            child: Text('LoanBuddy v1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(text,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888))),
      );

  Widget _settingCard({required List<Widget> children}) => Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(children: children),
      );

  Widget _divider() => Divider(
      height: 1,
      thickness: 0.5,
      indent: 52,
      endIndent: 16,
      color: Colors.grey.shade100);

  Widget _settingRow({
    required IconData icon,
    required String label,
    Color? iconColor,
    Color? labelColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          color: Colors.transparent,
          child: Row(children: [
            Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: (iconColor ?? const Color(0xFF888888))
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon,
                    color: iconColor ?? const Color(0xFF888888), size: 18)),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: labelColor ?? const Color(0xFF1A1A1A)))),
            trailing ??
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: Colors.grey.shade400),
          ]),
        ),
      );
}

// ─── About Screen ─────────────────────────────────────────────
class _AboutScreen extends StatelessWidget {
  const _AboutScreen();
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(22)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  'assets/images/AppIcon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                children: [
                  TextSpan(
                      text: 'Loan',
                      style: TextStyle(color: Color(0xFF1B4332))),
                  TextSpan(
                      text: 'Buddy',
                      style: TextStyle(color: Color(0xFFE8A020))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text('Phiên bản 1.0.0',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Text(
              'LoanBuddy giúp bạn tính toán lịch trả nợ, so sánh các khoản vay và đánh giá sức khỏe tài chính một cách thông minh và trực quan.\n\nỨng dụng được thiết kế dành riêng cho thị trường Việt Nam, hỗ trợ cả vay thế chấp lẫn vay tín chấp với đầy đủ các tính năng chuyên nghiệp.',
              style: TextStyle(
                  fontSize: 14, color: Color(0xFF555555), height: 1.6),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              _feature(Icons.home_outlined, 'Tính lãi vay thế chấp'),
              _feature(Icons.account_balance_wallet_outlined,
                  'Tính lãi vay tín chấp'),
              _feature(Icons.compare_arrows_rounded, 'So sánh khoản vay'),
              _feature(Icons.favorite_outline_rounded,
                  'Đánh giá sức khỏe tài chính'),
              _feature(Icons.history_rounded, 'Lưu lịch sử tra cứu'),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _feature(IconData icon, String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: _gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: _gold, size: 17)),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  fontSize: 14, color: Color(0xFF444444))),
        ]),
      );
}