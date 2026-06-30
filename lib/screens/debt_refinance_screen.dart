import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../widgets/responsive_helper.dart';

class DebtRefinanceScreen extends StatefulWidget {
  const DebtRefinanceScreen({super.key});
  @override
  State<DebtRefinanceScreen> createState() => _DebtRefinanceScreenState();
}

class _DebtRefinanceScreenState extends State<DebtRefinanceScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);
  static const _darkGreen = Color(0xFF1B4332);

  final _balanceCtrl = TextEditingController(text: '0');
  final _remainingTermCtrl = TextEditingController(text: '0');
  final _currentRateCtrl = TextEditingController(text: '0');
  final _penaltyCtrl = TextEditingController(text: '0');
  String _oldMethod = 'ep';

  final _newTermCtrl = TextEditingController(text: '0');
  final _newFixedRateCtrl = TextEditingController(text: '0');
  final _newFixedPeriodCtrl = TextEditingController(text: '0');
  final _newFloatRateCtrl = TextEditingController(text: '0');
  final _feeCtrl = TextEditingController(text: '0');
  String _newMethod = 'ep';

  bool _showResult = false;
  bool _hasError = false;

  double _totalCost = 0;
  double _avgMonthlySaving = 0;
  double _savingDuringFixedPeriod = 0;
  int? _breakevenMonth;
  double _totalInterestSaved = 0;

  static const int _maxMonths = 480;

  @override
  void dispose() {
    _balanceCtrl.dispose();
    _remainingTermCtrl.dispose();
    _currentRateCtrl.dispose();
    _penaltyCtrl.dispose();
    _newTermCtrl.dispose();
    _newFixedRateCtrl.dispose();
    _newFixedPeriodCtrl.dispose();
    _newFloatRateCtrl.dispose();
    _feeCtrl.dispose();
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

  void _handleAmountInput(TextEditingController ctrl, String v) {
    final clean = v.replaceAll(',', '');
    final n = double.tryParse(clean);
    if (n != null) {
      final fmt = _fmtFull(n);
      ctrl.value = TextEditingValue(
          text: fmt, selection: TextSelection.collapsed(offset: fmt.length));
    }
  }

  double _parseAmount(String v) => double.tryParse(v.replaceAll(',', '')) ?? 0;

  double _powCalc(double base, int exp) {
    double result = 1;
    for (int i = 0; i < exp; i++) {
      result *= base;
    }
    return result;
  }

  double _pmt(double ratePerMonth, int n, double pv) {
    if (ratePerMonth == 0) return n > 0 ? pv / n : 0;
    final factor = _powCalc(1 + ratePerMonth, n);
    return pv * ratePerMonth * factor / (factor - 1);
  }

  double _annuityBalanceAfter(double pv, double ratePerMonth, double payment, int k) {
    if (ratePerMonth == 0) return (pv - payment * k).clamp(0, pv).toDouble();
    final factor = _powCalc(1 + ratePerMonth, k);
    return (pv * factor - payment * (factor - 1) / ratePerMonth).clamp(0, pv).toDouble();
  }

  void _calculate() {
    final l = AppLocalizations.of(context)!;
    final balance = _parseAmount(_balanceCtrl.text);
    final remainingTerm = int.tryParse(_remainingTermCtrl.text) ?? 0;
    final currentRate = (double.tryParse(_currentRateCtrl.text) ?? 0) / 100;
    final penaltyPct = (double.tryParse(_penaltyCtrl.text) ?? 0) / 100;

    final newTerm = int.tryParse(_newTermCtrl.text) ?? 0;
    final newFixedRate = (double.tryParse(_newFixedRateCtrl.text) ?? 0) / 100;
    final newFixedPeriod = int.tryParse(_newFixedPeriodCtrl.text) ?? 0;
    final newFloatRate = (double.tryParse(_newFloatRateCtrl.text) ?? 0) / 100;
    final fee = _parseAmount(_feeCtrl.text);

    if (balance <= 0 ||
        remainingTerm <= 0 ||
        currentRate <= 0 ||
        newTerm <= 0 ||
        newFixedRate <= 0 ||
        newFloatRate <= 0) {
      setState(() => _hasError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.refinanceValidation),
          backgroundColor: _darkGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final newAmount = balance;

    final oldPrincipalFixed = balance / remainingTerm;
    final oldPmt = _pmt(currentRate / 12, remainingTerm, balance);

    final newPrincipalFixed = newAmount / newTerm;
    final newPmtFixedPhase = _pmt(newFixedRate / 12, newTerm, newAmount);

    double balanceAtFloatStart;
    if (_newMethod == 'ep') {
      balanceAtFloatStart =
          (newAmount - newPrincipalFixed * newFixedPeriod).clamp(0, newAmount).toDouble();
    } else {
      balanceAtFloatStart = _annuityBalanceAfter(
          newAmount, newFixedRate / 12, newPmtFixedPhase, newFixedPeriod);
    }
    final remainingAfterFixed = newTerm - newFixedPeriod;
    final newPmtFloatPhase = remainingAfterFixed > 0
        ? _pmt(newFloatRate / 12, remainingAfterFixed, balanceAtFloatStart)
        : 0.0;

    double balanceOldAt(int m) {
      if (m > remainingTerm) return 0;
      if (_oldMethod == 'ep') {
        return (balance - oldPrincipalFixed * (m - 1)).clamp(0, balance).toDouble();
      } else {
        return _annuityBalanceAfter(balance, currentRate / 12, oldPmt, m - 1);
      }
    }

    double balanceNewAt(int m) {
      if (m > newTerm) return 0;
      if (_newMethod == 'ep') {
        return (newAmount - newPrincipalFixed * (m - 1)).clamp(0, newAmount).toDouble();
      } else {
        if (m <= newFixedPeriod) {
          return _annuityBalanceAfter(newAmount, newFixedRate / 12, newPmtFixedPhase, m - 1);
        } else {
          final kAfter = m - newFixedPeriod - 1;
          return _annuityBalanceAfter(
              balanceAtFloatStart, newFloatRate / 12, newPmtFloatPhase, kAfter);
        }
      }
    }

    double rateNewAt(int m) => (m <= newFixedPeriod) ? newFixedRate : newFloatRate;

    final penaltyAmount = balance * penaltyPct;
    final totalCost = penaltyAmount + fee;

    double cumulativeSaving = 0;
    double totalInterestOld = 0;
    double totalInterestNew = 0;
    double savingDuringFixedPeriod = 0;
    int? breakevenMonth;
    final maxTerm = remainingTerm > newTerm ? remainingTerm : newTerm;
    final loopLimit = maxTerm < _maxMonths ? maxTerm : _maxMonths;

    for (int m = 1; m <= loopLimit; m++) {
      final balOld = balanceOldAt(m);
      final interestOld = balOld * currentRate / 12;
      totalInterestOld += interestOld;

      final balNew = balanceNewAt(m);
      final interestNew = balNew * rateNewAt(m) / 12;
      totalInterestNew += interestNew;

      final monthlySaving = interestOld - interestNew;
      cumulativeSaving += monthlySaving;
      if (breakevenMonth == null && cumulativeSaving >= totalCost) {
        breakevenMonth = m;
      }

      if (m <= newFixedPeriod) {
        savingDuringFixedPeriod += monthlySaving;
      }
    }

    final totalInterestSaved = totalInterestOld - totalInterestNew - totalCost;
    final avgMonthlySaving = newTerm > 0 ? totalInterestSaved / newTerm : 0.0;

    setState(() {
      _totalCost = totalCost;
      _avgMonthlySaving = avgMonthlySaving;
      _savingDuringFixedPeriod = savingDuringFixedPeriod;
      _breakevenMonth = breakevenMonth;
      _totalInterestSaved = totalInterestSaved;
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
      body: ResponsiveFormWidth(
        maxWidth: 480,
        child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          Text(l.refinanceTitle,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 4),
          Text(l.refinanceSubtitle,
              style: const TextStyle(fontSize: 14, color: Color(0xFF888888))),
          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _cardHeader(
                icon: Icons.account_balance_outlined,
                iconBg: _gold.withOpacity(0.12),
                iconColor: _gold,
                title: l.refinanceCurrentLoan,
                subtitle: l.refinanceCurrentLoanInfo,
              ),
              const Divider(height: 1, color: Color(0xFFF0EBE0)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  _label(l.refinanceRemainingBalance),
                  _field(_balanceCtrl, '0',
                      isAmount: true,
                      onChanged: (v) => setState(
                          () => _handleAmountInput(_balanceCtrl, v))),
                  const SizedBox(height: 10),

                  _twoFieldRow(
                    leftLabel: l.refinanceRemainingTerm,
                    leftChild: _field(_remainingTermCtrl, '0',
                        isInt: true, suffix: l.unitMonths),
                    rightLabel: l.refinanceCurrentRate,
                    rightChild: _field(_currentRateCtrl, '0',
                        isDecimal: true, suffix: l.homePerYear),
                  ),
                  const SizedBox(height: 10),

                  _label(l.refinancePrepaymentFee),
                  _field(_penaltyCtrl, '0', isDecimal: true, suffix: '%'),
                  const SizedBox(height: 10),

                  _label(l.refinancePaymentMethod),
                  Row(children: [
                    Expanded(
                        child: _methodPill('ep', l.refinanceMethodDeclining, _oldMethod,
                            (v) => setState(() => _oldMethod = v))),
                    const SizedBox(width: 6),
                    Expanded(
                        child: _methodPill('ann', l.refinanceMethodEqual, _oldMethod,
                            (v) => setState(() => _oldMethod = v))),
                  ]),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 14),

          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _cardHeader(
                icon: Icons.compare_arrows_rounded,
                iconBg: const Color(0xFFE3F2FD),
                iconColor: const Color(0xFF1565C0),
                title: l.refinanceNewLoan,
                subtitle: l.refinanceNewLoanInfo,
              ),
              const Divider(height: 1, color: Color(0xFFF0EBE0)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  _label(l.refinanceNewAmount),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFEFEAE0),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      _fmtFull(_parseAmount(_balanceCtrl.text)),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF999999)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _label(l.refinanceNewTerm),
                  _field(_newTermCtrl, '0', isInt: true, suffix: l.unitMonths),
                  const SizedBox(height: 10),

                  _twoFieldRow(
                    leftLabel: l.refinanceFixedRate,
                    leftChild: _field(_newFixedRateCtrl, '0',
                        isDecimal: true, suffix: l.homePerYear),
                    rightLabel: l.refinancePromoTerm,
                    rightChild: _field(_newFixedPeriodCtrl, '0',
                        isInt: true, suffix: l.unitMonths),
                  ),
                  const SizedBox(height: 10),

                  _label(l.refinanceFloatingRate),
                  _field(_newFloatRateCtrl, '0', isDecimal: true, suffix: l.homePerYear),
                  const SizedBox(height: 10),

                  _label(l.refinanceProcessingFee),
                  _field(_feeCtrl, '0',
                      isAmount: true,
                      onChanged: (v) => _handleAmountInput(_feeCtrl, v)),
                  const SizedBox(height: 10),

                  _label(l.refinancePaymentMethod),
                  Row(children: [
                    Expanded(
                        child: _methodPill('ep', l.refinanceMethodDeclining, _newMethod,
                            (v) => setState(() => _newMethod = v))),
                    const SizedBox(width: 6),
                    Expanded(
                        child: _methodPill('ann', l.refinanceMethodEqual, _newMethod,
                            (v) => setState(() => _newMethod = v))),
                  ]),

                  const SizedBox(height: 16),
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
                    child: Text(l.refinanceButton,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.resultDisclaimer,
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
              l.refinanceNoResult,
              style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
            ),
          ),
        ]),
      );
    }

    return Column(children: [
      Text(l.refinanceResultHeader,
          style: const TextStyle(fontSize: 10, color: Color(0xFFAAAAAA))),
      const SizedBox(height: 10),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.refinanceTotalCost,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Color(0xFFFFFFFF99))),
                  const SizedBox(width: 10),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(_fmtFull(_totalCost),
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFF5F0E8))),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(l.refinanceBreakevenMonths,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: Color(0xFFFFFFFF99))),
                    const SizedBox(height: 4),
                    Text(
                      _breakevenMonth != null
                          ? l.refinanceBreakevenValue(_breakevenMonth!)
                          : l.refinanceNoBreakeven,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w800, color: _gold),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0x22FFFFFF))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _savingRow(l.refinanceInterestSavedPromo,
                      _fmtFull(_savingDuringFixedPeriod)),
                  const SizedBox(height: 10),
                  _savingRow(l.refinanceInterestSavedTotal,
                      _fmtFull(_totalInterestSaved)),
                  const SizedBox(height: 10),
                  _savingRow(l.refinanceInterestSavedMonthly,
                      _fmtFull(_avgMonthlySaving)),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Text(
              l.refinanceResultDisclaimer,
              style: const TextStyle(
                  fontSize: 9.5,
                  color: Color(0xFFFFFFFF77),
                  fontStyle: FontStyle.italic,
                  height: 1.4),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _savingRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(label,
                style: const TextStyle(fontSize: 11, color: Color(0xFFFFFFFFAA))),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF5F0E8))),
          ),
        ],
      );

  Widget _methodPill(
      String value, String label, String groupValue, ValueChanged<String> onChanged) {
    final selected = groupValue == value;
    return GestureDetector(
      onTap: () => onChanged(value),
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
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF888888),
          ),
        ),
      ),
    );
  }

  Widget _cardHeader({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(children: [
        Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A))),
            Text(subtitle,
                style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
          ]),
        ),
      ]),
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
          bool isDecimal = false,
          String? suffix,
          Function(String)? onChanged}) =>
      TextField(
        controller: ctrl,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
          filled: true,
          fillColor: _bg,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          suffixText: suffix,
          suffixStyle: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
        ),
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
        keyboardType: isDecimal
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.number,
        inputFormatters: isAmount
            ? [FilteringTextInputFormatter.allow(RegExp(r'[\d,]'))]
            : isDecimal
                ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))]
                : [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
      );
}
