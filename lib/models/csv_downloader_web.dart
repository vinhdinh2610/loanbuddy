// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class CsvDownloader {
  static Future<void> download(List<int> bytes, String filename) async {
    final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}