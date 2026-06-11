import 'dart:async';
import 'package:flutter/material.dart';
import 'calculator_screen.dart';
import 'consumer_loan_screen.dart';
import 'comparison_screen.dart';
import 'loan_estimator_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);
  static const _darkGreen = Color(0xFF1B4332);

  // ── Banner slider ──────────────────────────────────────────────
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;

  final List<_BannerData> _banners = [
    _BannerData(
      gradient: const [Color(0xFF1B4332), Color(0xFF2D6A4F)],
      icon: Icons.trending_up_rounded,
      title: 'Lãi suất đang có xu hướng tăng',
      subtitle: 'Cân nhắc cố định lãi suất sớm để tiết kiệm',
    ),
    _BannerData(
      gradient: const [Color(0xFF1565C0), Color(0xFF1E88E5)],
      icon: Icons.savings_outlined,
      title: 'Tính toán khoản vay ngay hôm nay',
      subtitle: 'Lên kế hoạch tài chính thông minh hơn',
    ),
    _BannerData(
      gradient: const [Color(0xFF6A1B9A), Color(0xFF9C27B0)],
      icon: Icons.health_and_safety_outlined,
      title: 'Kiểm tra sức khỏe tài chính',
      subtitle: 'Xem mức vay phù hợp với thu nhập của bạn',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_bannerController.hasClients) return;
      final next = (_currentBanner + 1) % _banners.length;
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

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Chức năng đang trong quá trình hoàn thiện'),
        backgroundColor: _darkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
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
              TextSpan(
                text: 'Loan',
                style: TextStyle(color: _darkGreen),
              ),
              TextSpan(
                text: 'Buddy',
                style: TextStyle(color: _gold),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          // Greeting
          const Text(
            'Xin chào 👋',
            style: TextStyle(fontSize: 16, color: Color(0xFF1B4332)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Bạn muốn tính gì\nhôm nay?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),

          // Banner Slider
          _buildBannerSlider(),
          const SizedBox(height: 24),

          // Công cụ tài chính
          _sectionLabel('Công cụ tài chính'),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: _featureCard(
                gradient: const [Color(0xFFE8A020), Color(0xFFFFD060)],
                icon: Icons.home_outlined,
                title: 'Vay thế chấp',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CalculatorScreen())),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _featureCard(
                gradient: const [Color(0xFF1E88E5), Color(0xFF64B5F6)],
                icon: Icons.account_balance_wallet_outlined,
                title: 'Vay tín chấp',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ConsumerLoanScreen())),
              ),
            ),
          ]),
          const SizedBox(height: 24),

          // Tối ưu khoản vay
          _sectionLabel('Tối ưu khoản vay'),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.15,
            children: [
              _featureCard(
                gradient: const [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
                icon: Icons.compare_arrows_rounded,
                title: 'So sánh khoản vay',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ComparisonScreen())),
              ),
              _featureCard(
                gradient: const [Color(0xFF9C27B0), Color(0xFFCE93D8)],
                icon: Icons.calculate_outlined,
                title: 'Sức khỏe tài chính',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoanEstimatorScreen())),
              ),
              _featureCard(
                gradient: const [Color(0xFFE53935), Color(0xFFEF9A9A)],
                icon: Icons.show_chart_rounded,
                title: 'Kiểm tra lãi suất',
                comingSoon: true,
                onTap: _showComingSoon,
              ),
              _featureCard(
                gradient: const [Color(0xFF00ACC1), Color(0xFF80DEEA)],
                icon: Icons.swap_horiz_rounded,
                title: 'Phân tích chuyển nợ',
                comingSoon: true,
                onTap: _showComingSoon,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Banner Slider ──────────────────────────────────────────────
  Widget _buildBannerSlider() {
    return Column(
      children: [
        SizedBox(
          height: 110,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemCount: _banners.length,
            itemBuilder: (_, i) {
              final b = _banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: b.imagePath != null
                      ? Image.asset(b.imagePath!, fit: BoxFit.cover,
                          width: double.infinity)
                      : _bannerPlaceholder(b),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            final active = i == _currentBanner;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? _gold : _gold.withOpacity(0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _bannerPlaceholder(_BannerData b) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: b.gradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(b.icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(b.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  )),
              const SizedBox(height: 4),
              Text(b.subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                  )),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios_rounded,
            color: Colors.white70, size: 14),
      ]),
    );
  }

  // ── Feature Card ──────────────────────────────────────────────
  Widget _featureCard({
    required List<Color> gradient,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool comingSoon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                if (comingSoon)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF888888),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Soon',
                          style: TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: comingSoon
                    ? const Color(0xFFAAAAAA)
                    : const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────
  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF888888),
        ),
      );
}

// ── Banner Data Model ──────────────────────────────────────────
class _BannerData {
  final List<Color> gradient;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? imagePath;

  const _BannerData({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.imagePath,
  });
}