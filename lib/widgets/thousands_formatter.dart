import 'package:flutter/services.dart';

/// TextInputFormatter tự thêm dấu phẩy ngăn cách hàng nghìn (vd 2000000 ->
/// 2,000,000), giữ đúng vị trí con trỏ theo số chữ số đã gõ/xoá thay vì
/// luôn nhảy về cuối chuỗi.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  const ThousandsSeparatorInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsBeforeCursor = newValue.text
        .substring(0, newValue.selection.end.clamp(0, newValue.text.length))
        .replaceAll(RegExp(r'[^\d]'), '')
        .length;

    final rawDigits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (rawDigits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final formatted = _formatWithComma(rawDigits);

    int newCursorPos = formatted.length;
    int digitCount = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (digitCount == digitsBeforeCursor) {
        newCursorPos = i;
        break;
      }
      if (formatted[i] != ',') digitCount++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }

  static String _formatWithComma(String digits) {
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return buf.toString();
  }
}
