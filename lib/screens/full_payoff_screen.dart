import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../l10n/app_localizations.dart';
import '../widgets/responsive_helper.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/thousands_formatter.dart';

class FullPayoffScreen extends StatefulWidget {
  const FullPayoffScreen({super.key});
  @override
  State<FullPayoffScreen> createState() => _FullPayoffScreenState();
}

class _FullPayoffScreenState extends State<FullPayoffScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);
  static const _darkGreen = Color(0xFF1B4332);

  final _amountCtrl = TextEditingController(text: '0');
  final _termCtrl = TextEditingController(text: '0');
  final _graceCtrl = TextEditingController(text: '0');
  final _fixedRateCtrl = TextEditingController(text: '0');
  final _fixedPeriodCtrl = TextEditingController(text: '0');
  final _floatRateCtrl = TextEditingController(text: '0');
  final _penaltyCtrl = TextEditingController(text: '0');
  DateTime _startDate = DateTime(2023, 1, 15);
  DateTime _settlementDate = DateTime.now();
  String _method = 'ep';
  bool _showResult = false;
  bool _hasError = false;

  double _remainingBalance = 0;
  double _penaltyAmount = 0;
  double _totalPayoff = 0;
  double _interestSaved = 0;
  int _periodsSaved = 0;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _termCtrl.dispose();
    _graceCtrl.dispose();
    _fixedRateCtrl.dispose();
    _fixedPeriodCtrl.dispose();
    _floatRateCtrl.dispose();
    _penaltyCtrl.dispose();
    super.dispose();
  }

  String _fmtFull(double n) {
    if (n < 0) return '-${_fmtFull(-n)}';
    final s = n.round().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  double _parseAmount(String v) => double.tryParse(v.replaceAll(',', '')) ?? 0;

  int _monthsBetween(DateTime start, DateTime end) {
    int months = (end.year - start.year) * 12 + (end.month - start.month);
    if (end.day < start.day) months -= 1;
    return months < 0 ? 0 : months;
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate(bool isStart) async {
    final initial = isStart ? _startDate : _settlementDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _darkGreen,
            onPrimary: Colors.white,
            onSurface: Color(0xFF1A1A1A),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _settlementDate = picked;
        }
      });
    }
  }

  double _rateAtPeriod(int p, int fixedPeriod, double fixedRate, double floatRate) =>
      (p <= fixedPeriod) ? fixedRate : floatRate;

  double _powCalc(double base, int exp) {
    double result = 1;
    for (int i = 0; i < exp; i++) {
      result *= base;
    }
    return result;
  }

  double _balanceAfterPeriods({
    required String method,
    required double amount,
    required int nTotal,
    required int grace,
    required int k,
    required double fixedRate,
    required int fixedPeriod,
    required double floatRate,
  }) {
    if (k <= grace) return amount;
    final payingPeriods = nTotal - grace;
    final paid = k - grace;
    if (method == 'ep') {
      final principalFixed = amount / payingPeriods;
      return (amount - principalFixed * paid).clamp(0, amount).toDouble();
    } else {
      final r = _rateAtPeriod(grace + 1, fixedPeriod, fixedRate, floatRate) / 12;
      if (r == 0) return (amount - (amount / payingPeriods) * paid).clamp(0, amount).toDouble();
      final pmt = amount * r * _powCalc(1 + r, payingPeriods) /
          (_powCalc(1 + r, payingPeriods) - 1);
      final factor = _powCalc(1 + r, paid);
      final bal = amount * factor - pmt * (factor - 1) / r;
      return bal.clamp(0, amount).toDouble();
    }
  }

  double _sumInterest({
    required String method,
    required double amount,
    required int nTotal,
    required int grace,
    required double fixedRate,
    required int fixedPeriod,
    required double floatRate,
    required int fromPeriod,
    required int toPeriodExclusive,
  }) {
    double total = 0;
    for (int p = fromPeriod; p < toPeriodExclusive; p++) {
      final balanceAtStart = _balanceAfterPeriods(
        method: method,
        amount: amount,
        nTotal: nTotal,
        grace: grace,
        k: p - 1,
        fixedRate: fixedRate,
        fixedPeriod: fixedPeriod,
        floatRate: floatRate,
      );
      if (balanceAtStart <= 0) continue;
      final rate = _rateAtPeriod(p, fixedPeriod, fixedRate, floatRate);
      total += balanceAtStart * rate / 12;
    }
    return total;
  }

  void _calculate() {
    final l = AppLocalizations.of(context)!;
    final amount = _parseAmount(_amountCtrl.text);
    final nTotal = int.tryParse(_termCtrl.text) ?? 0;
    final grace = int.tryParse(_graceCtrl.text) ?? 0;
    final fixedRate = (double.tryParse(_fixedRateCtrl.text) ?? 0) / 100;
    final fixedPeriod = int.tryParse(_fixedPeriodCtrl.text) ?? 0;
    final floatRate = (double.tryParse(_floatRateCtrl.text) ?? 0) / 100;
    final penaltyPct = (double.tryParse(_penaltyCtrl.text) ?? 0) / 100;

    final k = _monthsBetween(_startDate, _settlementDate);

    if (amount <= 0 || nTotal <= 0 || grace >= nTotal || k < 0 || k > nTotal) {
      setState(() => _hasError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.fullPayoffValidation),
          backgroundColor: _darkGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final remainingBalance = _balanceAfterPeriods(
      method: _method,
      amount: amount,
      nTotal: nTotal,
      grace: grace,
      k: k,
      fixedRate: fixedRate,
      fixedPeriod: fixedPeriod,
      floatRate: floatRate,
    );
    final penaltyAmount = remainingBalance * penaltyPct;
    final totalPayoff = remainingBalance + penaltyAmount;

    final totalInterestIfFull = _sumInterest(
      method: _method,
      amount: amount,
      nTotal: nTotal,
      grace: grace,
      fixedRate: fixedRate,
      fixedPeriod: fixedPeriod,
      floatRate: floatRate,
      fromPeriod: 1,
      toPeriodExclusive: nTotal + 1,
    );
    final interestPaidSoFar = _sumInterest(
      method: _method,
      amount: amount,
      nTotal: nTotal,
      grace: grace,
      fixedRate: fixedRate,
      fixedPeriod: fixedPeriod,
      floatRate: floatRate,
      fromPeriod: 1,
      toPeriodExclusive: k + 1,
    );
    final interestSaved = totalInterestIfFull - interestPaidSoFar - penaltyAmount;

    setState(() {
      _remainingBalance = remainingBalance;
      _penaltyAmount = penaltyAmount;
      _totalPayoff = totalPayoff;
      _interestSaved = interestSaved;
      _periodsSaved = nTotal - k;
      _hasError = false;
      _showResult = true;
    });
  }

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
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: ResponsiveFormWidth(
        maxWidth: 480,
        child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          Text(l.fullPayoffTitle,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 4),
          Text(l.fullPayoffSubtitle,
              style: const TextStyle(fontSize: 16, color: Color(0xFF888888))),
          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(children: [
                  Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                          color: _gold.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.calendar_month_outlined,
                          color: _gold, size: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(l.fullPayoffSectionTitle,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A))),
                      Text(l.fillCompletely,
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF888888))),
                    ]),
                  ),
                ]),
              ),
              const Divider(height: 1, color: Color(0xFFF0EBE0)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  _label(l.fullPayoffOriginalAmount),
                  _field(_amountCtrl, '2,000,000,000', isAmount: true),
                  const SizedBox(height: 10),

                  _twoFieldRow(
                    leftLabel: l.fullPayoffStartDate,
                    leftChild: _dateField(_startDate, () => _pickDate(true)),
                    rightLabel: l.fullPayoffTotalTerm,
                    rightChild: _field(_termCtrl, '240',
                        isInt: true, suffix: l.unitMonths),
                  ),
                  const SizedBox(height: 10),

                  _label(l.fullPayoffMethod),
                  Row(children: [
                    Expanded(child: _methodPill('ep', l.fullPayoffMethodDeclining)),
                    const SizedBox(width: 6),
                    Expanded(child: _methodPill('ann', l.fullPayoffMethodEqual)),
                  ]),
                  const SizedBox(height: 10),

                  _label(l.fullPayoffGracePeriod),
                  _field(_graceCtrl, '0', isInt: true, suffix: l.unitMonths),
                  const SizedBox(height: 10),

                  _twoFieldRow(
                    leftLabel: l.fullPayoffFixedRate,
                    leftChild: _field(_fixedRateCtrl, '6.99',
                        isDecimal: true, suffix: l.homePerYear),
                    rightLabel: l.fullPayoffFixedPeriod,
                    rightChild: _field(_fixedPeriodCtrl, '24',
                        isInt: true, suffix: l.unitMonths),
                  ),
                  const SizedBox(height: 10),

                  _label(l.fullPayoffFloatingRate),
                  _field(_floatRateCtrl, '11.79',
                      isDecimal: true, suffix: l.homePerYear),
                  const SizedBox(height: 10),

                  _twoFieldRow(
                    leftLabel: l.fullPayoffTargetDate,
                    leftChild: _dateField(_settlementDate, () => _pickDate(false)),
                    rightLabel: l.fullPayoffPenaltyRate,
                    rightChild: _field(_penaltyCtrl, '2.0',
                        isDecimal: true, suffix: '%'),
                  ),

                  const SizedBox(height: 14),
                  _infoBox(l.fullPayoffInfoBox),
                  const SizedBox(height: 14),

                  ElevatedButton(
                    onPressed: _calculate,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _gold,
                        foregroundColor: const Color(0xFF1B4332),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Text(l.fullPayoffButton,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.resultDisclaimerShort,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  if (_showResult) ...[
                    const SizedBox(height: 14),
                    _buildResult(),
                  ],
                ]),
              ),
            ]),
          ),
        ],
        ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    final l = AppLocalizations.of(context)!;
    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: const Color(0xFFEF5350).withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEF5350).withOpacity(0.25))),
        child: Row(children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFEF5350), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l.fullPayoffNoResult,
              style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
            ),
          ),
        ]),
      );
    }

    return Column(children: [
      Text(l.fullPayoffResultHeader,
          style: const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA))),
      const SizedBox(height: 10),
      const Center(child: AdBannerWidget()),
      const SizedBox(height: 16),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _darkGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.fullPayoffTotalNeeded,
                style: const TextStyle(fontSize: 13, color: Color(0xFFFFFFFF99))),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(_fmtFull(_totalPayoff),
                  style: const TextStyle(
                      fontSize: 27, fontWeight: FontWeight.w800, color: _gold)),
            ),
            const SizedBox(height: 14),

            _resultRow(l.fullPayoffRemainingBalance, _fmtFull(_remainingBalance)),
            const SizedBox(height: 10),
            _resultRow(l.fullPayoffPenaltyFee,
                '${_fmtFull(_penaltyAmount)} · ${_penaltyCtrl.text}%'),

            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0x22FFFFFF))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.fullPayoffInterestSaved,
                      style: const TextStyle(fontSize: 13, color: Color(0xFFFFFFFFAA))),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_interestSaved >= 0 ? '+' : ''}${_fmtFull(_interestSaved)}',
                      style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFA5D6A7)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.fullPayoffEarlyMonths(
                        _periodsSaved,
                        (_periodsSaved / 12).toStringAsFixed(1)),
                    style: const TextStyle(
                        fontSize: 12.5, color: Color(0xFFFFFFFF88)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Text(
              l.fullPayoffResultDisclaimer,
              style: const TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFFFFFFFF77),
                  fontStyle: FontStyle.italic,
                  height: 1.4),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _resultRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFFFFFFFFAA)))),
          Flexible(child: Text(value,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
        ],
      );

  Widget _methodPill(String value, String label) {
    final selected = _method == value;
    return GestureDetector(
      onTap: () => setState(() => _method = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? _darkGreen : _bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF888888),
          ),
        ),
      ),
    );
  }

  Widget _twoFieldRow({
    required String leftLabel,
    required Widget leftChild,
    required String rightLabel,
    required Widget rightChild,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_label(leftLabel), leftChild],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_label(rightLabel), rightChild],
          ),
        ),
      ],
    );
  }

  Widget _dateField(DateTime date, VoidCallback onTap) {
    return TextField(
      readOnly: true,
      onTap: onTap,
      controller: TextEditingController(text: _fmtDate(date)),
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        filled: true,
        fillColor: _bg,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888))),
      );

  Widget _field(TextEditingController ctrl, String hint,
          {bool isAmount = false,
          bool isInt = false,
          bool isDecimal = false,
          String? suffix,
          Function(String)? onChanged}) =>
      TextField(
        controller: ctrl,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 15),
          filled: true,
          fillColor: _bg,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          suffixText: suffix,
          suffixStyle: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
        ),
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
        keyboardType: isDecimal
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.number,
        inputFormatters: isAmount
            ? const [ThousandsSeparatorInputFormatter()]
            : isDecimal
                ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))]
                : [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
      );

  Widget _infoBox(String text) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: _gold.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          const Icon(Icons.info_outline_rounded, size: 16, color: _gold),
          const SizedBox(width: 6),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF888888)))),
        ]),
      );
}
