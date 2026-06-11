import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/loan_model.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});
  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);

  final List<_LoanOption> _options = [
    _LoanOption(index: 1, color: const Color(0xFF1E88E5)),
    _LoanOption(index: 2, color: _gold),
  ];

  bool _compared = false;
  List<_LoanResult> _results = [];

  void _addOption() {
    if (_options.length >= 3) return;
    setState(() => _options.add(
      _LoanOption(index: _options.length + 1,
        color: const Color(0xFF4CAF50))));
  }

  void _removeOption(int index) {
    if (_options.length <= 2) return;
    setState(() => _options.removeAt(index));
  }

  void _compare() {
    final results = <_LoanResult>[];
    for (final opt in _options) {
      final loan = LoanModel(
        amount: opt.amount,
        termMonths: opt.term,
        gracePeriod: opt.grace,
        fixedRate: opt.fixedRate / 100,
        fixedPeriod: opt.fixedPeriod,
        floatRate: opt.floatRate / 100,
        method: opt.method,
        prepayRates: [0, 0, 0, 0, 0, 0],
      );
      final schedule = loan.buildSchedule();
      final totalInterest = schedule.fold(0.0, (s, r) => s + r.interest);
      final maxPay = schedule.map((r) => r.payment).reduce((a, b) => a > b ? a : b);
      final minPay = schedule.where((r) => r.payment > 0)
          .map((r) => r.payment).reduce((a, b) => a < b ? a : b);
      results.add(_LoanResult(
        index: opt.index, color: opt.color,
        principal: opt.amount, totalInterest: totalInterest,
        totalAmount: opt.amount + totalInterest,
        maxPayment: maxPay, minPayment: minPay,
      ));
    }
    setState(() { _results = results; _compared = true; });
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          const Text('So Sánh Khoản Vay',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A))),
          const SizedBox(height: 20),

          // Panels dọc
          ..._options.asMap().entries.map((e) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildOptionPanel(e.value, e.key),
            )),

          // Nút thêm phương án
          if (_options.length < 3) ...[
            OutlinedButton.icon(
              onPressed: _addOption,
              icon: const Icon(Icons.add_rounded, color: _gold),
              label: const Text('Thêm phương án',
                style: TextStyle(color: _gold, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 0),
                side: const BorderSide(color: _gold, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14))),
            ),
            const SizedBox(height: 12),
          ],

          // Nút so sánh
          ElevatedButton(
            onPressed: _compare,
            style: ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)),
            ),
            child: const Text('So sánh ngay',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
          const Text(
            '* Kết quả mang tính tham khảo. Để có quyết định tối ưu, hãy tham khảo thêm chuyên gia tài chính.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF888888),
              fontStyle: FontStyle.italic,
            ),
          ),

          if (_compared && _results.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildResults(),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionPanel(_LoanOption opt, int idx) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border(left: BorderSide(color: opt.color, width: 4)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Header
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(children: [
            Container(width: 10, height: 10,
              decoration: BoxDecoration(color: opt.color,
                shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text('Phương án ${opt.index}',
              style: const TextStyle(fontSize: 15,
                fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
          ]),
          if (_options.length > 2)
            GestureDetector(
              onTap: () => _removeOption(idx),
              child: const Icon(Icons.close_rounded,
                color: Color(0xFFCCCCCC), size: 20)),
        ])),

      // Fields
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
        child: Column(children: [
          _field(opt.amountCtrl, 'Tiền gốc (VNĐ)', isAmount: true,
            onChanged: (v) {
              final n = double.tryParse(v.replaceAll(',', ''));
              if (n != null) {
                setState(() => opt.amount = n);
                final fmt = _fmtFull(n);
                opt.amountCtrl.value = TextEditingValue(
                  text: fmt,
                  selection: TextSelection.collapsed(offset: fmt.length));
              }
            }),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _field(opt.fixedRateCtrl, 'Lãi suất cố định (%/năm)',
              onChanged: (v) => setState(() =>
                opt.fixedRate = double.tryParse(v) ?? opt.fixedRate))),
            const SizedBox(width: 10),
            Expanded(child: _field(opt.fixedPeriodCtrl, 'Thời gian cố định (tháng)',
              isInt: true,
              onChanged: (v) => setState(() =>
                opt.fixedPeriod = int.tryParse(v) ?? opt.fixedPeriod))),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _field(opt.floatRateCtrl, 'Lãi suất thả nổi (%/năm)',
              onChanged: (v) => setState(() =>
                opt.floatRate = double.tryParse(v) ?? opt.floatRate))),
            const SizedBox(width: 10),
            Expanded(child: _field(opt.termCtrl, 'Thời hạn vay (tháng)',
              isInt: true,
              onChanged: (v) => setState(() =>
                opt.term = int.tryParse(v) ?? opt.term))),
          ]),
          const SizedBox(height: 10),
          _field(opt.graceCtrl, 'Ân hạn gốc (tháng)', isInt: true,
            onChanged: (v) => setState(() =>
              opt.grace = int.tryParse(v) ?? opt.grace)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _methodBtn(opt, 'ep', 'Dư nợ giảm dần')),
            const SizedBox(width: 10),
            Expanded(child: _methodBtn(opt, 'ann', 'Trả góp đều')),
          ]),
        ]),
      ),
    ]),
  );

 Widget _field(TextEditingController ctrl, String label, {
  bool isInt = false, bool isAmount = false,
  Function(String)? onChanged}) =>
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF888888),
        ),
      ),
      const SizedBox(height: 4),
      TextField(
        controller: ctrl,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF5F0E8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 12),
        ),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        keyboardType: isInt
          ? TextInputType.number
          : const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: isAmount
          ? [FilteringTextInputFormatter.allow(RegExp(r'[\d,]'))]
          : isInt
            ? [FilteringTextInputFormatter.digitsOnly]
            : [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
        onChanged: onChanged,
      ),
    ],
  );

  Widget _methodBtn(_LoanOption opt, String val, String label) {
    final selected = opt.method == val;
    return GestureDetector(
      onTap: () => setState(() => opt.method = val),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected
            ? opt.color.withOpacity(0.12)
            : const Color(0xFFF5F0E8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? opt.color : Colors.transparent,
            width: 1.5)),
        child: Text(label, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
            color: selected ? opt.color : const Color(0xFF888888))),
      ),
    );
  }

  Widget _buildResults() {
    final minTotal = _results
      .map((r) => r.totalAmount)
      .reduce((a, b) => a < b ? a : b);
    final bestList = _results
      .where((r) => r.totalAmount == minTotal).toList();
    final allEqual = bestList.length == _results.length;

    final rows = [
      {'label': 'Tổng gốc', 'key': 'principal'},
      {'label': 'Tổng lãi', 'key': 'interest'},
      {'label': 'Mức cao nhất/tháng', 'key': 'maxPay'},
      {'label': 'Mức thấp nhất/tháng', 'key': 'minPay'},
      {'label': 'Tổng gốc và lãi', 'key': 'total'},
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          // Header vàng
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              color: _gold,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            child: Row(children: [
              const Expanded(flex: 3,
                child: Text('', style: TextStyle(fontSize: 12))),
              ..._results.map((r) => Expanded(flex: 2,
                child: Text('Phương Án ${r.index}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A))))),
            ]),
          ),

          // Data rows
          ...rows.map((row) => Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(
                color: Colors.grey.shade100, width: 1))),
            child: Row(children: [
              Expanded(flex: 3,
                child: Text(row['label']!,
                  style: const TextStyle(fontSize: 12,
                    color: Color(0xFF555555)))),
              ..._results.map((r) {
                double val;
                switch (row['key']) {
                  case 'principal': val = r.principal; break;
                  case 'interest': val = r.totalInterest; break;
                  case 'maxPay': val = r.maxPayment; break;
                  case 'minPay': val = r.minPayment; break;
                  default: val = r.totalAmount;
                }
                final isBest = row['key'] == 'total' &&
                  r.totalAmount == minTotal;
                return Expanded(flex: 2,
                  child: Text(_fmt(val),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isBest
                        ? _gold
                        : const Color(0xFF1A1A1A))));
              }),
            ]),
          )),
        ]),
      ),

      const SizedBox(height: 12),

      // Winner banner
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: allEqual
            ? const Color(0xFFE8F5E9)
            : bestList.first.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: allEqual
              ? const Color(0xFF4CAF50)
              : bestList.first.color.withOpacity(0.3))),
        child: Row(children: [
          Container(width: 40, height: 40,
            decoration: BoxDecoration(
              color: allEqual
                ? const Color(0xFF4CAF50).withOpacity(0.2)
                : bestList.first.color.withOpacity(0.2),
              shape: BoxShape.circle),
            child: Icon(
              allEqual
                ? Icons.balance_rounded
                : Icons.savings_outlined,
              color: allEqual
                ? const Color(0xFF4CAF50)
                : bestList.first.color,
              size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              allEqual
                ? 'Các phương án tiết kiệm bằng nhau'
                : bestList.length > 1
                  ? 'Phương án ${bestList.map((r) => r.index).join(" và ")} tiết kiệm bằng nhau'
                  : 'Phương án ${bestList.first.index} tiết kiệm nhất',
              style: TextStyle(fontSize: 14,
                fontWeight: FontWeight.w700,
                color: allEqual
                  ? const Color(0xFF4CAF50)
                  : bestList.first.color)),
            if (!allEqual)
              Text(
                'Mức chênh lệch: ${_fmtFull(_results.map((r) => r.totalAmount).reduce((a, b) => a > b ? a : b) - minTotal)} đ',
                style: const TextStyle(fontSize: 12,
                  color: Color(0xFF555555))),
          ])),
        ]),
      ),
    ]);
  }
}

