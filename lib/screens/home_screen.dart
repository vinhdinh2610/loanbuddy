import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/responsive_helper.dart';
import 'calculator_screen.dart';
import 'consumer_loan_screen.dart';
import 'comparison_screen.dart';
import 'loan_estimator_screen.dart';
import 'rate_checker_screen.dart';
import 'early_settlement_select_screen.dart';
import 'debt_refinance_screen.dart';
import '../models/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);
  static const _darkGreen = Color(0xFF1B4332);

  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;

  List<HistoryEntry> _recentHistory = [];
  bool _loadingHistory = true;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _loadRecentHistory();
  }

  Future<void> _loadRecentHistory() async {
    final all = await DatabaseHelper.instance.getAll();
    if (!mounted) return;
    setState(() {
      _recentHistory = all.take(2).toList();
      _loadingHistory = false;
    });
  }

  void _startAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_bannerController.hasClients) return;
      final next = (_currentBanner + 1) % 3;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  String _fmtFull(double n) {
    final s = n.round().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  String _fmtDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  String _typeLabel(String type, AppLocalizations l) =>
      type == 'mortgage' ? l.homeLoanTypeMortgage : l.homeLoanTypeConsumer;

  String _methodLabel(String method, AppLocalizations l) {
    switch (method) {
      case 'ep': return l.homeMethodDeclining;
      case 'io': return l.homeMethodInterestOnly;
      case 'ann':
      case 'consumer': return l.homeMethodEqual;
      default: return method;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final banners = [
      _DiscoverBanner(
        color: const Color(0xFF1B4332),
        icon: Icons.home_outlined,
        title: l.homeBannerMortgageTitle,
        subtitle: l.homeBannerMortgageSubtitle,
      ),
      _DiscoverBanner(
        color: const Color(0xFF1565C0),
        icon: Icons.account_balance_wallet_outlined,
        title: l.homeBannerConsumerTitle,
        subtitle: l.homeBannerConsumerSubtitle,
      ),
      _DiscoverBanner(
        color: const Color(0xFF9C27B0),
        icon: Icons.favorite_outline_rounded,
        title: l.homeBannerHealthTitle,
        subtitle: l.homeBannerHealthSubtitle,
      ),
    ];

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            children: [
              TextSpan(text: 'Loan', style: TextStyle(color: _darkGreen)),
              TextSpan(text: 'Buddy', style: TextStyle(color: _gold)),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Text(
            l.homeGreeting,
            style: const TextStyle(fontSize: 16, color: Color(0xFF1B4332)),
          ),
          const SizedBox(height: 4),
          Text(
            l.homeQuestion,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),

          _sectionLabel(l.homeSectionLoan),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: _toolCard(
                iconBg: const Color(0xFFFFF8E1),
                iconColor: const Color(0xFFF57F17),
                icon: Icons.home_outlined,
                title: l.homeMortgage,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CalculatorScreen())),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _toolCard(
                iconBg: const Color(0xFFE3F2FD),
                iconColor: const Color(0xFF1565C0),
                icon: Icons.credit_card_outlined,
                title: l.homeConsumer,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ConsumerLoanScreen())),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _toolCard(
                iconBg: const Color(0xFFE8F5E9),
                iconColor: _darkGreen,
                icon: Icons.swap_horiz_rounded,
                title: l.homeComparison,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ComparisonScreen())),
              ),
            ),
          ]),
          const SizedBox(height: 22),

          _sectionLabel(l.homeSectionManage),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: _mgmtCard(
                iconBg: const Color(0xFFFFF8E1),
                iconColor: const Color(0xFFF57F17),
                icon: Icons.calendar_month_outlined,
                title: isTablet(context) ? l.homeEarlySettlementFull : l.homeEarlySettlement,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const EarlySettlementSelectScreen())),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _mgmtCard(
                iconBg: const Color(0xFFE0F2F1),
                iconColor: const Color(0xFF00695C),
                icon: Icons.trending_down_rounded,
                title: isTablet(context) ? l.homeDebtRefinanceFull : l.homeDebtRefinance,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const DebtRefinanceScreen())),
              ),
            ),
          ]),
          const SizedBox(height: 22),

          _sectionLabel(l.homeSectionPersonal),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: _mgmtCard(
                iconBg: const Color(0xFFFFEBEE),
                iconColor: const Color(0xFFC62828),
                icon: Icons.favorite_outline_rounded,
                title: isTablet(context) ? l.homeFinancialHealthFull : l.homeFinancialHealth,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoanEstimatorScreen())),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _mgmtCard(
                iconBg: const Color(0xFFE3F2FD),
                iconColor: const Color(0xFF1565C0),
                icon: Icons.bar_chart_rounded,
                title: isTablet(context) ? l.homeRateCheckerFull : l.homeRateChecker,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RateCheckerScreen())),
              ),
            ),
          ]),
          const SizedBox(height: 22),

          _sectionLabel(l.homeExplore),
          const SizedBox(height: 10),
          _buildDiscoverBanner(banners),
          const SizedBox(height: 22),

          if (!_loadingHistory && _recentHistory.isNotEmpty) ...[
            _sectionLabel(l.homeRecentLoans),
            const SizedBox(height: 10),
            _buildHistoryCard(l),
          ],
        ],
      ),
    );
  }

  Widget _toolCard({
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E4DA), width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 28,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mgmtCard({
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool comingSoon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E4DA), width: 0.5),
        ),
        child: Row(
          children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: iconColor, size: 19),
              ),
              if (comingSoon)
                Positioned(
                  top: -4,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF888888),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Soon',
                        style: TextStyle(
                            fontSize: 7,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
            ]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: comingSoon
                      ? const Color(0xFFAAAAAA)
                      : const Color(0xFF1A1A1A),
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverBanner(List<_DiscoverBanner> banners) {
    return Column(
      children: [
        SizedBox(
          height: 84,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemCount: banners.length,
            itemBuilder: (_, i) {
              final b = banners[i];
              return GestureDetector(
                onTap: () => _handleBannerTap(i),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: b.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(b.icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(b.title,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          const SizedBox(height: 3),
                          Text(b.subtitle,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.8),
                                  height: 1.3),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white, size: 12),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (i) {
            final active = i == _currentBanner;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 5,
              height: 5,
              decoration: BoxDecoration(
                color: active ? _gold : _gold.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _handleBannerTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CalculatorScreen()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ConsumerLoanScreen()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const LoanEstimatorScreen()));
        break;
    }
  }

  Widget _buildHistoryCard(AppLocalizations l) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E4DA), width: 0.5),
      ),
      child: Column(
        children: List.generate(_recentHistory.length, (i) {
          final h = _recentHistory[i];
          final isMortgage = h.type == 'mortgage';
          return Column(
            children: [
              if (i > 0)
                Divider(height: 1, thickness: 0.5, color: Colors.grey.shade100),
              InkWell(
                onTap: () {
                  if (isMortgage) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const CalculatorScreen()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ConsumerLoanScreen()));
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isMortgage
                            ? const Color(0xFFFFF8E1)
                            : const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        isMortgage
                            ? Icons.home_outlined
                            : Icons.credit_card_outlined,
                        color: isMortgage
                            ? const Color(0xFFF57F17)
                            : const Color(0xFF1565C0),
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_typeLabel(h.type, l)} · ${_methodLabel(h.method, l)}',
                            style: const TextStyle(
                                fontSize: 9, color: Color(0xFF888888)),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '${_fmtFull(h.amount)}đ',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A)),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '${((h.floatRate > 0 ? h.floatRate : h.fixedRate) * 100).toStringAsFixed(1)}${l.homePerYear} · ${l.homeMonths(h.termMonths)} · ${_fmtDate(h.createdAt)}',
                            style: const TextStyle(
                                fontSize: 8, color: Color(0xFFAAAAAA)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(l.homeReview,
                            style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: _darkGreen)),
                        const SizedBox(width: 2),
                        const Icon(Icons.chevron_right_rounded,
                            size: 12, color: _darkGreen),
                      ]),
                    ),
                  ]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF888888),
        ),
      );
}

class _DiscoverBanner {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  _DiscoverBanner({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
