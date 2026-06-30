import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/loan_model.dart';
import '../models/pdf_export.dart';
import '../models/csv_export.dart';

class ShareExport {
  /// Xuất PDF rồi share ngay, không lưu vào thư viện
  static Future<void> sharePdf(
      LoanModel loan, List<LoanPayment> schedule) async {
    final bytes = await PdfExport.buildBytes(loan, schedule);
    final dir = await getTemporaryDirectory();
    final file = File(
        '${dir.path}/LoanBuddy_LichTraNo_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      subject: 'Lịch trả nợ LoanBuddy',
    );
  }

  /// Xuất CSV rồi share ngay, không lưu vào thư viện
  static Future<void> shareCsv(
      LoanModel loan, List<LoanPayment> schedule) async {
    final bytes = await CsvExport.buildBytes(loan, schedule);
    final dir = await getTemporaryDirectory();
    final file = File(
        '${dir.path}/LoanBuddy_LichTraNo_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'Lịch trả nợ LoanBuddy',
    );
  }
}