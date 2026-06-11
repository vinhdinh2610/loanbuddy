import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/loan_model.dart';
import 'csv_downloader.dart'
    if (dart.library.html) 'csv_downloader_web.dart'
    if (dart.library.io) 'csv_downloader_mobile.dart';

class CsvExport {
  static Future<void> exportSchedule(
      LoanModel loan, List<LoanPayment> schedule) async {
    final totalPrincipal = schedule.fold(0.0, (s, r) => s + r.principal);
    final totalInterest = schedule.fold(0.0, (s, r) => s + r.interest);
    final totalPayment = schedule.fold(0.0, (s, r) => s + r.payment);

    final rows = <List<String>>[];
    rows.add(['LOANBUDDY - LỊCH TRẢ NỢ']);
    rows.add([]);
    rows.add(['Số tiền vay', _fmtFull(loan.amount)]);
    rows.add(['Thời hạn', '${loan.termMonths} tháng']);
    rows.add(['Lãi suất cố định', '${(loan.fixedRate * 100).toStringAsFixed(2)}%/năm']);
    rows.add(['Lãi suất thả nổi', '${(loan.floatRate * 100).toStringAsFixed(2)}%/năm']);
    rows.add(['Phương thức', loan.method == 'ep' ? 'Gốc giảm dần' : 'Trả góp đều']);
    rows.add(['Ngày xuất', _fmtDate(DateTime.now())]);
    rows.add([]);
    rows.add(['Kỳ', 'Tổng trả (đ)', 'Gốc (đ)', 'Lãi (đ)', 'Dư nợ còn lại (đ)']);
    for (final r in schedule) {
      rows.add([
        r.period.toString(),
        r.payment.round().toString(),
        r.principal.round().toString(),
        r.interest.round().toString(),
        r.balanceEnd.round().toString(),
      ]);
    }
    rows.add([]);
    rows.add(['TỔNG CỘNG', totalPayment.round().toString(),
      totalPrincipal.round().toString(), totalInterest.round().toString(), '0']);

    final csv = rows.map((row) => row.map((cell) {
      if (cell.contains(',') || cell.contains('\n') || cell.contains('"')) {
        return '"${cell.replaceAll('"', '""')}"';
      }
      return cell;
    }).join(',')).join('\n');

    final bytes = utf8.encode('\uFEFF$csv');
    final filename = 'LoanBuddy_LichTraNo_${DateTime.now().millisecondsSinceEpoch}.csv';
    await CsvDownloader.download(bytes, filename);
  }

  static String _fmtFull(double n) {
    final s = n.round().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  static String _fmtDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}