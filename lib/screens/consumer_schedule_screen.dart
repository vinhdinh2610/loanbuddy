import 'package:flutter/material.dart';

class ConsumerScheduleScreen extends StatefulWidget {
  final double loanAmount;
  final double annualRate;
  final int termMonths;
  final double prepayFee;
  final double monthlyPayment;
  final double totalInterest;
  final double totalAmount;

  const ConsumerScheduleScreen({
    super.key,
    required this.loanAmount,
    required this.annualRate,
    required this.termMonths,
    required this.prepayFee,
    required this.monthlyPayment,
    required this.totalInterest,
    required this.totalAmount,
  });

  @override
  State<ConsumerScheduleScreen> createState() =>
      _ConsumerScheduleScreenState();
}

class _ConsumerScheduleScreenState extends State<ConsumerScheduleScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _navy = Color(0xFF1A237E);
  static const _bg = Color(0xFFF5F0E8);
  late List<Map<String, double>> _schedule;

  @override
  void initState() {
    super.initState();
    _buildSchedule();
  }

  void _buildSchedule() {
    _schedule = [];
    final r = widget.annualRate / 100 / 12;
    final n = widget.termMonths;
    double bal = widget.loanAmount;
    final pmt = widget.monthlyPayment;
    for (int i = 1; i <= n; i++) {
      final interest = bal * r;
      var principal = pmt - interest;
      if (principal > bal) principal = bal;
      bal -= principal;
      if (bal < 1) bal = 0;
      _schedule.add({
        'period': i.toDouble(),
        'payment': pmt,
        'principal': principal,
        'interest': interest,
        'balance': bal,
      });
    }
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

  String _fmt(double n) {
    if (n >= 1e9) return '${(n / 1e9).toStringAsFixed(2)} tỷ';
    return '${(n / 1e6).toStringAsFixed(1)} triệu';
  }

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
),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          const Text('Kết Quả',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: (MediaQuery.of(context).size.width / 2 - 20) / 140,
            children: [
              _card(Icons.account_balance_wallet_outlined,
                  _navy, const Color(0xFFE8EAF6),
                  'Trả hàng tháng', _fmt(widget.monthlyPayment),
                  'Cố định mỗi kỳ', const Color(0xFF1A237E)),
              _card(Icons.payments_outlined,
                  const Color(0xFF4CAF50), const Color(0xFFE8F5E9),
                  'Tổng thanh toán', _fmt(widget.totalAmount),
                  'Bao gồm gốc và lãi', const Color(0xFF4CAF50)),
              _card(Icons.trending_up_rounded,
                  _gold, const Color(0xFFFFF3E0),
                  'Tổng lãi phải trả', _fmt(widget.totalInterest),
                  'Chiếm ${(widget.totalInterest / widget.totalAmount * 100).toStringAsFixed(0)}% gốc và lãi',
                  _gold),
              _card(Icons.calendar_month_outlined,
                  const Color(0xFFE53935), const Color(0xFFFFEBEE),
                  'Kỳ hạn vay', '${widget.termMonths} tháng',
                  'Tương đương ${(widget.termMonths / 12).toStringAsFixed(1)} năm',
                  const Color(0xFFE53935)),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 12),
                decoration: const BoxDecoration(
                    color: _gold,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16))),
                child: Row(children: [
                  _thFlex(1, 'Kỳ'),
                  _thFlex(2, 'Tổng trả'),
                  _thFlex(2, 'Gốc'),
                  _thFlex(2, 'Lãi'),
                  _thFlex(2, 'Dư nợ còn lại'),
                ]),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _schedule.length,
                itemBuilder: (_, i) {
                  final r = _schedule[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 9, horizontal: 12),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Colors.grey.shade100, width: 1))),
                    child: Row(children: [
                      _tdFlex(1, r['period']!.round().toString(),
                          color: const Color(0xFF888888)),
                      _tdFlex(2, _fmtFull(r['payment']!), bold: true),
                      _tdFlex(2, _fmtFull(r['principal']!)),
                      _tdFlex(2, _fmtFull(r['interest']!)),
                      _tdFlex(2, _fmtFull(r['balance']!)),
                    ]),
                  );
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _thFlex(int flex, String text) => Expanded(
        flex: flex,
        child: Text(text,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A)),
            textAlign: TextAlign.center),
      );

  Widget _tdFlex(int flex, String text,
          {bool bold = false,
          Color color = const Color(0xFF444444)}) =>
      Expanded(
        flex: flex,
        child: Text(text,
            style: TextStyle(
                fontSize: 10,
                fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
                color: color),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis),
      );

  Widget _card(IconData icon, Color iconColor, Color iconBg,
          String label, String value, String sub, Color subColor) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: iconColor, size: 20)),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF888888))),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A))),
              Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(sub,
                      style: TextStyle(
                          fontSize: 10,
                          color: subColor,
                          fontWeight: FontWeight.w600))),
            ]),
      );
}