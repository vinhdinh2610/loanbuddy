import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/loan_model.dart';

class PdfExport {
  static Future<void> exportSchedule(
      LoanModel loan, List<LoanPayment> schedule) async {
    final pdf = pw.Document();

    final totalPrincipal = schedule.fold(0.0, (s, r) => s + r.principal);
    final totalInterest = schedule.fold(0.0, (s, r) => s + r.interest);
    final totalPayment = schedule.fold(0.0, (s, r) => s + r.payment);

    final font = await PdfGoogleFonts.notoSansRegular();
    final fontBold = await PdfGoogleFonts.notoSansBold();

    final goldColor = PdfColor.fromHex('E8A020');
    final bgColor = PdfColor.fromHex('F5F0E8');
    final darkColor = PdfColor.fromHex('1A1A1A');
    final greyColor = PdfColor.fromHex('888888');
    final wmColor = PdfColor(0.91, 0.627, 0.125, 0.08);

    // Column widths
    const colWidths = {
      0: pw.FlexColumnWidth(1),
      1: pw.FlexColumnWidth(3),
      2: pw.FlexColumnWidth(3),
      3: pw.FlexColumnWidth(3),
      4: pw.FlexColumnWidth(3),
    };

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('LoanBuddy', style: pw.TextStyle(font: fontBold, fontSize: 20, color: goldColor)),
                    pw.Text('Lịch Trả Nợ', style: pw.TextStyle(font: fontBold, fontSize: 14, color: darkColor)),
                  ]),
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Ngày xuất: ${_fmtDate(DateTime.now())}',
                        style: pw.TextStyle(font: font, fontSize: 10, color: greyColor)),
                    pw.Text('Phương thức: ${loan.method == "ep" ? "Gốc giảm dần" : "Trả góp đều"}',
                        style: pw.TextStyle(font: font, fontSize: 10, color: greyColor)),
                  ]),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(color: bgColor, borderRadius: pw.BorderRadius.circular(8)),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem(font, fontBold, greyColor, darkColor, 'Số tiền vay', _fmtFull(loan.amount)),
                  _summaryItem(font, fontBold, greyColor, goldColor, 'Tổng lãi', _fmtFull(totalInterest)),
                  _summaryItem(font, fontBold, greyColor, darkColor, 'Tổng thanh toán', _fmtFull(totalPayment)),
                  _summaryItem(font, fontBold, greyColor, darkColor, 'Thời hạn', '${loan.termMonths} tháng'),
                ],
              ),
            ),
            pw.SizedBox(height: 12),
            // Header row — căn đều với cột dữ liệu
            pw.Table(
              columnWidths: colWidths,
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: goldColor),
                  children: [
                    _th(fontBold, 'Kỳ', center: true),
                    _th(fontBold, 'Tổng trả'),
                    _th(fontBold, 'Gốc'),
                    _th(fontBold, 'Lãi'),
                    _th(fontBold, 'Dư nợ còn lại'),
                  ],
                ),
              ],
            ),
          ],
        ),
        build: (context) => [
          pw.Table(
            columnWidths: colWidths,
            children: [
              // Data rows xen kẽ watermark
              ...schedule.expand((r) {
                final isWm = r.period % 8 == 0; // watermark mỗi 8 dòng
                final rows = <pw.TableRow>[];

                // Dòng dữ liệu
                rows.add(pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: r.isRateChange ? PdfColor.fromHex('FFF3CD') : null,
                    border: const pw.TableBorder(
                        bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
                  ),
                  children: [
                    _td(font, r.period.toString(), center: true),
                    _td(font, _fmtFull(r.payment), bold: true, fontBold: fontBold),
                    _td(font, _fmtFull(r.principal)),
                    _td(font, _fmtFull(r.interest)),
                    _td(font, _fmtFull(r.balanceEnd)),
                  ],
                ));

                // Dòng watermark ẩn xen kẽ
                if (isWm) {
                  rows.add(pw.TableRow(
                    children: [
                      _tdWm(fontBold, '', wmColor),
                      _tdWm(fontBold, 'LoanBuddy', wmColor),
                      _tdWm(fontBold, '·', wmColor),
                      _tdWm(fontBold, 'LoanBuddy', wmColor),
                      _tdWm(fontBold, '', wmColor),
                    ],
                  ));
                }
                return rows;
              }),

              // Dòng tổng — tất cả màu đen, số vàng
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('FFF3E0'),
                  border: pw.TableBorder(top: pw.BorderSide(color: goldColor, width: 1.5)),
                ),
                children: [
                  _td(fontBold, 'Tổng', center: true, bold: true, fontBold: fontBold, color: darkColor),
                  _td(fontBold, _fmtFull(totalPayment), bold: true, fontBold: fontBold, color: goldColor),
                  _td(fontBold, _fmtFull(totalPrincipal), bold: true, fontBold: fontBold, color: darkColor),
                  _td(fontBold, _fmtFull(totalInterest), bold: true, fontBold: fontBold, color: goldColor),
                  _td(fontBold, '0', bold: true, fontBold: fontBold, color: darkColor),
                ],
              ),
            ],
          ),
        ],
        footer: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('LoanBuddy — Tính lãi thông minh',
                style: pw.TextStyle(font: font, fontSize: 9, color: greyColor)),
            pw.Text('Trang ${context.pageNumber} / ${context.pagesCount}',
                style: pw.TextStyle(font: font, fontSize: 9, color: greyColor)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'LoanBuddy_LichTraNo.pdf',
    );
  }

  static pw.Widget _summaryItem(pw.Font font, pw.Font fontBold,
      PdfColor labelColor, PdfColor valueColor, String label, String value) =>
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
        pw.Text(label, style: pw.TextStyle(font: font, fontSize: 9, color: labelColor)),
        pw.SizedBox(height: 2),
        pw.Text(value, style: pw.TextStyle(font: fontBold, fontSize: 11, color: valueColor)),
      ]);

  // Header cell — dùng Table nên căn đúng với data
  static pw.Widget _th(pw.Font fontBold, String text, {bool center = false}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: pw.Text(text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: fontBold, fontSize: 10,
                color: PdfColor.fromHex('1A1A1A'))),
      );

  static pw.Widget _td(pw.Font font, String text, {
    bool center = false, bool bold = false,
    pw.Font? fontBold, PdfColor? color,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        child: pw.Text(text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
                font: bold ? fontBold : font, fontSize: 9,
                color: color ?? PdfColor.fromHex('444444'))),
      );

  // Watermark cell — chữ mờ, font nhỏ
  static pw.Widget _tdWm(pw.Font font, String text, PdfColor color) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: pw.Text(text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: font, fontSize: 7, color: color)),
      );

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