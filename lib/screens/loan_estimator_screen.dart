import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class LoanEstimatorScreen extends StatefulWidget {
  const LoanEstimatorScreen({super.key});
  @override
  State<LoanEstimatorScreen> createState() => _LoanEstimatorScreenState();
}

class _LoanEstimatorScreenState extends State<LoanEstimatorScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);
  static const double _annualRate = 0.12;

  // === Kiểm tra năng lực ===
  final _incomeCtrl = TextEditingController(text: '0');
  final _expenseCtrl = TextEditingController(text: '0');
  final _existingDebtCtrl = TextEditingController(text: '0');
  final _loanAmountCtrl = TextEditingController(text: '0');
  final _termCtrl = TextEditingController(text: '0');
  double _income = 55000000;
  double _expense = 15000000;
  double _existingDebt = 12000000;
  double _loanAmount = 2000000000;
  int _term = 360;
  bool _showResult = false;

  double _emi = 0;
  double _dsr = 0;
  double _rir = 0;
  double _remaining = 0;

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

  void _handleAmountInput(
      TextEditingController ctrl, Function(double) setter, String v) {
    final n = double.tryParse(v.replaceAll(',', ''));
    if (n != null) {
      setter(n);
      final fmt = _fmtFull(n);
      ctrl.value = TextEditingValue(
          text: fmt, selection: TextSelection.collapsed(offset: fmt.length));
    }
  }

  void _calc() {
    final r = _annualRate / 12;
    final emi = _loanAmount * r * pow(1 + r, _term) / (pow(1 + r, _term) - 1);
    final dsr = _income > 0
        ? (_existingDebt + emi) / _income
        : double.infinity;
    final remaining = _income - _expense - _existingDebt - emi;
    final rir = _expense > 0 ? remaining / _expense : 0.0;

    setState(() {
      _emi = emi;
      _dsr = dsr;
      _rir = rir;
      _remaining = remaining;
      _showResult = true;
    });
  }

  _RirLevel _getRirLevel() {
    if (_dsr > 1.0) return _RirLevel.cantBorrow;
    if (_rir < 0) return _RirLevel.imbalanced;
    if (_rir < 0.5) return _RirLevel.highPressure;
    if (_rir < 1.0) return _RirLevel.consider;
    if (_rir < 1.5) return _RirLevel.safe;
    return _RirLevel.verySafe;
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
      {bool isAmount = false, bool isInt = false, Function(String)? onChanged}) =>
      TextField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
          filled: true,
          fillColor: const Color(0xFFF5F0E8),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)),
        keyboardType: isInt
            ? TextInputType.number
            : const TextInputType.numberWithOptions(decimal: false),
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
                  style: const TextStyle(fontSize: 11, color: Color(0xFF888888)))),
        ]),
      );

  Widget _buildResult() {
    final level = _getRirLevel();
    final info = _ririInfo(level);

    return Column(children: [
      // Card 1: Phù hợp không?
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: info.color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: info.color.withOpacity(0.25))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                  color: info.color.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(info.icon, color: info.color, size: 20)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Khoản vay này có phù hợp với bạn không?',
                style: TextStyle(fontSize: 11, color: Color(0xFF888888))),
            const SizedBox(height: 2),
            Text(info.label,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: info.color)),
            const SizedBox(height: 4),
            Text(info.message,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF555555), height: 1.4)),
          ])),
        ]),
      ),

      const SizedBox(height: 10),

      // 3 card xếp dọc
      _miniCard(
        label: 'Khoản trả dự kiến là',
        value: '${_fmtShort(_emi)}/tháng',
      ),
      const SizedBox(height: 8),
      _miniCard(
        label: 'Mức áp lực tài chính là',
        value: info.label,
        valueColor: info.color,
      ),
      const SizedBox(height: 8),
      _miniCard(
        label: 'Sau khi trả khoản vay, bạn còn lại là',
        value: '${_fmtShort(_remaining)}/tháng',
        valueColor: _remaining >= 0
            ? const Color(0xFF1A1A1A)
            : const Color(0xFFEF5350),
      ),
    ]);
  }

  Widget _miniCard({
  required String label,
  required String value,
  Color? valueColor,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F0E8),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Flexible(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF888888)))),
        const SizedBox(width: 12),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? const Color(0xFF1A1A1A)))),
      ]),
    );

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          const Text('Sức Khỏe Tài Chính',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 4),
          const Text('Đánh giá khoản vay có phù hợp với bạn không',
              style: TextStyle(fontSize: 14, color: Color(0xFF888888))),
          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(children: [
                  Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                          color: _gold.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.account_balance_wallet_outlined,
                          color: _gold, size: 18)),
                  const SizedBox(width: 10),
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Đánh giá sức khỏe tài chính',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A))),
                    Text('Nhập thông tin để đánh giá sức khỏe tài chính',
                        style: TextStyle(
                            fontSize: 11, color: Color(0xFF888888))),
                  ]),
                ]),
              ),
              const Divider(height: 1, color: Color(0xFFF0EBE0)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  _label('Thu nhập thực nhận mỗi tháng của bạn (VNĐ)'),
                  _field(_incomeCtrl, '55,000,000',
                      isAmount: true,
                      onChanged: (v) => _handleAmountInput(
                          _incomeCtrl, (n) => _income = n, v)),
                  const SizedBox(height: 10),
                  _label('Mỗi tháng bạn chi tiêu khoảng bao nhiêu (VNĐ)'),
                  _field(_expenseCtrl, '15,000,000',
                      isAmount: true,
                      onChanged: (v) => _handleAmountInput(
                          _expenseCtrl, (n) => _expense = n, v)),
                  const SizedBox(height: 10),
                  _label('Hiện tại bạn đang trả góp các khoản vay bao nhiêu mỗi tháng? (VNĐ)'),
                  _field(_existingDebtCtrl, '0',
                      isAmount: true,
                      onChanged: (v) => _handleAmountInput(
                          _existingDebtCtrl, (n) => _existingDebt = n, v)),
                  const SizedBox(height: 10),
                  _label('Số tiền muốn vay (VNĐ)'),
                  _field(_loanAmountCtrl, '2,000,000,000',
                      isAmount: true,
                      onChanged: (v) => _handleAmountInput(
                          _loanAmountCtrl, (n) => _loanAmount = n, v)),
                  const SizedBox(height: 10),
                  _label('Thời hạn vay (tháng)'),
                  _field(_termCtrl, '360',
                      isInt: true,
                      onChanged: (v) =>
                          setState(() => _term = int.tryParse(v) ?? _term)),

                  const SizedBox(height: 8),
                  _infoBox(
                      'Lãi suất ước tính 12%/năm · Phương thức trả góp đều hàng tháng'),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: _calc,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _gold,
                        foregroundColor: const Color(0xFF1B4332),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: const Text('Đánh giá',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800)),
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
    );
  }
}

