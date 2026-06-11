class LoanPayment {
  final int period;
  final double balanceStart;
  final double principal;
  final double interest;
  final double payment;
  final double balanceEnd;
  final double rate;
  final double prepayRate;
  final bool isGrace;
  final bool isRateChange;
  final bool isPrepayChange;

  LoanPayment({
    required this.period, required this.balanceStart, required this.principal,
    required this.interest, required this.payment, required this.balanceEnd,
    required this.rate, required this.prepayRate, required this.isGrace,
    required this.isRateChange, required this.isPrepayChange,
  });
}

class LoanModel {
  final double amount;
  final int termMonths;
  final int gracePeriod;
  final double fixedRate;
  final int fixedPeriod;
  final double floatRate;
  final String method;
  final List<double> prepayRates;

  LoanModel({
    required this.amount, required this.termMonths, required this.gracePeriod,
    required this.fixedRate, required this.fixedPeriod, required this.floatRate,
    required this.method, required this.prepayRates,
  });

  double getPrepayRate(int period) {
    final year = ((period - 1) ~/ 12);
    final idx = year.clamp(0, prepayRates.length - 1);
    return prepayRates[idx];
  }

  List<LoanPayment> buildSchedule() {
    final schedule = <LoanPayment>[];
    double bal = amount;
    final payN = termMonths - gracePeriod;
    double pmt = 0;

    if (method == 'ann' && payN > 0) {
      final r0 = floatRate > 0 ? floatRate / 12 : fixedRate / 12;
      pmt = r0 > 0
          ? bal * r0 * pow(1 + r0, payN) / (pow(1 + r0, payN) - 1)
          : bal / payN;
    }

    for (int i = 1; i <= termMonths; i++) {
      final isGrace = i <= gracePeriod;
      final mr = (fixedPeriod > 0 && i <= fixedPeriod)
          ? fixedRate / 12
          : (floatRate > 0 ? floatRate / 12 : fixedRate / 12);
      final interest = bal * mr;
      double principal = 0, payment = 0;

      if (isGrace) {
        principal = 0; payment = interest;
      } else if (method == 'ep') {
        principal = amount / payN;
        if (principal > bal) principal = bal;
        payment = principal + interest;
      } else if (method == 'io') {
        // Trả lãi hàng tháng, gốc cuối kỳ
        if (i == termMonths) {
          principal = bal;
          payment = principal + interest;
        } else {
          principal = 0;
          payment = interest;
        }
      } else {
        final rem = payN - (i - gracePeriod - 1);
        if (i - gracePeriod == 1 || (fixedPeriod > 0 && i == fixedPeriod + 1)) {
          pmt = mr > 0
              ? bal * mr * pow(1 + mr, rem) / (pow(1 + mr, rem) - 1)
              : bal / rem;
        }
        payment = pmt;
        principal = payment - interest;
        if (principal > bal) { principal = bal; payment = principal + interest; }
        if (principal < 0) { principal = 0; payment = interest; }
      }

      bal -= principal;
      if (bal < 1) bal = 0;

      final prCur = getPrepayRate(i);
      final prPrev = i > 1 ? getPrepayRate(i - 1) : prCur;

      schedule.add(LoanPayment(
        period: i, balanceStart: bal + principal, principal: principal,
        interest: interest, payment: payment, balanceEnd: bal,
        rate: mr * 12, prepayRate: prCur, isGrace: isGrace,
        isRateChange: fixedPeriod > 0 && i == fixedPeriod + 1,
        isPrepayChange: i > 1 && prCur != prPrev && !isGrace,
      ));
    }
    return schedule;
  }

  double pow(double base, int exp) {
    double result = 1;
    for (int i = 0; i < exp; i++) {
      result *= base;
    }
    return result;
  }

  double get totalInterest => buildSchedule().fold(0, (s, r) => s + r.interest);
  double get totalPayment => totalInterest + amount;
}