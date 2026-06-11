import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/loan_model.dart';
import '../models/database_helper.dart';
import '../widgets/app_drawer.dart';
import 'schedule_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController(text: '2,000,000,000');
  final _termCtrl = TextEditingController(text: '240');
  final _graceCtrl = TextEditingController(text: '0');
  final _fixedRateCtrl = TextEditingController(text: '6.99');
  final _fixedPeriodCtrl = TextEditingController(text: '24');
  final _floatRateCtrl = TextEditingController(text: '11.79');
  final _p1Ctrl = TextEditingController(text: '3');
  final _p2Ctrl = TextEditingController(text: '2');
  final _p3Ctrl = TextEditingController(text: '1.5');
  final _p4Ctrl = TextEditingController(text: '1');
  final _p5Ctrl = TextEditingController(text: '0.5');
  final _p6Ctrl = TextEditingController(text: '0');
  String _method = 'ep';

  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);

  @override
  void dispose() {
    _amountCtrl.dispose(); _termCtrl.dispose(); _graceCtrl.dispose();
    _fixedRateCtrl.dispose(); _fixedPeriodCtrl.dispose();
    _floatRateCtrl.dispose(); _p1Ctrl.dispose(); _p2Ctrl.dispose();
    _p3Ctrl.dispose(); _p4Ctrl.dispose(); _p5Ctrl.dispose(); _p6Ctrl.dispose();
    super.dispose();
  }

  String _formatWithComma(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  void _onAmountChanged(String value) {
    final clean = value.replaceAll(',', '');
    if (clean.isEmpty) return;
    final n = int.tryParse(clean);
    if (n == null) return;
    final formatted = _formatWithComma(n);
    if (formatted == value) return;
    final oldCursor = _amountCtrl.selection.baseOffset;
    final oldLength = value.length;
    final newLength = formatted.length;
    final diff = newLength - oldLength;
    final newCursor = (oldCursor + diff).clamp(0, newLength);
    _amountCtrl.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursor),
    );
  }

  double _parseAmount() =>
      double.parse(_amountCtrl.text.replaceAll(',', ''));

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;
    final loan = LoanModel(
      amount: _parseAmount(),
      termMonths: int.parse(_termCtrl.text),
      gracePeriod: int.parse(_graceCtrl.text),
      fixedRate: double.parse(_fixedRateCtrl.text) / 100,
      fixedPeriod: int.parse(_fixedPeriodCtrl.text),
      floatRate: double.parse(_floatRateCtrl.text) / 100,
      method: _method,
      prepayRates: [0, 0, 0, 0, 0, 0],
    );
    final schedule = loan.buildSchedule();
    final totalInterest = schedule.fold(0.0, (s, r) => s + r.interest);
    await DatabaseHelper.instance.insert(HistoryEntry(
      type: 'mortgage',
      amount: loan.amount,
      fixedRate: loan.fixedRate,
      floatRate: loan.floatRate,
      termMonths: loan.termMonths,
      totalInterest: totalInterest,
      totalAmount: loan.amount + totalInterest,
      method: _method,
      createdAt: DateTime.now(),
    ));
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ScheduleScreen(loan: loan),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0E8),
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
        leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF1A1A1A)),
              onPressed: () => Navigator.pop(context),
            )
          : Builder(
              builder: (ctx) => GestureDetector(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.menu_rounded, color: _gold),
                ),
              ),
            ),
      ),
      drawer: AppDrawer(currentIndex: 0),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            const Text('Vay Thế Chấp',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A))),
            const SizedBox(height: 16),
            _sectionTitle('Thông tin khoản vay'),
            _infoCard(children: [
              _inputRowWide(Icons.account_balance_wallet_outlined,
                  'Số tiền vay', _amountField()),
              _divider(),
              _inputRow(Icons.access_time_outlined,
                'Thời gian vay (tháng)', _intField(_termCtrl, suffix: 'tháng')),
              _divider(),
              _inputRow(Icons.percent_outlined,
                'Lãi suất cố định (%/năm)', _decField(_fixedRateCtrl, suffix: '%')),
              _divider(),
              _inputRow(Icons.calendar_today_outlined,
                'Thời gian lãi suất cố định (tháng)', _intField(_fixedPeriodCtrl, suffix: 'tháng')),
              _divider(),
              _inputRow(Icons.show_chart_outlined,
                'Lãi suất thả nổi (%/năm)', _decField(_floatRateCtrl, suffix: '%')),
              _divider(),
              _inputRow(Icons.lock_clock_outlined,
                'Thời gian ân hạn gốc (tháng)', _intField(_graceCtrl, suffix: 'tháng')),
            ]),

            const SizedBox(height: 16),
            _sectionTitle('Phương thức thanh toán'),
            _infoCard(children: [
              _methodRow('ep', 'Gốc chia đều, lãi giảm dần',
                'Gốc cố định hàng tháng, lãi giảm dần'),
              _divider(),
              _methodRow('ann', 'Trả góp đều hàng tháng',
                'Tổng tiền thanh toán hàng tháng bằng nhau'),
              _divider(),
              _methodRow('io', 'Chỉ trả lãi',
                'Chỉ trả lãi mỗi tháng, hoàn trả toàn bộ gốc vào tháng cuối'),
            ]),

            const SizedBox(height: 28),
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
              child: const Text('Tính lịch trả nợ',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
                  letterSpacing: 0.3)),
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
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(t, style: const TextStyle(fontSize: 13,
      fontWeight: FontWeight.w600, color: Color(0xFF888888))),
  );

  Widget _infoCard({required List<Widget> children}) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(children: children),
  );

  Widget _divider() => Divider(
    height: 1, thickness: 0.5,
    indent: 16, endIndent: 16,
    color: Colors.grey.shade200,
  );

  Widget _inputRow(IconData icon, String label, Widget field) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: _gold),
        const SizedBox(width: 12),
        Expanded(flex: 3,
          child: Text(label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF444444)))),
        const SizedBox(width: 8),
        SizedBox(width: 90, child: field),
      ]),
  );

  Widget _inputRowWide(IconData icon, String label, Widget field) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(children: [
      Icon(icon, size: 20, color: _gold),
      const SizedBox(width: 12),
      Expanded(flex: 2,
        child: Text(label, style: const TextStyle(fontSize: 13,
          color: Color(0xFF444444)))),
      Expanded(flex: 3, child: field),
    ]),
  );

  Widget _methodRow(String val, String label, String sub) {
    final selected = _method == val;
    return GestureDetector(
      onTap: () => setState(() => _method = val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _gold.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(children: [
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? _gold : Colors.grey.shade400, width: 2),
            ),
            child: selected ? Center(
              child: Container(width: 10, height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: _gold)),
            ) : null,
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600,
                color: selected ? const Color(0xFF1A1A1A) : const Color(0xFF444444))),
              Text(sub, style: const TextStyle(
                fontSize: 11, color: Color(0xFF888888))),
            ],
          )),
        ]),
      ),
    );
  }

  Widget _prepayRow(String l1, TextEditingController c1,
      String l2, TextEditingController c2) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        Expanded(child: Row(children: [
          Text(l1, style: const TextStyle(fontSize: 13, color: Color(0xFF444444))),
          const SizedBox(width: 8),
          Expanded(child: _decField(c1, suffix: '%')),
        ])),
        const SizedBox(width: 16),
        Expanded(child: Row(children: [
          Text(l2, style: const TextStyle(fontSize: 13, color: Color(0xFF444444))),
          const SizedBox(width: 8),
          Expanded(child: _decField(c2, suffix: '%')),
        ])),
      ]),
    );

  Widget _amountField() => TextFormField(
    controller: _amountCtrl,
    textAlign: TextAlign.right,
    decoration: InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300)),
      suffixText: 'đ',
      suffixStyle: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
    ),
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d,]'))],
    onChanged: _onAmountChanged,
    validator: (v) {
      if (v == null || v.isEmpty) return 'Nhập số tiền';
      final clean = v.replaceAll(',', '');
      if (int.tryParse(clean) == null) return 'Không hợp lệ';
      return null;
    },
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
  );

  Widget _intField(TextEditingController ctrl, {String suffix = ''}) =>
    TextFormField(
      controller: ctrl,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300)),
        suffixText: suffix,
        suffixStyle: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (v) => (v == null || v.isEmpty) ? 'Nhập giá trị' : null,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    );

  Widget _decField(TextEditingController ctrl, {String suffix = ''}) =>
    TextFormField(
      controller: ctrl,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300)),
        suffixText: suffix,
        suffixStyle: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      validator: (v) => (v == null || v.isEmpty) ? 'Nhập giá trị' : null,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    );
}