import 'package:flutter/material.dart';
import '../models/loan_model.dart';
import '../models/pdf_export.dart';
import '../models/csv_export.dart';

class ScheduleScreen extends StatefulWidget {
  final LoanModel loan;
  const ScheduleScreen({super.key, required this.loan});
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late List<LoanPayment> _schedule;
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);

  @override
  void initState() {
    super.initState();
    _schedule = widget.loan.buildSchedule();
  }

  String _fmt(double n) {
    final v = n / 1e6;
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(2)} tỷ';
    return '${v.toStringAsFixed(2)} triệu';
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

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('Xuất file',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _exportOption(
            icon: Icons.table_chart_outlined,
            iconColor: const Color(0xFF4CAF50),
            iconBg: const Color(0xFFE8F5E9),
            title: 'Xuất file CSV',
            sub: 'Mở được bằng Excel, Google Sheets',
            onTap: () {
              Navigator.pop(context);
              CsvExport.exportSchedule(widget.loan, _schedule);
            },
          ),
          const SizedBox(height: 10),
          _exportOption(
            icon: Icons.picture_as_pdf_outlined,
            iconColor: const Color(0xFFE53935),
            iconBg: const Color(0xFFFFEBEE),
            title: 'Xuất file PDF',
            sub: 'Dễ chia sẻ, in ấn',
            onTap: () {
              Navigator.pop(context);
              PdfExport.exportSchedule(widget.loan, _schedule);
            },
          ),
        ]),
      ),
    );
  }

  Widget _exportOption({
    required IconData icon, required Color iconColor,
    required Color iconBg, required String title,
    required String sub, required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: _bg, borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 24)),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              Text(sub,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF888888))),
            ])),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Color(0xFF888888)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final totalInterest = _schedule.fold(0.0, (s, r) => s + r.interest);
    final totalPayment = totalInterest + widget.loan.amount;
    final maxIdx = _schedule.indexWhere((r) =>
        r.payment ==
        _schedule.map((x) => x.payment).reduce((a, b) => a > b ? a : b));
    final maxPay = _schedule[maxIdx].payment;
    final minPayItem = _schedule
        .where((r) => r.payment > 0)
        .reduce((a, b) => a.payment < b.payment ? a : b);
    final minPay = minPayItem.payment;
    final minPayPeriod = minPayItem.period;
    final fpIdx = _schedule.indexWhere((r) => r.isRateChange);
    final beforePay = fpIdx > 0 ? _schedule[fpIdx - 1].payment : 0.0;
    final afterPay = fpIdx >= 0 ? _schedule[fpIdx].payment : 0.0;
    final diff = afterPay - beforePay;

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
              _summaryCard(
                icon: Icons.account_balance_outlined,
                iconColor: _gold,
                iconBg: const Color(0xFFFFF3E0),
                label: 'Tổng tiền lãi phải trả',
                value: _fmt(totalInterest),
                sub: 'Chiếm ${(totalInterest / totalPayment * 100).toStringAsFixed(0)}% gốc và lãi',
                subColor: _gold,
                subBg: const Color(0xFFFFF3E0),
              ),
              _summaryCard(
                icon: Icons.payments_outlined,
                iconColor: const Color(0xFF4CAF50),
                iconBg: const Color(0xFFE8F5E9),
                label: 'Tổng phải thanh toán',
                value: _fmt(totalPayment),
                sub: 'Bao gồm gốc và lãi',
                subColor: const Color(0xFF4CAF50),
                subBg: const Color(0xFFE8F5E9),
              ),
              _summaryCard(
                icon: Icons.trending_up_rounded,
                iconColor: const Color(0xFFE53935),
                iconBg: const Color(0xFFFFEBEE),
                label: 'Mức thanh toán cao nhất',
                value: _fmt(maxPay),
                sub: 'Kỳ thứ ${maxIdx + 1}',
                subColor: const Color(0xFFE53935),
                subBg: const Color(0xFFFFEBEE),
              ),
              _summaryCard(
                icon: Icons.trending_down_rounded,
                iconColor: const Color(0xFF1E88E5),
                iconBg: const Color(0xFFE3F2FD),
                label: 'Mức thanh toán thấp nhất',
                value: _fmt(minPay),
                sub: 'Kỳ thứ $minPayPeriod',
                subColor: const Color(0xFF1E88E5),
                subBg: const Color(0xFFE3F2FD),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (diff > 0)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _gold.withOpacity(0.2)),
              ),
              child: Row(children: [
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: _gold.withOpacity(0.15),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.warning_amber_rounded,
                        color: _gold, size: 24)),
                const SizedBox(width: 8),
                Container(
                    width: 1, height: 44, color: _gold.withOpacity(0.3)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Sau thời gian ưu đãi (kỳ ${fpIdx + 1}):',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF5D4037),
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('Khoản thanh toán ${diff > 0 ? "tăng +${_fmt(diff)}" : "giảm -${_fmt(diff.abs())}"}/tháng',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF5D4037),
                              fontWeight: FontWeight.w600)),
                    ])),
                const SizedBox(width: 8),
                Stack(clipBehavior: Clip.none, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(diff > 0 ? Icons.north_east_rounded : Icons.south_east_rounded,
    color: diff > 0 ? const Color(0xFFE53935) : const Color(0xFF4CAF50),
    size: 13),
                      const SizedBox(width: 2),
                      Text(
                          '${(diff / beforePay * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.w800)),
                    ]),
                  ),
                  Positioned(
                      top: -6,
                      right: -4,
                      child: Text('✦',
                          style: TextStyle(
                              fontSize: 10,
                              color: _gold.withOpacity(0.8)))),
                  Positioned(
                      top: -2,
                      right: -10,
                      child: Text('✦',
                          style: TextStyle(
                              fontSize: 6,
                              color: _gold.withOpacity(0.6)))),
                ]),
              ]),
            ),
          const SizedBox(height: 12),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              _legend('Đổi lãi suất', const Color(0xFFFFF3CD)),
              const SizedBox(width: 10),
            ]),
            OutlinedButton.icon(
              onPressed: () => _showExportOptions(context),
              icon: const Icon(Icons.download_rounded, size: 14, color: _gold),
              label: const Text('Xuất file',
                  style: TextStyle(fontSize: 12, color: _gold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _gold, width: 1),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ]),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              _tableHeader(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _schedule.length,
                itemBuilder: (_, i) => _tableRow(_schedule[i]),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon, required Color iconColor,
    required Color iconBg, required String label,
    required String value, required String sub,
    required Color subColor, required Color subBg,
  }) =>
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
                      color: iconBg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: iconColor, size: 20)),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF888888)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A))),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: subBg,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(sub,
                    style: TextStyle(
                        fontSize: 10,
                        color: subColor,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ]),
      );

  Widget _legend(String label, Color color) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.grey.shade300))),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: Color(0xFF888888))),
      ]);

  Widget _tableHeader() => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: const BoxDecoration(
            color: Color(0xFFE8A020),
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(16))),
        child: Row(children: [
          _thFlex(1, 'Kỳ'),
          _thFlex(3, 'Tổng trả'),
          _thFlex(3, 'Gốc'),
          _thFlex(3, 'Lãi'),
          _thFlex(3, 'Dư nợ còn lại'),
        ]),
      );

  Widget _thFlex(int flex, String text) => Expanded(
        flex: flex,
        child: Text(text,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A)),
            textAlign: TextAlign.center),
      );

  Widget _tableRow(LoanPayment r) {
    Color? bg;
    if (r.isRateChange) {
      bg = const Color(0xFFFFF3CD);
    } else if (r.isPrepayChange) bg = const Color(0xFFFFCDD2);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        border:
            Border(top: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: Row(children: [
        _tdFlex(1, r.period.toString(), color: const Color(0xFF888888)),
        _tdFlex(3, _fmtFull(r.payment),
            bold: true, color: const Color(0xFF1A1A1A)),
        _tdFlex(3, _fmtFull(r.principal)),
        _tdFlex(3, _fmtFull(r.interest)),
        _tdFlex(3, _fmtFull(r.balanceEnd)),
      ]),
    );
  }

  Widget _tdFlex(int flex, String text, {
  bool bold = false, Color color = const Color(0xFF444444)}) =>
  Expanded(
    flex: flex,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(text, style: TextStyle(fontSize: 10,
        fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
        color: color),
        textAlign: TextAlign.center),
    ),
  );
}