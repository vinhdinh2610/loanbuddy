import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'full_payoff_screen.dart';
import 'partial_prepayment_screen.dart';

class EarlySettlementSelectScreen extends StatelessWidget {
  const EarlySettlementSelectScreen({super.key});

  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            children: [
              TextSpan(text: 'Loan', style: TextStyle(color: Color(0xFF1B4332))),
              TextSpan(text: 'Buddy', style: TextStyle(color: Color(0xFFE8A020))),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Text(l.earlySelectTitle,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 4),
          Text(l.earlySelectSubtitle,
              style: const TextStyle(fontSize: 14, color: Color(0xFF888888))),
          const SizedBox(height: 24),

          _scenarioCard(
            context: context,
            iconBg: const Color(0xFFFBEAD3),
            iconColor: _gold,
            icon: Icons.flag_outlined,
            title: l.earlySelectFullTitle,
            desc: l.earlySelectFullDesc,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FullPayoffScreen())),
          ),
          const SizedBox(height: 14),
          _scenarioCard(
            context: context,
            iconBg: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF1565C0),
            icon: Icons.payments_outlined,
            title: l.earlySelectPartialTitle,
            desc: l.earlySelectPartialDesc,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const PartialPrepaymentScreen())),
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: _gold.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.info_outline_rounded, size: 14, color: _gold),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(l.earlySelectNote,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF888888)))),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _scenarioCard({
    required BuildContext context,
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: iconColor, size: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A))),
                const SizedBox(height: 4),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888888),
                        height: 1.5)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              size: 18, color: Color(0xFFBBBBBB)),
        ]),
      ),
    );
  }
}
