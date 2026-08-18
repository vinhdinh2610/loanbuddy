// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LoanBuddy';

  @override
  String get appSlogan => 'Borrow Smart, Build a Strong Future';

  @override
  String get appVersion => 'LoanBuddy v1.0.0';

  @override
  String get appVersionShort => 'Version 1.0.0';

  @override
  String get resultDisclaimer =>
      '* Results are for reference only and do not constitute investment or financial advice.';

  @override
  String get resultDisclaimerShort => '* Results are for reference only.';

  @override
  String get fillCompletely => 'Enter all fields for accurate results';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get delete => 'Delete';

  @override
  String get send => 'Send';

  @override
  String get calculate => 'Calculate';

  @override
  String get export => 'Export';

  @override
  String get share => 'Share';

  @override
  String get save => 'Save';

  @override
  String get featureComingSoon => 'This feature is coming soon';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get splashSlogan => 'Borrow Smart,\nBuild a Strong Future';

  @override
  String get homeGreeting => 'Hello 👋';

  @override
  String get homeQuestion => 'What would you like\nto calculate today?';

  @override
  String get homeSectionLoan => 'Loans & Calculations';

  @override
  String get homeMortgage => 'Mortgage Loan';

  @override
  String get homeConsumer => 'Personal Loan';

  @override
  String get homeComparison => 'Comparison';

  @override
  String get homeSectionManage => 'Loan Management';

  @override
  String get homeEarlySettlement => 'Early\nPrepayment';

  @override
  String get homeEarlySettlementFull => 'Early Prepayment';

  @override
  String get homeDebtRefinance => 'Refinance\nCalculation';

  @override
  String get homeDebtRefinanceFull => 'Refinance Calculation';

  @override
  String get homeSectionPersonal => 'Personal Finance';

  @override
  String get homeFinancialHealth => 'Financial\nHealth';

  @override
  String get homeFinancialHealthFull => 'Financial Health';

  @override
  String get homeRateChecker => 'Rate\nChecker';

  @override
  String get homeRateCheckerFull => 'Rate Checker';

  @override
  String get homeExplore => 'Explore LoanBuddy';

  @override
  String get homeRecentLoans => 'Recent Loans';

  @override
  String get homeReview => 'Review';

  @override
  String get homeBannerMortgageTitle => 'Mortgage Calculator';

  @override
  String get homeBannerMortgageSubtitle =>
      'Plan your home purchase with a detailed repayment schedule';

  @override
  String get homeBannerConsumerTitle => 'Personal Loan Calculator';

  @override
  String get homeBannerConsumerSubtitle =>
      'Quickly estimate your consumer loan payments';

  @override
  String get homeBannerHealthTitle => 'Financial Health Check';

  @override
  String get homeBannerHealthSubtitle =>
      'See how much you can afford to borrow';

  @override
  String get homePerYear => '%/yr';

  @override
  String homeMonths(int months) {
    return '$months months';
  }

  @override
  String get homeLoanTypeMortgage => 'Mortgage Loan';

  @override
  String get homeLoanTypeConsumer => 'Personal Loan';

  @override
  String get homeMethodDeclining => 'Equal Principal';

  @override
  String get homeMethodInterestOnly => 'Interest Only';

  @override
  String get homeMethodEqual => 'Equal Installment';

  @override
  String get historyTitle => 'History';

  @override
  String get historyDeleteAll => 'Delete All';

  @override
  String get historyDeleteAllConfirm => 'Delete all history?';

  @override
  String get historyDeleteAllMessage => 'This action cannot be undone.';

  @override
  String get historyDeleteAllButton => 'Delete All';

  @override
  String get historyEmpty => 'No history yet';

  @override
  String get historyEmptyHint => 'Calculate a loan schedule to save it here';

  @override
  String historyCount(int count) {
    return '$count saved calculations';
  }

  @override
  String get historyJustNow => 'Just now';

  @override
  String historyMinutesAgo(int minutes) {
    return '$minutes minutes ago';
  }

  @override
  String historyHoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String get historyYesterday => 'Yesterday';

  @override
  String get historyMethodDeclining => 'Declining Balance';

  @override
  String get historyMethodEqual => 'Equal Installment';

  @override
  String get historyMethodConsumer => 'Personal';

  @override
  String get historyTypeMortgage => 'Mortgage';

  @override
  String get historyTypeConsumer => 'Personal Loan';

  @override
  String historyTotalInterest(String amount) {
    return 'Total interest: $amount';
  }

  @override
  String get historyPerYear => '%/yr';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsFeedback => 'Feedback';

  @override
  String get settingsAbout => 'About App';

  @override
  String get settingsLegal => 'Legal';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTermsOfUse => 'Terms of Use';

  @override
  String get settingsChooseLanguage => 'Choose Language';

  @override
  String get settingsLangVietnamese => 'Tiếng Việt';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'LoanBuddy helps you calculate repayment schedules, compare loans, and assess your financial health in a smart and intuitive way.\n\nDesigned specifically for the Vietnamese market, supporting both mortgage and personal loans with a full suite of professional features.';

  @override
  String get aboutFeature1 => 'Mortgage loan calculator';

  @override
  String get aboutFeature2 => 'Personal loan calculator';

  @override
  String get aboutFeature3 => 'Loan comparison';

  @override
  String get aboutFeature4 => 'Financial health assessment';

  @override
  String get aboutFeature5 => 'Save search history';

  @override
  String get aboutFeature6 => 'Early loan settlement';

  @override
  String get aboutFeature7 => 'Debt refinance analysis';

  @override
  String get aboutFeature8 => 'Interest rate checker';

  @override
  String get calcMortgageTitle => 'Mortgage Loan';

  @override
  String get calcLoanInfo => 'Loan Information';

  @override
  String get calcLoanAmount => 'Loan Amount';

  @override
  String get calcTermMonths => 'Loan Term (months)';

  @override
  String get calcFixedRate => 'Fixed Interest Rate (%/yr)';

  @override
  String get calcFixedPeriod => 'Fixed Rate Period (months)';

  @override
  String get calcFloatingRate => 'Floating Interest Rate (%/yr)';

  @override
  String get calcGracePeriod => 'Principal Grace Period (months)';

  @override
  String get calcPaymentMethod => 'Payment Method';

  @override
  String get calcMethodDeclining => 'Equal Principal';

  @override
  String get calcMethodDecliningDesc =>
      'Fixed principal each month, interest decreases';

  @override
  String get calcMethodEqual => 'Equal Installment';

  @override
  String get calcMethodEqualDesc => 'Total monthly payment remains constant';

  @override
  String get calcMethodInterestOnly => 'Interest Only';

  @override
  String get calcMethodInterestOnlyDesc =>
      'Pay interest only each month, repay full principal at end';

  @override
  String get calcScheduleButton => 'Calculate';

  @override
  String get calcValidatorAmount => 'Enter amount';

  @override
  String get calcValidatorInvalid => 'Invalid';

  @override
  String get calcValidatorValue => 'Enter value';

  @override
  String get comparisonTitle => 'Loan Comparison';

  @override
  String get comparisonAddOption => 'Add Option';

  @override
  String get comparisonCompareButton => 'Compare Now';

  @override
  String get comparisonPrincipal => 'Loan Amount';

  @override
  String get comparisonFixedRate => 'Fixed Rate (%/yr)';

  @override
  String get comparisonFixedPeriod => 'Fixed Period (months)';

  @override
  String get comparisonFloatingRate => 'Floating Rate (%/yr)';

  @override
  String get comparisonTerm => 'Loan Term (months)';

  @override
  String get comparisonGrace => 'Grace Period (months)';

  @override
  String get comparisonMethodDeclining => 'Equal Principal';

  @override
  String get comparisonMethodEqual => 'Equal Installment';

  @override
  String comparisonOptionLabel(int index) {
    return 'Option $index';
  }

  @override
  String comparisonResultLabel(int index) {
    return 'Option $index';
  }

  @override
  String get comparisonTotalPrincipal => 'Total Principal';

  @override
  String get comparisonTotalInterest => 'Total Interest';

  @override
  String get comparisonHighestMonthly => 'Highest Monthly';

  @override
  String get comparisonLowestMonthly => 'Lowest Monthly';

  @override
  String get comparisonTotalPayment => 'Total Payment';

  @override
  String get comparisonAllEqual => 'All options save the same';

  @override
  String comparisonBestOption(int index) {
    return 'Option $index saves the most';
  }

  @override
  String comparisonSavingDiff(String amount) {
    return 'Difference: $amountđ';
  }

  @override
  String get consumerTitle => 'Personal Loan';

  @override
  String get consumerLoanAmount => 'Loan Amount';

  @override
  String get consumerTotalInterest => 'Total Interest';

  @override
  String get consumerMonthlyPayment => 'Monthly Payment';

  @override
  String get consumerTotalPayment => 'Total Payment';

  @override
  String get consumerAnnualRate => 'Annual Interest Rate';

  @override
  String get consumerTermMonths => 'Loan Term';

  @override
  String get consumerScheduleButton => 'Calculate';

  @override
  String get estimatorTitle => 'Financial Health';

  @override
  String get estimatorSubtitle => 'Evaluate whether this loan suits you';

  @override
  String get estimatorSectionTitle => 'Financial health assessment';

  @override
  String get estimatorHint =>
      'Enter your information to assess financial health';

  @override
  String get estimatorIncome => 'Your actual monthly income)';

  @override
  String get estimatorExpenses => 'Your approximate monthly expenses';

  @override
  String get estimatorExistingDebt =>
      'How much do you currently pay on existing loans per month?';

  @override
  String get estimatorLoanAmount => 'Desired loan amount';

  @override
  String get estimatorTermMonths => 'Loan term (months)';

  @override
  String get estimatorRateNote =>
      'Estimated rate 12%/yr · Equal monthly installment';

  @override
  String get estimatorButton => 'Assess';

  @override
  String get estimatorValidation =>
      'Please enter your income, loan amount, and term (must be greater than 0)';

  @override
  String get estimatorResultTitle => 'Is this loan suitable for you?';

  @override
  String get estimatorExpectedPayment => 'Estimated monthly payment';

  @override
  String get estimatorPressureLevel => 'Financial pressure level';

  @override
  String get estimatorRemainingAfter =>
      'After loan payment, you will have left';

  @override
  String get estimatorLevelVerySafeLabel => 'Very Safe';

  @override
  String get estimatorLevelVerySafeMsg =>
      'This loan is completely suitable for your income. You can comfortably repay this loan without significantly affecting your daily life.';

  @override
  String get estimatorLevelSafeLabel => 'Safe';

  @override
  String get estimatorLevelSafeMsg =>
      'This loan is within a safe financial zone. You still have enough room to handle monthly unexpected expenses.';

  @override
  String get estimatorLevelConsiderLabel => 'Consider Carefully';

  @override
  String get estimatorLevelConsiderMsg =>
      'This loan creates some pressure in months with unexpected expenses. You can still borrow but should have an emergency fund of at least 3 months of expenses before deciding.';

  @override
  String get estimatorLevelHighPressureLabel => 'High Pressure';

  @override
  String get estimatorLevelHighPressureMsg =>
      'After the loan payment, the remaining amount is less than half a month of expenses. A small unexpected cost could cause difficulties. Consider reducing the loan amount or extending the term.';

  @override
  String get estimatorLevelImbalancedLabel => 'Financial Imbalance';

  @override
  String get estimatorLevelImbalancedMsg =>
      'Your income is not enough to cover your expenses and this loan. You should reduce the loan amount, extend the term, or increase your income before borrowing.';

  @override
  String get estimatorLevelCantBorrowLabel => 'Cannot Borrow';

  @override
  String get estimatorLevelCantBorrowMsg =>
      'You cannot borrow at this time. The repayment exceeds your entire income.';

  @override
  String get scheduleTitle => 'Results';

  @override
  String get scheduleTotalInterest => 'Total Interest';

  @override
  String get scheduleTotalPayment => 'Total Payment';

  @override
  String get scheduleHighestPayment => 'Highest Payment';

  @override
  String get scheduleLowestPayment => 'Lowest Payment';

  @override
  String get scheduleIncludesPrincipalInterest =>
      'Includes principal and interest';

  @override
  String schedulePeriod(int period) {
    return 'Period $period';
  }

  @override
  String scheduleRateChangeWarning(int period) {
    return 'After promotional period (period $period):';
  }

  @override
  String schedulePaymentChange(String direction, String amount) {
    return 'Payment $direction$amount/month';
  }

  @override
  String get scheduleChangeRate => 'Rate change';

  @override
  String get scheduleExportFile => 'Export';

  @override
  String get scheduleExportTitle => 'Export schedule';

  @override
  String get scheduleChooseFormat => 'Choose file format';

  @override
  String get scheduleExportPDF => 'Export PDF';

  @override
  String get scheduleExportPDFDesc =>
      'Beautiful format, easy to share and print';

  @override
  String get scheduleExportCSV => 'Export CSV';

  @override
  String get scheduleExportCSVDesc => 'Open with Excel, Google Sheets';

  @override
  String scheduleFileReady(String type) {
    return '$type file ready';
  }

  @override
  String get scheduleShareAction => 'What would you like to do with this file?';

  @override
  String scheduleShareFile(String type) {
    return 'Share $type now';
  }

  @override
  String scheduleSaveFile(String type) {
    return 'Save $type to device';
  }

  @override
  String scheduleShareError(String error) {
    return 'Share error: $error';
  }

  @override
  String get adLoadFailed => 'Couldn\'t load the ad, please try again.';

  @override
  String adScheduleLockRemaining(int count) {
    return '$count more payment periods';
  }

  @override
  String get adScheduleLockHint =>
      'Watch a short ad to see the full repayment schedule';

  @override
  String get adScheduleLockButton => 'Watch ad to continue';

  @override
  String adExportTitle(String type) {
    return 'Watch an ad to export $type';
  }

  @override
  String get adExportHint =>
      'Short ad, about 15-30 seconds. No watermark after export.';

  @override
  String get adExportButton => 'Watch ad';

  @override
  String get tableColPeriod => 'Period';

  @override
  String get tableColTotal => 'Total';

  @override
  String get tableColPrincipal => 'Principal';

  @override
  String get tableColInterest => 'Interest';

  @override
  String get tableColBalance => 'Balance';

  @override
  String get consumerScheduleTitle => 'Results';

  @override
  String get consumerScheduleMonthly => 'Monthly Payment';

  @override
  String get consumerScheduleTotalPayment => 'Total Payment';

  @override
  String get consumerScheduleTotalInterest => 'Total Interest';

  @override
  String get consumerScheduleTerm => 'Loan Term';

  @override
  String get consumerScheduleFixed => 'Fixed each period';

  @override
  String get consumerScheduleIncludesPrincipal =>
      'Includes principal and interest';

  @override
  String consumerSchedulePercentOfTotal(String percent) {
    return '$percent% of total';
  }

  @override
  String consumerScheduleYears(String years) {
    return 'Equivalent to $years years';
  }

  @override
  String get rateCheckerTitle => 'Loan Rate Checker';

  @override
  String get rateCheckerSubtitle =>
      'Estimate the current interest rate on your existing loan';

  @override
  String get rateCheckerSectionTitle => 'Estimate current rate';

  @override
  String get rateCheckerHint => 'Enter your current loan details to estimate';

  @override
  String get rateCheckerOriginalAmount => 'Original loan amount';

  @override
  String get rateCheckerStartDate => 'Loan start date';

  @override
  String get rateCheckerTotalTerm => 'Total loan term';

  @override
  String get rateCheckerLastPayment => 'Most recent payment amount';

  @override
  String get rateCheckerMethod => 'Interest calculation method';

  @override
  String get rateCheckerMethodDeclining => 'Equal Principal';

  @override
  String get rateCheckerMethodEqual => 'Equal installment';

  @override
  String get rateCheckerMethodInterestOnly => 'Interest only';

  @override
  String get rateCheckerButton => 'Estimate Rate';

  @override
  String get rateCheckerValidation => 'Please check your input and try again';

  @override
  String get rateCheckerNoResult =>
      'Cannot estimate with the provided information. Please check the payment amount or interest method.';

  @override
  String get rateCheckerResultHeader => '— Results —';

  @override
  String get rateCheckerResultTitle => 'Estimated current rate';

  @override
  String get rateCheckerResultNote =>
      'Based on remaining balance and current payment amount';

  @override
  String get rateCheckerResultDisclaimer =>
      '* This is an estimate, not the official rate from your bank.';

  @override
  String get rateCheckerInfoBox =>
      'Results are estimated based on your input and may differ slightly from the official rate applied by your bank.';

  @override
  String get fullPayoffTitle => 'Full Prepayment';

  @override
  String get fullPayoffSubtitle =>
      'Calculate the cost of paying off your loan early';

  @override
  String get fullPayoffSectionTitle => 'Loan Information';

  @override
  String get fullPayoffOriginalAmount => 'Original loan amount';

  @override
  String get fullPayoffStartDate => 'Loan start date';

  @override
  String get fullPayoffTotalTerm => 'Total loan term';

  @override
  String get fullPayoffMethod => 'Interest calculation method';

  @override
  String get fullPayoffMethodDeclining => 'Equal Principal';

  @override
  String get fullPayoffMethodEqual => 'Equal installment';

  @override
  String get fullPayoffGracePeriod => 'Initial grace period (if any)';

  @override
  String get fullPayoffFixedRate => 'Fixed interest rate';

  @override
  String get fullPayoffFixedPeriod => 'Fixed period';

  @override
  String get fullPayoffFloatingRate => 'Floating rate (after fixed period)';

  @override
  String get fullPayoffTargetDate => 'Expected payoff date';

  @override
  String get fullPayoffPenaltyRate => 'Early repayment fee';

  @override
  String get fullPayoffButton => 'Calculate';

  @override
  String get fullPayoffValidation => 'Please check your input and try again';

  @override
  String get fullPayoffNoResult =>
      'Cannot calculate with the provided information. Please check the payoff date, loan term, and grace period.';

  @override
  String get fullPayoffResultHeader => '— Results —';

  @override
  String get fullPayoffTotalNeeded => 'Total amount needed for payoff';

  @override
  String get fullPayoffRemainingBalance => 'Remaining principal balance';

  @override
  String get fullPayoffPenaltyFee => 'Early repayment penalty fee';

  @override
  String get fullPayoffInterestSaved =>
      'Interest saved (vs. original schedule)';

  @override
  String fullPayoffEarlyMonths(int months, String years) {
    return 'Debt-free $months months ($years years) earlier';
  }

  @override
  String get fullPayoffResultDisclaimer =>
      '* Estimated figures, excluding other fees (if any) per bank policy.';

  @override
  String get fullPayoffInfoBox =>
      'Actual penalty depends on your contract and payoff year. Please confirm with your bank for accurate figures.';

  @override
  String get partialTitle => 'Partial Prepayment';

  @override
  String get partialSubtitle =>
      'Recalculate your schedule when making an extra principal payment';

  @override
  String get partialSectionTitle => 'Loan Information';

  @override
  String get partialExtraDate => 'Extra payment date';

  @override
  String get partialPenaltyRate => 'Early repayment penalty';

  @override
  String get partialExtraAmount => 'Extra principal payment amount';

  @override
  String get partialPriority => 'What would you like to prioritize?';

  @override
  String get partialPriorityGrace => 'Grace period on principal';

  @override
  String get partialPriorityReducePayment => 'Reduce monthly payment';

  @override
  String get partialPriorityShortenTerm => 'Shorten loan term';

  @override
  String get partialButton => 'Calculate';

  @override
  String get partialValidation => 'Please check your input and try again';

  @override
  String get partialNoResult =>
      'Cannot calculate with the provided information. Please check extra amount, grace period, and application date.';

  @override
  String get partialResultHeader => '— Results —';

  @override
  String get partialRemainingBalance => 'Balance after extra payment';

  @override
  String get partialPenaltyFee => 'Early repayment penalty';

  @override
  String get partialNewTerm => 'New loan term';

  @override
  String partialTermReduced(int months) {
    return 'Reduced by $months months';
  }

  @override
  String get partialMonthlyPayment => 'Monthly payment';

  @override
  String get partialNoChange => 'Unchanged';

  @override
  String get partialGracePeriods => 'Grace periods granted';

  @override
  String get partialGraceNote => 'Interest only during this period';

  @override
  String get partialGracePayment => 'Payment during grace period';

  @override
  String get partialTermLabel => 'Loan term';

  @override
  String get partialInterestSaved => 'Interest saved';

  @override
  String get partialResultDisclaimer =>
      '* Estimated figures. Please consult a financial advisor before deciding.';

  @override
  String get partialGraceInfoTitle => 'What is a grace period on principal?';

  @override
  String get partialGraceInfoBody =>
      'Your extra payment immediately reduces your outstanding balance. LoanBuddy then calculates a number of upcoming periods where you are temporarily exempt from paying principal — during this time you only pay interest on the reduced balance. After the grace period ends, you resume normal principal and interest payments, and the loan still ends on the original schedule.';

  @override
  String get partialGraceInfoNote =>
      'Suitable when you want to reduce financial pressure in the short term.';

  @override
  String get partialReduceInfoTitle =>
      'What does reducing monthly payment mean?';

  @override
  String get partialReduceInfoBody =>
      'Your extra payment immediately reduces your principal balance. The loan term remains unchanged. Since the remaining balance is spread evenly over the remaining term, the principal portion per month will be lower — resulting in a reduced monthly payment.';

  @override
  String get partialReduceInfoNote =>
      'Suitable when you want to reduce your ongoing monthly financial burden.';

  @override
  String get partialShortenInfoTitle =>
      'What does shortening the loan term mean?';

  @override
  String get partialShortenInfoBody =>
      'Your extra payment immediately reduces your principal balance. The monthly payment stays the same, but since the balance is lower, you will pay off the loan sooner than originally scheduled.';

  @override
  String get partialShortenInfoNote =>
      'Suitable when you want to save the most interest and become debt-free as soon as possible.';

  @override
  String get earlySelectTitle => 'Settlement Scenarios';

  @override
  String get earlySelectSubtitle => 'Choose the scenario you want to calculate';

  @override
  String get earlySelectFullTitle => 'Full Prepayment';

  @override
  String get earlySelectFullDesc =>
      'Pay off the entire remaining balance to end the loan at a specific date';

  @override
  String get earlySelectPartialTitle => 'Partial prepayment';

  @override
  String get earlySelectPartialDesc =>
      'Pay extra on the principal to reduce balance or shorten the term';

  @override
  String get earlySelectNote =>
      'Applies to mortgage loans only. Results are for reference.';

  @override
  String get refinanceTitle => 'Refinance Calculation';

  @override
  String get refinanceSubtitle =>
      'Compare your current loan with a new loan to decide whether to refinance';

  @override
  String get refinanceCurrentLoan => 'Current loan';

  @override
  String get refinanceCurrentLoanInfo => 'Information from your current bank';

  @override
  String get refinanceRemainingBalance => 'Remaining balance';

  @override
  String get refinanceRemainingTerm => 'Remaining term';

  @override
  String get refinanceCurrentRate => 'Current rate';

  @override
  String get refinancePrepaymentFee => 'Early repayment fee';

  @override
  String get refinancePaymentMethod => 'Payment method';

  @override
  String get refinanceMethodDeclining => 'Equal principal';

  @override
  String get refinanceMethodEqual => 'Equal installment';

  @override
  String get refinanceNewLoan => 'New loan';

  @override
  String get refinanceNewLoanInfo => 'Bank you want to refinance with';

  @override
  String get refinanceNewAmount => 'New loan amount';

  @override
  String get refinanceNewTerm => 'New loan term';

  @override
  String get refinanceFixedRate => 'Fixed interest rate';

  @override
  String get refinancePromoTerm => 'Fixed period';

  @override
  String get refinanceFloatingRate => 'Floating rate';

  @override
  String get refinanceProcessingFee => 'Processing fee';

  @override
  String get refinanceButton => 'Calculation';

  @override
  String get refinanceValidation =>
      'Please enter all required fields for both loans (must be greater than 0)';

  @override
  String get refinanceResultHeader => '— Results —';

  @override
  String get refinanceTotalCost => 'Total refinancing cost';

  @override
  String get refinanceBreakevenMonths => 'Breakeven period';

  @override
  String refinanceBreakevenValue(int months) {
    return '$months months';
  }

  @override
  String get refinanceNoBreakeven => 'No breakeven';

  @override
  String get refinanceInterestSavedPromo =>
      'Interest saved during promotional period';

  @override
  String get refinanceInterestSavedTotal => 'Interest saved over loan term';

  @override
  String get refinanceInterestSavedMonthly =>
      'Average monthly interest savings';

  @override
  String get refinanceNoResult =>
      'Cannot analyze with the provided information. Please check all required fields.';

  @override
  String get refinanceResultDisclaimer =>
      '* Savings over loan term calculated over the full new loan term. Estimated figures.';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackSubtitle => 'Your feedback helps improve LoanBuddy';

  @override
  String get feedbackEmailHint => 'Email (optional)';

  @override
  String get feedbackContentHint => 'Your feedback...';

  @override
  String get feedbackButton => 'Send';

  @override
  String get feedbackFooter =>
      'You can also email us at:\nvinhdinh2610@gmail.com';

  @override
  String get feedbackValidation => 'Please enter your feedback';

  @override
  String get feedbackSuccess => 'Thank you for your feedback!';

  @override
  String get feedbackNoEmail => 'No email app found';

  @override
  String get feedbackError => 'An error occurred, please try again';

  @override
  String get drawerSlogan => 'Borrow Smart, Build a Strong Future';

  @override
  String get drawerHome => 'Home';

  @override
  String get drawerHistory => 'Search History';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerFeedback => 'Feedback';

  @override
  String get drawerPrivacyPolicy => 'Privacy Policy';

  @override
  String get drawerTermsOfUse => 'Terms of Use';

  @override
  String get unitMonths => 'months';

  @override
  String get unitBillion => 'billion';

  @override
  String get unitMillion => 'million';

  @override
  String get partialInfoBox =>
      'Actual penalty depends on your contract and year of prepayment. Please confirm with your bank.';

  @override
  String partialPaymentReduced(String amount) {
    return 'Reduced by $amount/month';
  }
}
