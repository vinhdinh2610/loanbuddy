import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
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

  void _showComingSoon(AppLocalizations l) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.featureComingSoon),
        backgroundColor: const Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLanguagePicker(AppLocalizations l) {
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
          Text(l.settingsChooseLanguage,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _langOption('vi', '🇻🇳', l.settingsLangVietnamese),
          const SizedBox(height: 8),
          _langOption('en', '🇬🇧', l.settingsLangEnglish),
        ]),
      ),
    );
  }

  Widget _langOption(String code, String flag, String label) {
    final currentCode = Localizations.localeOf(context).languageCode;
    final selected = currentCode == code;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        MortgageApp.of(context)?.setLocale(Locale(code));
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
    final l = AppLocalizations.of(context)!;
    final currentCode = Localizations.localeOf(context).languageCode;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          Text(l.settingsTitle,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 24),

          _sectionLabel(l.settingsLanguage),
          _settingCard(children: [
            _settingRow(
              icon: Icons.language_outlined,
              label: l.settingsLanguage,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(currentCode == 'vi' ? l.settingsLangVietnamese : l.settingsLangEnglish,
                    style: const TextStyle(
                        fontSize: 13,
                        color: _gold,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                const Icon(Icons.unfold_more_rounded, color: _gold, size: 16),
              ]),
              onTap: () => _showLanguagePicker(l),
            ),
          ]),

          const SizedBox(height: 20),

          _sectionLabel(l.settingsSupport),
          _settingCard(children: [
            _settingRow(
              icon: Icons.feedback_outlined,
              iconColor: _darkGreen,
              label: l.settingsFeedback,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FeedbackScreen())),
            ),
            _divider(),
            _settingRow(
              icon: Icons.info_outline_rounded,
              label: l.settingsAbout,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const _AboutScreen())),
            ),
          ]),

          const SizedBox(height: 20),

          _sectionLabel(l.settingsLegal),
          _settingCard(children: [
            _settingRow(
              icon: Icons.privacy_tip_outlined,
              iconColor: _darkGreen,
              label: l.settingsPrivacyPolicy,
              onTap: () async {
                final uri = Uri.parse(
                    'https://loanbuddy.io.vn');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
            _divider(),
            _settingRow(
              icon: Icons.description_outlined,
              iconColor: _darkGreen,
              label: l.settingsTermsOfUse,
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

          Center(
            child: Text(l.appVersion,
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
class _AboutScreen extends StatefulWidget {
  const _AboutScreen();

  @override
  State<_AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<_AboutScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() => _version = info.version);
    } catch (_) {
      // Giu nguyen chuoi rong neu khong doc duoc, khong lam crash man hinh.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
            child: Text(l.aboutVersion(_version),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Text(
              l.aboutDescription,
              style: const TextStyle(
                  fontSize: 14, color: Color(0xFF555555), height: 1.6),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              _feature(context, Icons.home_outlined, l.aboutFeature1),
              _feature(context, Icons.account_balance_wallet_outlined, l.aboutFeature2),
              _feature(context, Icons.compare_arrows_rounded, l.aboutFeature3),
              _feature(context, Icons.calendar_month_outlined, l.aboutFeature6),
              _feature(context, Icons.trending_down_rounded, l.aboutFeature7),
              _feature(context, Icons.favorite_outline_rounded, l.aboutFeature4),
              _feature(context, Icons.bar_chart_rounded, l.aboutFeature8),
              _feature(context, Icons.history_rounded, l.aboutFeature5),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _feature(BuildContext context, IconData icon, String label) => Padding(
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
