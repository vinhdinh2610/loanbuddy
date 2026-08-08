import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../widgets/responsive_helper.dart';
import '../widgets/ad_banner_widget.dart';

class RateCheckerScreen extends StatefulWidget {
  const RateCheckerScreen({super.key});
  @override
  State<RateCheckerScreen> createState() => _RateCheckerScreenState();
}

class _RateCheckerScreenState extends State<RateCheckerScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);
  static const _darkGreen = Color(0xFF1B4332);

  final _amountCtrl = TextEditingController(text: '2,000,000,000');
  final _termCtrl = TextEditingController(text: '240');
  final _paymentCtrl = TextEditingController(text: '20,000,000');
  DateTime _startDate = DateTime(2020, 1, 1);
  String _method = 'ep';
  bool _showResult = false;

  double? _estimatedRate;
  int _periodsPaid = 0;
  double _remainingBalance = 0;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _termCtrl.dispose();
    _paymentCtrl.dispose();
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

  String _fmtShort(double n) {
    if (n < 0) return '-${_fmtShort(-n)}';
    if (n >= 1e9) return '${(n / 1e9).toStringAsFixed(2)} tỷ';
    if (n >= 1e6) return '${(n / 1e6).toStringAsFixed(1)} triệu';
    return '${_fmtFull(n)} đ';
  }

  void _handleAmountInput(TextEditingController ctrl, String v) {
    final clean = v.replaceAll(',', '');
    final n = double.tryParse(clean);
    if (n != null) {
      final fmt = _fmtFull(n);
      ctrl.value = TextEditingValue(
          text: fmt,
          selection: TextSelection.collapsed(offset: fmt.length));
    }
  }

  double _parseAmount(String v) =>
      double.tryParse(v.replaceAll(',', '')) ?? 0;

  int _monthsBetween(DateTime start, DateTime end) {
    int months =
        (end.year - start.year) * 12 + (end.month - start.month);
    if (end.day < start.day) months -= 1;
    return months < 0 ? 0 : months;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
      setState(() => _startDate = picked);
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  void _estimate() {
    final l = AppLocalizations.of(context)!;
    final amount = _parseAmount(_amountCtrl.text);
    final nTotal = int.tryParse(_termCtrl.text) ?? 0;
    final payment = _parseAmount(_paymentCtrl.text);
    final k = _monthsBetween(_startDate, DateTime.now());

    if (amount <= 0 ||
        nTotal <= 0 ||
        payment <= 0 ||
        k >= nTotal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.rateCheckerValidation),
          backgroundColor: _darkGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    double? rate;
    double balance;
    final principalFixed = amount / nTotal;
    balance = amount - principalFixed * k;

    if (_method == 'ep') {
      if (balance > 0) {
        rate = (payment - principalFixed) / balance * 12;
      }
    } else if (_method == 'io') {
      if (balance > 0) {
        rate = payment / balance * 12;
      }
    } else {
      rate = _solveAnnuityRate(amount, payment, nTotal);
      balance = _annuityRemainingBalance(
          amount, rate ?? 0, nTotal, k, payment);
    }

    setState(() {
      _estimatedRate =
          (rate != null && rate.isFinite && rate > 0) ? rate : null;
      _periodsPaid = k;
      _remainingBalance = balance;
      _showResult = true;
    });
  }

  double _annuityPayment(double p, double r, int n) {
    if (r == 0) return p / n;
    final factor = _powCalc(1 + r, n);
    return p * r * factor / (factor - 1);
  }

  double _powCalc(double base, int exp) {
    double result = 1;
    for (int i = 0; i < exp; i++) {
      result *= base;
    }
    return result;
  }

  double? _solveAnnuityRate(double p, double payment, int n) {
    double r = 0.01 / 12;
    for (int i = 0; i < 200; i++) {
      final f = _annuityPayment(p, r, n) - payment;
      const h = 1e-9;
      final f2 = _annuityPayment(p, r + h, n) - payment;
      final deriv = (f2 - f) / h;
      if (deriv.abs() < 1e-14) break;
      final rNew = r - f / deriv;
      if ((rNew - r).abs() < 1e-12) {
        r = rNew;
        break;
      }
      r = rNew;
      if (r.isNaN || r.isInfinite || r < -0.5) return null;
    }
    return r * 12;
  }

  double _annuityRemainingBalance(
      double p, double annualRate, int nTotal, int k, double payment) {
    final r = annualRate / 12;
    if (r == 0) return p - (p / nTotal) * k;
    final factor = _powCalc(1 + r, k);
    return p * factor - payment * (factor - 1) / r;
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ResponsiveFormWidth(
        maxWidth: 480,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          children: [
            Text(l.rateCheckerTitle,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A))),
            const SizedBox(height: 4),
            Text(l.rateCheckerSubtitle,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF888888))),
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Row(children: [
                    Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                            color: _gold.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.bar_chart_rounded,
                            color: _gold, size: 18)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                        Text(l.rateCheckerSectionTitle,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A))),
                        Text(l.rateCheckerHint,
                            style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF888888))),
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
                    _label(l.rateCheckerOriginalAmount),
                    _field(_amountCtrl, '2,000,000,000',
                        isAmount: true,
                        onChanged: (v) =>
                            _handleAmountInput(_amountCtrl, v)),
                    const SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              _label(l.rateCheckerStartDate),
                              TextField(
                                readOnly: true,
                                onTap: _pickDate,
                                controller: TextEditingController(
                                    text: _fmtDate(_startDate)),
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: _bg,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12),
                                ),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A1A)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              _label(l.rateCheckerTotalTerm),
                              _field(_termCtrl, '240',
                                  isInt: true, suffix: l.unitMonths),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    _label(l.rateCheckerLastPayment),
                    _field(_paymentCtrl, '18,642,624',
                        isAmount: true,
                        onChanged: (v) =>
                            _handleAmountInput(_paymentCtrl, v)),
                    const SizedBox(height: 10),

                    _label(l.rateCheckerMethod),
                    Row(children: [
                      Expanded(
                          child: _methodPill(
                              'ep', l.rateCheckerMethodDeclining)),
                      const SizedBox(width: 6),
                      Expanded(
                          child: _methodPill(
                              'ann', l.rateCheckerMethodEqual)),
                      const SizedBox(width: 6),
                      Expanded(
                          child: _methodPill(
                              'io', l.rateCheckerMethodInterestOnly)),
                    ]),

                    const SizedBox(height: 10),
                    _infoBox(l.rateCheckerInfoBox),
                    const SizedBox(height: 14),

                    ElevatedButton(
                      onPressed: _estimate,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _gold,
                          foregroundColor: const Color(0xFF1B4332),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14),
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 0),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(50))),
                      child: Text(l.rateCheckerButton,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l.resultDisclaimerShort,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
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
    );
  }

  Widget _buildResult() {
    final l = AppLocalizations.of(context)!;
    if (_estimatedRate == null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: const Color(0xFFEF5350).withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFFEF5350).withOpacity(0.25))),
        child: Row(children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFEF5350), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(l.rateCheckerNoResult,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF555555))),
          ),
        ]),
      );
    }

    final ratePct = (_estimatedRate! * 100).toStringAsFixed(2);

    return Column(children: [
      Text(l.rateCheckerResultHeader,
          style: const TextStyle(
              fontSize: 10, color: Color(0xFFAAAAAA))),
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
            Text(l.rateCheckerResultTitle,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFFFFFFFF99))),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text('$ratePct${l.homePerYear}',
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: _gold)),
            ),
            const SizedBox(height: 8),
            Text(l.rateCheckerResultNote,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFFFFFFFCC),
                    height: 1.5)),
            const SizedBox(height: 10),
            Text(l.rateCheckerResultDisclaimer,
                style: const TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFFFFFFFF77),
                    fontStyle: FontStyle.italic,
                    height: 1.4)),
          ],
        ),
      ),
    ]);
  }

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
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF888888),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888))),
      );

  Widget _field(TextEditingController ctrl, String hint,
          {bool isAmount = false,
          bool isInt = false,
          String? suffix,
          Function(String)? onChanged}) =>
      TextField(
        controller: ctrl,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
          filled: true,
          fillColor: _bg,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          suffixText: suffix,
          suffixStyle: const TextStyle(
              fontSize: 11, color: Color(0xFF999999)),
        ),
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A)),
        keyboardType: TextInputType.number,
        inputFormatters: isAmount
            ? [FilteringTextInputFormatter.allow(RegExp(r'[\d,]'))]
            : [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
      );

  Widget _infoBox(String text) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: _gold.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          const Icon(Icons.info_outline_rounded, size: 14, color: _gold),
          const SizedBox(width: 6),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF888888)))),
        ]),
      );
}
