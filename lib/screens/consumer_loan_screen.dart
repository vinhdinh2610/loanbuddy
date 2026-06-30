import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../models/database_helper.dart';
import 'consumer_schedule_screen.dart';
import 'dart:math' as math;
import '../widgets/responsive_helper.dart';

class ConsumerLoanScreen extends StatefulWidget {
  const ConsumerLoanScreen({super.key});
  @override
  State<ConsumerLoanScreen> createState() => _ConsumerLoanScreenState();
}

class _ConsumerLoanScreenState extends State<ConsumerLoanScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _navy = Color(0xFF1B4332);

  double _loanAmount = 100000000;
  double _annualRate = 18;
  double _termMonths = 24;

  late TextEditingController _amountController;
  late TextEditingController _rateController;
  late TextEditingController _termController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: _fmtFull(_loanAmount));
    _rateController = TextEditingController(text: _annualRate.toStringAsFixed(1));
    _termController = TextEditingController(text: _termMonths.round().toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    _termController.dispose();
    super.dispose();
  }

  double get _monthlyRate => _annualRate / 100 / 12;

  double get _monthlyPayment {
    final r = _monthlyRate;
    final n = _termMonths;
    if (r == 0) return _loanAmount / n;
    return _loanAmount * r * _pow(1 + r, n) / (_pow(1 + r, n) - 1);
  }

  double get _totalInterest => _monthlyPayment * _termMonths - _loanAmount;
  double get _totalAmount => _loanAmount + _totalInterest;

  double _pow(double base, double exp) {
    double result = 1;
    for (int i = 0; i < exp.round(); i++) {
      result *= base;
    }
    return result;
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

  Future<void> _calculate() async {
    await DatabaseHelper.instance.insert(HistoryEntry(
      type: 'consumer',
      amount: _loanAmount,
      fixedRate: 0,
      floatRate: _annualRate / 100,
      termMonths: _termMonths.round(),
      totalInterest: _totalInterest,
      totalAmount: _totalAmount,
      method: 'consumer',
      createdAt: DateTime.now(),
    ));
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ConsumerScheduleScreen(
        loanAmount: _loanAmount,
        annualRate: _annualRate,
        termMonths: _termMonths.round(),
        prepayFee: 0,
        monthlyPayment: _monthlyPayment,
        totalInterest: _totalInterest,
        totalAmount: _totalAmount,
      ),
    ));
  }

  Widget _inputBox(TextEditingController ctrl, String suffix, {
    bool isDecimal = false,
    required Function(String) onChanged,
  }) =>
      SizedBox(
        width: 90,
        child: TextField(
          controller: ctrl,
          textAlign: TextAlign.right,
          keyboardType: isDecimal
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          inputFormatters: isDecimal
              ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))]
              : [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A)),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 6),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            suffixText: suffix,
            suffixStyle: const TextStyle(
                fontSize: 12, color: Color(0xFF888888)),
          ),
          onChanged: onChanged,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final loanPct = _totalAmount > 0 ? _loanAmount / _totalAmount : 1.0;
    final interestPct = _totalAmount > 0 ? _totalInterest / _totalAmount : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
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
            Text(l.consumerTitle,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A))),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Column(children: [
                Row(children: [
                  SizedBox(
                    width: 150, height: 150,
                    child: CustomPaint(
                      painter: _PieChartPainter(
                        loanPct: loanPct,
                        interestPct: interestPct,
                        goldColor: _gold,
                        navyColor: _navy,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    _legendItem(_gold, l.consumerLoanAmount, _fmtFull(_loanAmount)),
                    const SizedBox(height: 16),
                    _legendItem(_navy, l.consumerTotalInterest, _fmtFull(_totalInterest)),
                  ])),
                ]),
                const SizedBox(height: 16),
                Divider(color: Colors.grey.shade100),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: Column(children: [
                    Text(l.consumerMonthlyPayment,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF888888))),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(_fmtFull(_monthlyPayment),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A))),
                    ),
                  ])),
                  Container(
                      width: 1, height: 40, color: Colors.grey.shade200),
                  Expanded(child: Column(children: [
                    Text(l.consumerTotalPayment,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF888888))),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(_fmtFull(_totalAmount),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A))),
                    ),
                  ])),
                ]),
              ]),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Column(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Expanded(child: Text(l.consumerLoanAmount,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A)))),
                    Expanded(child: TextField(
                        controller: _amountController,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A)),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                        ),
                        onChanged: (v) {
                          final clean = v.replaceAll(',', '');
                          final n = double.tryParse(clean);
                          if (n != null && n >= 5000000 && n <= 2000000000) {
                            setState(() => _loanAmount = n);
                            final formatted = _fmtFull(n);
                            _amountController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                  offset: formatted.length),
                            );
                          }
                        },
                      ),
                    ),
                  ]),
                  SliderTheme(
                    data: _sliderTheme(context),
                    child: Slider(
                      value: _loanAmount,
                      min: 5000000,
                      max: 2000000000,
                      divisions: 1995,
                      onChanged: (v) {
                        setState(() => _loanAmount = v);
                        _amountController.text = _fmtFull(v);
                      },
                    ),
                  ),
                ]),

                const SizedBox(height: 12),

                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Expanded(child: Text(l.consumerAnnualRate,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A)))),
                    _inputBox(_rateController, '%', isDecimal: true,
                        onChanged: (v) {
                      final n = double.tryParse(v);
                      if (n != null && n >= 6 && n <= 45) {
                        setState(() => _annualRate = n);
                      }
                    }),
                  ]),
                  SliderTheme(
                    data: _sliderTheme(context),
                    child: Slider(
                      value: _annualRate.clamp(6, 45),
                      min: 6, max: 45, divisions: 78,
                      onChanged: (v) {
                        setState(() => _annualRate = v);
                        _rateController.text = v.toStringAsFixed(1);
                      },
                    ),
                  ),
                ]),

                const SizedBox(height: 12),

                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Expanded(child: Text(l.consumerTermMonths,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A)))),
                    _inputBox(_termController, 'tháng',
                        onChanged: (v) {
                      final n = int.tryParse(v);
                      if (n != null && n >= 3 && n <= 84) {
                        setState(() => _termMonths = n.toDouble());
                      }
                    }),
                  ]),
                  SliderTheme(
                    data: _sliderTheme(context),
                    child: Slider(
                      value: _termMonths.clamp(3, 84),
                      min: 3, max: 84, divisions: 81,
                      onChanged: (v) {
                        setState(() => _termMonths = v);
                        _termController.text = v.round().toString();
                      },
                    ),
                  ),
                ]),
              ]),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: const Color(0xFF1B4332),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: Text(l.consumerScheduleButton,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800)),
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
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label, String value) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 12, height: 12,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF888888))),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A))),
            ])),
      ]);

  SliderThemeData _sliderTheme(BuildContext context) =>
      SliderTheme.of(context).copyWith(
        activeTrackColor: const Color(0xFF1B4332),
        inactiveTrackColor: Colors.grey.shade200,
        thumbColor: _gold,
        overlayColor: _gold.withOpacity(0.1),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        trackHeight: 4,
      );
}

