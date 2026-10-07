import 'package:flutter_test/flutter_test.dart';
import 'package:mortgage_calculator/models/loan_model.dart';

LoanModel _loan({
  required double amount,
  required int term,
  required String method,
  double fixedRate = 0.12,
  int fixedPeriod = 0,
  double floatRate = 0,
  int grace = 0,
}) =>
    LoanModel(
      amount: amount,
      termMonths: term,
      gracePeriod: grace,
      fixedRate: fixedRate,
      fixedPeriod: fixedPeriod,
      floatRate: floatRate,
      method: method,
      prepayRates: const [0.0],
    );

void main() {
  test('Gốc chia đều: gốc mỗi kỳ bằng nhau, dư nợ về 0', () {
    final s = _loan(amount: 120e6, term: 12, method: 'ep').buildSchedule();
    expect(s.length, 12);
    expect(s.first.interest, closeTo(1.2e6, 1));
    for (final p in s) {
      expect(p.principal, closeTo(10e6, 1));
    }
    expect(s.last.balanceEnd, 0);
  });

  test('Trả góp đều: tiền trả hàng tháng không đổi, dư nợ về 0', () {
    final s = _loan(amount: 100e6, term: 12, method: 'ann').buildSchedule();
    expect(s.length, 12);
    expect(s[1].payment, closeTo(s[0].payment, 1e-6));
    expect(s.last.balanceEnd, 0);
  });

  test('Chỉ trả lãi: chỉ trả gốc ở kỳ cuối', () {
    final s = _loan(amount: 50e6, term: 6, method: 'io').buildSchedule();
    for (final p in s.take(5)) {
      expect(p.principal, 0);
      expect(p.payment, closeTo(0.5e6, 1));
    }
    expect(s.last.principal, closeTo(50e6, 1));
    expect(s.last.balanceEnd, 0);
  });

  test('Đổi lãi suất sau thời gian cố định', () {
    final s = _loan(
      amount: 100e6,
      term: 12,
      method: 'ann',
      fixedRate: 0.08,
      fixedPeriod: 3,
      floatRate: 0.12,
    ).buildSchedule();
    expect(s[2].rate, closeTo(0.08, 1e-9));
    expect(s[3].rate, closeTo(0.12, 1e-9));
    expect(s.where((p) => p.isRateChange).map((p) => p.period), [4]);
  });
}
