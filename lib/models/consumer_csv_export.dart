import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'csv_downloader.dart'
    if (dart.library.html) 'csv_downloader_web.dart'
    if (dart.library.io) 'csv_downloader_mobile.dart';

class ConsumerCsvExport {
  // ─── Lưu vào máy ────────────────────────────────────────────────────────
  static Future<void> exportSchedule({
    required double loanAmount,
    required double annualRate,
    required int termMonths,
    required double monthlyPayment,
    required double totalInterest,
    required double totalAmount,
    required List<Map<String, double>> schedule,
  }) async {
    final bytes = await buildBytes(
      loanAmount: loanAmount,
      annualRate: annualRate,
      termMonths: termMonths,
      monthlyPayment: monthlyPayment,
      totalInterest: totalInterest,
      totalAmount: totalAmount,
      schedule: schedule,
    );
    final filename =
        'LoanBuddy_TinChap_${DateTime.now().millisecondsSinceEpoch}.csv';
    await CsvDownloader.download(bytes, filename);
  }

  // ─── Trả bytes để share ──────────────────────────────────────────────────
  static Future<List<int>> buildBytes({
    required double loanAmount,
    required double annualRate,
    required int termMonths,
    required double monthlyPayment,
    required double totalInterest,
    required double totalAmount,
    required List<Map<String, double>> schedule,
  }) async {
    final rows = <List<String>>[];
    rows.add(['LOANBUDDY - LỊCH TRẢ NỢ TÍN CHẤP']);
    rows.add([]);
    rows.add(['Số tiền vay', _fmtFull(loanAmount)]);
    rows.add(['Thời hạn', '$termMonths tháng']);
    rows.add(['Lãi suất', '${annualRate.toStringAsFixed(1)}%/năm']);
    rows.add(['Trả hàng tháng', _fmtFull(monthlyPayment)]);
    rows.add(['Tổng lãi', _fmtFull(totalInterest)]);
    rows.add(['Tổng thanh toán', _fmtFull(totalAmount)]);
    rows.add(['Ngày xuất', _fmtDate(DateTime.now())]);
    rows.add([]);
    rows.add(['Kỳ', 'Tổng trả (đ)', 'Gốc (đ)', 'Lãi (đ)', 'Dư nợ còn lại (đ)']);
    for (final r in schedule) {
      rows.add([
        r['period']!.round().toString(),
        r['payment']!.round().toString(),
        r['principal']!.round().toString(),
        r['interest']!.round().toString(),
        r['balance']!.round().toString(),
      ]);
    }
    rows.add([]);
    rows.add([
      'TỔNG CỘNG',
      totalAmount.round().toString(),
      loanAmount.round().toString(),
      totalInterest.round().toString(),
      '0',
    ]);

    final csv = rows.map((row) => row.map((cell) {
          if (cell.contains(',') || cell.contains('\n') || cell.contains('"')) {
            return '"${cell.replaceAll('"', '""')}"';
          }
          return cell;
        }).join(',')).join('\n');

    return utf8.encode('\uFEFF$csv');
  }

  // ─── Share trực tiếp ─────────────────────────────────────────────────────
  static Future<void> shareCsv({
    required double loanAmount,
    required double annualRate,
    required int termMonths,
    required double monthlyPayment,
    required double totalInterest,
    required double totalAmount,
    required List<Map<String, double>> schedule,
  }) async {
    final bytes = await buildBytes(
      loanAmount: loanAmount,
      annualRate: annualRate,
      termMonths: termMonths,
      monthlyPayment: monthlyPayment,
      totalInterest: totalInterest,
      totalAmount: totalAmount,
      schedule: schedule,
    );
    final dir = await getTemporaryDirectory();
    final file = File(
        '${dir.path}/LoanBuddy_TinChap_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'Lịch trả nợ tín chấp LoanBuddy',
    );
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