class _PieChartPainter extends CustomPainter {
  final double loanPct;
  final double interestPct;
  final Color goldColor;
  final Color navyColor;

  _PieChartPainter({
    required this.loanPct, required this.interestPct,
    required this.goldColor, required this.navyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const startAngle = -math.pi / 2;
    final loanSweep = 2 * math.pi * loanPct;
    final interestSweep = 2 * math.pi * interestPct;

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle, loanSweep, true,
        Paint()..color = goldColor..style = PaintingStyle.fill);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + loanSweep, interestSweep, true,
        Paint()..color = navyColor..style = PaintingStyle.fill);

    _drawText(canvas, center, radius, startAngle, loanSweep,
        '${(loanPct * 100).toStringAsFixed(0)}%', Colors.white);

    if (interestPct > 0.05) {
      _drawText(canvas, center, radius, startAngle + loanSweep,
          interestSweep,
          '${(interestPct * 100).toStringAsFixed(0)}%', Colors.white);
    }
  }

  void _drawText(Canvas canvas, Offset center, double radius,
      double startAngle, double sweep, String text, Color color) {
    final midAngle = startAngle + sweep / 2;
    final textRadius = radius * 0.65;
    final textCenter = Offset(
      center.dx + textRadius * math.cos(midAngle),
      center.dy + textRadius * math.sin(midAngle),
    );
    final tp = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, textCenter - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_PieChartPainter old) =>
      old.loanPct != loanPct || old.interestPct != interestPct;
}
