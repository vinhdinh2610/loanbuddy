import 'package:flutter/material.dart';
import '../models/database_helper.dart';
import '../models/loan_model.dart';
import 'schedule_screen.dart';
import 'consumer_schedule_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);

  List<HistoryEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await DatabaseHelper.instance.getAll();
    setState(() { _entries = entries; _loading = false; });
  }

  Future<void> _delete(int id) async {
    await DatabaseHelper.instance.delete(id);
    _load();
  }

  Future<void> _deleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xóa toàn bộ lịch sử?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Text('Hành động này không thể hoàn tác.',
            style: TextStyle(fontSize: 13, color: Color(0xFF888888))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy',
                style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa tất cả',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await DatabaseHelper.instance.deleteAll();
      _load();
    }
  }

  void _openEntry(HistoryEntry e) {
    if (e.type == 'mortgage') {
      final loan = LoanModel(
        amount: e.amount,
        termMonths: e.termMonths,
        gracePeriod: 0,
        fixedRate: e.fixedRate,
        fixedPeriod: 0,
        floatRate: e.floatRate,
        method: e.method,
        prepayRates: [0, 0, 0, 0, 0, 0],
      );
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => ScheduleScreen(loan: loan)));
    } else {
      // consumer
      final r = e.floatRate; // annual rate stored as decimal
      final n = e.termMonths;
      final monthlyRate = r / 12;
      final monthlyPayment = monthlyRate == 0
          ? e.amount / n
          : e.amount * monthlyRate * _pow(1 + monthlyRate, n) /
              (_pow(1 + monthlyRate, n) - 1);
      final totalInterest = monthlyPayment * n - e.amount;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ConsumerScheduleScreen(
                    loanAmount: e.amount,
                    annualRate: r * 100,
                    termMonths: n,
                    prepayFee: 0,
                    monthlyPayment: monthlyPayment,
                    totalInterest: totalInterest,
                    totalAmount: e.amount + totalInterest,
                  )));
    }
  }

  double _pow(double base, int exp) {
    double result = 1;
    for (int i = 0; i < exp; i++) {
      result *= base;
    }
    return result;
  }

  String _fmtShort(double n) {
    if (n >= 1e9) return '${(n / 1e9).toStringAsFixed(2)} tỷ';
    if (n >= 1e6) return '${(n / 1e6).toStringAsFixed(1)} triệu';
    return '${n.round()} đ';
  }

  String _fmtFull(double n) {
    final s = n.round().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '${buf.toString()} đ';
  }

  String _fmtDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
    if (diff.inDays < 1) return '${diff.inHours} giờ trước';
    if (diff.inDays == 1) return 'Hôm qua';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _methodLabel(String method) {
    switch (method) {
      case 'ep': return 'Gốc giảm dần';
      case 'ann': return 'Trả góp đều';
      default: return 'Tín chấp';
    }
  }

  Color _typeColor(String type) =>
      type == 'mortgage' ? _gold : const Color(0xFF1E88E5);

  IconData _typeIcon(String type) => type == 'mortgage'
      ? Icons.home_outlined
      : Icons.account_balance_wallet_outlined;

  String _typeLabel(String type) =>
      type == 'mortgage' ? 'Vay thế chấp' : 'Vay tín chấp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        actions: [
          if (_entries.isNotEmpty)
            TextButton.icon(
              onPressed: _deleteAll,
              icon: const Icon(Icons.delete_outline_rounded,
                  color: Colors.red, size: 18),
              label: const Text('Xóa tất cả',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? _buildEmpty()
              : _buildList(),
    );
  }

  Widget _buildEmpty() => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.history_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('Chưa có lịch sử tra cứu',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400)),
          const SizedBox(height: 6),
          Text('Tính lịch trả nợ để lưu vào đây',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
        ]),
      );

  Widget _buildList() => ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          const Text('Lịch Sử',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 4),
          Text('${_entries.length} bảng tính đã lưu',
              style: const TextStyle(fontSize: 14, color: Color(0xFF888888))),
          const SizedBox(height: 16),
          ..._entries.map((e) => _buildCard(e)),
        ],
      );

  Widget _buildCard(HistoryEntry e) {
    final color = _typeColor(e.type);
    final icon = _typeIcon(e.type);

    return GestureDetector(
      onTap: () => _openEntry(e),
      child: Dismissible(
        key: Key('entry_${e.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(16)),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete_outline_rounded,
              color: Colors.white, size: 24),
        ),
        onDismissed: (_) => _delete(e.id!),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              // Icon
              Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 22)),
              const SizedBox(width: 12),

              // Info
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Text(_typeLabel(e.type),
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A))),
                      Text(_fmtDate(e.createdAt),
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF888888))),
                    ]),
                    const SizedBox(height: 4),
                    Text(_fmtFull(e.amount),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: color)),
                    const SizedBox(height: 4),
                    Row(children: [
                      _chip('${e.termMonths}T'),
                      const SizedBox(width: 6),
                      if (e.type == 'mortgage') ...[
                        _chip(
                            '${(e.fixedRate * 100).toStringAsFixed(2)}%'),
                        const SizedBox(width: 6),
                      ] else ...[
                        _chip(
                            '${(e.floatRate * 100).toStringAsFixed(1)}%/năm'),
                        const SizedBox(width: 6),
                      ],
                      _chip(_methodLabel(e.method)),
                    ]),
                    const SizedBox(height: 4),
                    Text('Tổng lãi: ${_fmtShort(e.totalInterest)}',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF888888))),
                  ])),

              // Arrow
              const SizedBox(width: 8),
              Row(children: [
                GestureDetector(
                  onTap: () => _delete(e.id!),
                  child: Icon(Icons.delete_outline_rounded,
                      color: Colors.grey.shade400, size: 20),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.grey.shade300, size: 14),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: const Color(0xFFF5F0E8),
            borderRadius: BorderRadius.circular(6)),
        child: Text(text,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555))),
      );
}