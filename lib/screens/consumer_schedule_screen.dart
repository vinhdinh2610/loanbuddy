import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../models/consumer_pdf_export.dart';
import '../models/consumer_csv_export.dart';

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
  static const _green = Color(0xFF1B4332);
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

  String _fmt(double n, AppLocalizations l) {
    if (n >= 1e9) return '${(n / 1e9).toStringAsFixed(2)} ${l.unitBillion}';
    return '${(n / 1e6).toStringAsFixed(1)} ${l.unitMillion}';
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16, 12, 16,
            16 + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Builder(builder: (ctx2) {
            final lc = AppLocalizations.of(ctx2)!;
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text(lc.scheduleExportTitle,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(lc.scheduleChooseFormat,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF888888))),
              const SizedBox(height: 16),
              _exportOption(
                icon: Icons.picture_as_pdf_outlined,
                iconColor: const Color(0xFFE53935),
                iconBg: const Color(0xFFFFEBEE),
                title: lc.scheduleExportPDF,
                sub: lc.scheduleExportPDFDesc,
                onTap: () {
                  Navigator.pop(context);
                  _handleExport(isPdf: true);
                },
              ),
              const SizedBox(height: 10),
              _exportOption(
                icon: Icons.table_chart_outlined,
                iconColor: const Color(0xFF4CAF50),
                iconBg: const Color(0xFFE8F5E9),
                title: lc.scheduleExportCSV,
                sub: lc.scheduleExportCSVDesc,
                onTap: () {
                  Navigator.pop(context);
                  _handleExport(isPdf: false);
                },
              ),
            ]);
          }),
        ),
      ),
    );
  }

  Future<void> _handleExport({required bool isPdf}) async {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: _gold)),
    );
    try {
      if (isPdf) {
        await ConsumerPdfExport.buildBytes(
          loanAmount: widget.loanAmount,
          annualRate: widget.annualRate,
          termMonths: widget.termMonths,
          monthlyPayment: widget.monthlyPayment,
          totalInterest: widget.totalInterest,
          totalAmount: widget.totalAmount,
          schedule: _schedule,
        );
      } else {
        await ConsumerCsvExport.buildBytes(
          loanAmount: widget.loanAmount,
          annualRate: widget.annualRate,
          termMonths: widget.termMonths,
          monthlyPayment: widget.monthlyPayment,
          totalInterest: widget.totalInterest,
          totalAmount: widget.totalAmount,
          schedule: _schedule,
        );
      }
    } catch (_) {}
    if (!mounted) return;
    Navigator.pop(context);
    _showShareOrSave(isPdf: isPdf);
  }

  void _showShareOrSave({required bool isPdf}) {
    final typeName = isPdf ? 'PDF' : 'CSV';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16, 12, 16,
            16 + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Builder(builder: (ctx2) {
            final lc = AppLocalizations.of(ctx2)!;
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                    color: _green,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Text(lc.scheduleFileReady(typeName),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ]),
              ),
              const SizedBox(height: 14),
              Text(lc.scheduleShareAction,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _doShare(isPdf: isPdf);
                  },
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: Text(lc.scheduleShareFile(typeName),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: _green,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _doSave(isPdf: isPdf);
                  },
                  icon: const Icon(Icons.download_rounded,
                      size: 18, color: _green),
                  label: Text(lc.scheduleSaveFile(typeName),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _green)),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: _green, width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ]);
          }),
        ),
      ),
    );
  }

  Future<void> _doShare({required bool isPdf}) async {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: _gold)),
    );
    try {
      if (isPdf) {
        final bytes = await ConsumerPdfExport.buildBytes(
          loanAmount: widget.loanAmount,
          annualRate: widget.annualRate,
          termMonths: widget.termMonths,
          monthlyPayment: widget.monthlyPayment,
          totalInterest: widget.totalInterest,
          totalAmount: widget.totalAmount,
          schedule: _schedule,
        );
        final dir = await getTemporaryDirectory();
        final file = File(
            '${dir.path}/LoanBuddy_TinChap_${DateTime.now().millisecondsSinceEpoch}.pdf');
        await file.writeAsBytes(bytes);
        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'application/pdf')],
          subject: 'Lịch trả nợ tín chấp LoanBuddy',
        );
      } else {
        await ConsumerCsvExport.shareCsv(
          loanAmount: widget.loanAmount,
          annualRate: widget.annualRate,
          termMonths: widget.termMonths,
          monthlyPayment: widget.monthlyPayment,
          totalInterest: widget.totalInterest,
          totalAmount: widget.totalAmount,
          schedule: _schedule,
        );
      }
    } catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l.scheduleShareError(e.toString()))),
        );
      }
    } finally {
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _doSave({required bool isPdf}) async {
    if (isPdf) {
      await ConsumerPdfExport.exportSchedule(
        loanAmount: widget.loanAmount,
        annualRate: widget.annualRate,
        termMonths: widget.termMonths,
        monthlyPayment: widget.monthlyPayment,
        totalInterest: widget.totalInterest,
        totalAmount: widget.totalAmount,
        schedule: _schedule,
      );
    } else {
      await ConsumerCsvExport.exportSchedule(
        loanAmount: widget.loanAmount,
        annualRate: widget.annualRate,
        termMonths: widget.termMonths,
        monthlyPayment: widget.monthlyPayment,
        totalInterest: widget.totalInterest,
        totalAmount: widget.totalAmount,
        schedule: _schedule,
      );
    }
  }

  Widget _exportOption({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String sub,
    required VoidCallback onTap,
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
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 24)),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
          Text(l.consumerScheduleTitle,
              style: const TextStyle(
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
            childAspectRatio:
                (MediaQuery.of(context).size.width / 2 - 20) / 140,
            children: [
              _card(Icons.account_balance_wallet_outlined,
                  _navy, const Color(0xFFE8EAF6),
                  l.consumerScheduleMonthly, _fmt(widget.monthlyPayment, l),
                  l.consumerScheduleFixed, _navy),
              _card(Icons.payments_outlined,
                  const Color(0xFF4CAF50), const Color(0xFFE8F5E9),
                  l.consumerScheduleTotalPayment, _fmt(widget.totalAmount, l),
                  l.consumerScheduleIncludesPrincipal, const Color(0xFF4CAF50)),
              _card(Icons.trending_up_rounded,
                  _gold, const Color(0xFFFFF3E0),
                  l.consumerScheduleTotalInterest, _fmt(widget.totalInterest, l),
                  l.consumerSchedulePercentOfTotal(
                      (widget.totalInterest / widget.totalAmount * 100).toStringAsFixed(0)),
                  _gold),
              _card(Icons.calendar_month_outlined,
                  const Color(0xFFE53935), const Color(0xFFFFEBEE),
                  l.consumerScheduleTerm,
                  l.homeMonths(widget.termMonths),
                  l.consumerScheduleYears((widget.termMonths / 12).toStringAsFixed(1)),
                  const Color(0xFFE53935)),
            ],
          ),
          const SizedBox(height: 12),

          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            OutlinedButton.icon(
              onPressed: () => _showExportOptions(context),
              icon: const Icon(Icons.upload_rounded,
                  size: 14, color: _gold),
              label: Text(l.scheduleExportFile,
                  style: const TextStyle(fontSize: 12, color: _gold)),
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
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 12),
                decoration: const BoxDecoration(
                    color: _gold,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16))),
                child: Row(children: [
                  _thFlex(1, l.tableColPeriod),
                  _thFlex(2, l.tableColTotal),
                  _thFlex(2, l.tableColPrincipal),
                  _thFlex(2, l.tableColInterest),
                  _thFlex(2, l.tableColBalance),
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
                                color: Colors.grey.shade100,
                                width: 1))),
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
                fontWeight:
                    bold ? FontWeight.w700 : FontWeight.normal,
                color: color),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis),
      );

  Widget _card(IconData icon, Color iconColor, Color iconBg,
          String label, String value, String sub, Color subColor) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 36, height: 36,
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