class _LoanOption {
  final int index;
  final Color color;
  double amount = 2000000000;
  double fixedRate = 6.99;
  int fixedPeriod = 24;
  double floatRate = 11.79;
  int term = 240;
  int grace = 0;
  String method = 'ep';

  late TextEditingController amountCtrl;
  late TextEditingController fixedRateCtrl;
  late TextEditingController fixedPeriodCtrl;
  late TextEditingController floatRateCtrl;
  late TextEditingController termCtrl;
  late TextEditingController graceCtrl;

  _LoanOption({required this.index, required this.color}) {
    amountCtrl = TextEditingController(text: '2,000,000,000');
    fixedRateCtrl = TextEditingController(text: fixedRate.toString());
    fixedPeriodCtrl = TextEditingController(text: fixedPeriod.toString());
    floatRateCtrl = TextEditingController(text: floatRate.toString());
    termCtrl = TextEditingController(text: term.toString());
    graceCtrl = TextEditingController(text: '0');
  }
}

class _LoanResult {
  final int index;
  final Color color;
  final double principal;
  final double totalInterest;
  final double totalAmount;
  final double maxPayment;
  final double minPayment;

  _LoanResult({
    required this.index, required this.color,
    required this.principal, required this.totalInterest,
    required this.totalAmount, required this.maxPayment,
    required this.minPayment,
  });
}