enum _RirLevel { cantBorrow, imbalanced, highPressure, consider, safe, verySafe }

class _LevelInfo {
  final String label;
  final String message;
  final Color color;
  final IconData icon;
  const _LevelInfo(
      {required this.label,
      required this.message,
      required this.color,
      required this.icon});
}

_LevelInfo _ririInfo(_RirLevel level) {
  switch (level) {
    case _RirLevel.cantBorrow:
      return const _LevelInfo(
        label: 'Không thể vay',
        message: 'Bạn không thể vay trong thời điểm này. Khoản trả vượt quá toàn bộ thu nhập của bạn.',
        color: Color(0xFFD32F2F),
        icon: Icons.block_outlined,
      );
    case _RirLevel.imbalanced:
      return const _LevelInfo(
        label: 'Mất cân đối tài chính',
        message: 'Thu nhập của bạn không đủ để trang trải chi tiêu và khoản vay này. Bạn nên giảm số tiền vay, kéo dài thời hạn, hoặc tăng thu nhập trước khi vay.',
        color: Color(0xFFEF5350),
        icon: Icons.warning_amber_rounded,
      );
    case _RirLevel.highPressure:
      return const _LevelInfo(
        label: 'Áp lực cao',
        message: 'Sau khi trả khoản vay, số tiền còn lại chưa đến nửa tháng chi tiêu. Một khoản phát sinh nhỏ cũng có thể gây khó khăn. Nên cân nhắc giảm số tiền vay hoặc kéo dài thời hạn.',
        color: Color(0xFFFF7043),
        icon: Icons.trending_up_rounded,
      );
    case _RirLevel.consider:
      return const _LevelInfo(
        label: 'Cần cân nhắc',
        message: 'Khoản vay này tạo ra một chút áp lực trong những tháng có chi phí phát sinh. Bạn vẫn có thể vay nhưng nên có quỹ dự phòng ít nhất 3 tháng chi tiêu trước khi quyết định.',
        color: Color(0xFFE8A020),
        icon: Icons.info_outline_rounded,
      );
    case _RirLevel.safe:
      return const _LevelInfo(
        label: 'An toàn',
        message: 'Khoản vay này nằm trong vùng tài chính an toàn. Bạn vẫn còn đủ dư địa để xử lý các chi phí phát sinh hàng tháng.',
        color: Color(0xFF43A047),
        icon: Icons.check_circle_outline_rounded,
      );
    case _RirLevel.verySafe:
      return const _LevelInfo(
        label: 'Rất an toàn',
        message: 'Khoản vay này hoàn toàn phù hợp với thu nhập của bạn. Bạn có thể thoải mái trả khoản vay này mà không ảnh hưởng nhiều đến cuộc sống hàng ngày.',
        color: Color(0xFF2E7D32),
        icon: Icons.verified_outlined,
      );
  }
}