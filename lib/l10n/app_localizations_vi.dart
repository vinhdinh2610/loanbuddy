// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'LoanBuddy';

  @override
  String get appSlogan => 'Vay thông minh, Tương lai vững vàng';

  @override
  String get appVersion => 'LoanBuddy v1.0.0';

  @override
  String get appVersionShort => 'Phiên bản 1.0.0';

  @override
  String get resultDisclaimer =>
      '* Kết quả mang tính tham khảo, không đại diện cho lời khuyên đầu tư hay tài chính.';

  @override
  String get resultDisclaimerShort => '* Kết quả mang tính tham khảo.';

  @override
  String get fillCompletely => 'Nhập đầy đủ để tính chính xác';

  @override
  String get cancel => 'Hủy';

  @override
  String get close => 'Đóng';

  @override
  String get delete => 'Xóa';

  @override
  String get send => 'Gửi';

  @override
  String get calculate => 'Tính';

  @override
  String get export => 'Xuất file';

  @override
  String get share => 'Chia sẻ';

  @override
  String get save => 'Lưu';

  @override
  String get featureComingSoon => 'Chức năng đang trong quá trình hoàn thiện';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navHistory => 'Lịch sử';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get splashSlogan => 'Vay thông minh,\nTương lai vững vàng';

  @override
  String get homeGreeting => 'Xin chào 👋';

  @override
  String get homeQuestion => 'Bạn muốn tính gì\nhôm nay?';

  @override
  String get homeSectionLoan => 'Vay & Tính toán';

  @override
  String get homeMortgage => 'Vay thế chấp';

  @override
  String get homeConsumer => 'Vay tín chấp';

  @override
  String get homeComparison => 'So sánh';

  @override
  String get homeSectionManage => 'Quản lý khoản vay';

  @override
  String get homeEarlySettlement => 'Tất toán\ntrước hạn';

  @override
  String get homeEarlySettlementFull => 'Tất toán trước hạn';

  @override
  String get homeDebtRefinance => 'Phân tích\nchuyển nợ';

  @override
  String get homeDebtRefinanceFull => 'Phân tích chuyển nợ';

  @override
  String get homeSectionPersonal => 'Tài chính cá nhân';

  @override
  String get homeFinancialHealth => 'Sức khỏe\ntài chính';

  @override
  String get homeFinancialHealthFull => 'Sức khỏe tài chính';

  @override
  String get homeRateChecker => 'Kiểm tra\nlãi suất';

  @override
  String get homeRateCheckerFull => 'Kiểm tra lãi suất';

  @override
  String get homeExplore => 'Khám phá LoanBuddy';

  @override
  String get homeRecentLoans => 'Khoản vay gần đây';

  @override
  String get homeReview => 'Xem lại';

  @override
  String get homeBannerMortgageTitle => 'Tính lãi vay thế chấp';

  @override
  String get homeBannerMortgageSubtitle =>
      'Lên kế hoạch mua nhà với lịch trả nợ chi tiết';

  @override
  String get homeBannerConsumerTitle => 'Tính lãi vay tín chấp';

  @override
  String get homeBannerConsumerSubtitle =>
      'Ước tính khoản vay tiêu dùng nhanh chóng';

  @override
  String get homeBannerHealthTitle => 'Kiểm tra sức khỏe tài chính';

  @override
  String get homeBannerHealthSubtitle =>
      'Xem mức vay phù hợp với thu nhập của bạn';

  @override
  String get homePerYear => '%/năm';

  @override
  String homeMonths(int months) {
    return '$months tháng';
  }

  @override
  String get homeLoanTypeMortgage => 'Vay thế chấp';

  @override
  String get homeLoanTypeConsumer => 'Vay tín chấp';

  @override
  String get homeMethodDeclining => 'Gốc giảm dần';

  @override
  String get homeMethodInterestOnly => 'Chỉ trả lãi';

  @override
  String get homeMethodEqual => 'Trả góp đều';

  @override
  String get historyTitle => 'Lịch Sử';

  @override
  String get historyDeleteAll => 'Xóa tất cả';

  @override
  String get historyDeleteAllConfirm => 'Xóa toàn bộ lịch sử?';

  @override
  String get historyDeleteAllMessage => 'Hành động này không thể hoàn tác.';

  @override
  String get historyDeleteAllButton => 'Xóa tất cả';

  @override
  String get historyEmpty => 'Chưa có lịch sử tra cứu';

  @override
  String get historyEmptyHint => 'Tính lịch trả nợ để lưu vào đây';

  @override
  String historyCount(int count) {
    return '$count bảng tính đã lưu';
  }

  @override
  String get historyJustNow => 'Vừa xong';

  @override
  String historyMinutesAgo(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String historyHoursAgo(int hours) {
    return '$hours giờ trước';
  }

  @override
  String get historyYesterday => 'Hôm qua';

  @override
  String get historyMethodDeclining => 'Gốc giảm dần';

  @override
  String get historyMethodEqual => 'Trả góp đều';

  @override
  String get historyMethodConsumer => 'Tín chấp';

  @override
  String get historyTypeMortgage => 'Vay thế chấp';

  @override
  String get historyTypeConsumer => 'Vay tín chấp';

  @override
  String historyTotalInterest(String amount) {
    return 'Tổng lãi: $amount';
  }

  @override
  String get historyPerYear => '%/năm';

  @override
  String get settingsTitle => 'Cài Đặt';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsSupport => 'Hỗ trợ';

  @override
  String get settingsFeedback => 'Góp ý';

  @override
  String get settingsAbout => 'Giới thiệu ứng dụng';

  @override
  String get settingsLegal => 'Pháp lý';

  @override
  String get settingsPrivacyPolicy => 'Chính sách bảo mật';

  @override
  String get settingsTermsOfUse => 'Điều khoản sử dụng';

  @override
  String get settingsChooseLanguage => 'Chọn ngôn ngữ';

  @override
  String get settingsLangVietnamese => 'Tiếng Việt';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get aboutVersion => 'Phiên bản 1.0.0';

  @override
  String get aboutDescription =>
      'LoanBuddy giúp bạn tính toán lịch trả nợ, so sánh các khoản vay và đánh giá sức khỏe tài chính một cách thông minh và trực quan.\n\nỨng dụng được thiết kế dành riêng cho thị trường Việt Nam, hỗ trợ cả vay thế chấp lẫn vay tín chấp với đầy đủ các tính năng chuyên nghiệp.';

  @override
  String get aboutFeature1 => 'Tính lãi vay thế chấp';

  @override
  String get aboutFeature2 => 'Tính lãi vay tín chấp';

  @override
  String get aboutFeature3 => 'So sánh khoản vay';

  @override
  String get aboutFeature4 => 'Đánh giá sức khỏe tài chính';

  @override
  String get aboutFeature5 => 'Lưu lịch sử tra cứu';

  @override
  String get calcMortgageTitle => 'Vay Thế Chấp';

  @override
  String get calcLoanInfo => 'Thông tin khoản vay';

  @override
  String get calcLoanAmount => 'Số tiền vay';

  @override
  String get calcTermMonths => 'Thời gian vay (tháng)';

  @override
  String get calcFixedRate => 'Lãi suất cố định (%/năm)';

  @override
  String get calcFixedPeriod => 'Thời gian lãi suất cố định (tháng)';

  @override
  String get calcFloatingRate => 'Lãi suất thả nổi (%/năm)';

  @override
  String get calcGracePeriod => 'Thời gian ân hạn gốc (tháng)';

  @override
  String get calcPaymentMethod => 'Phương thức thanh toán';

  @override
  String get calcMethodDeclining => 'Gốc chia đều, lãi giảm dần';

  @override
  String get calcMethodDecliningDesc => 'Gốc cố định hàng tháng, lãi giảm dần';

  @override
  String get calcMethodEqual => 'Trả góp đều hàng tháng';

  @override
  String get calcMethodEqualDesc => 'Tổng tiền thanh toán hàng tháng bằng nhau';

  @override
  String get calcMethodInterestOnly => 'Chỉ trả lãi';

  @override
  String get calcMethodInterestOnlyDesc =>
      'Chỉ trả lãi mỗi tháng, hoàn trả toàn bộ gốc vào tháng cuối';

  @override
  String get calcScheduleButton => 'Tính lịch trả nợ';

  @override
  String get calcValidatorAmount => 'Nhập số tiền';

  @override
  String get calcValidatorInvalid => 'Không hợp lệ';

  @override
  String get calcValidatorValue => 'Nhập giá trị';

  @override
  String get comparisonTitle => 'So Sánh Khoản Vay';

  @override
  String get comparisonAddOption => 'Thêm phương án';

  @override
  String get comparisonCompareButton => 'So sánh ngay';

  @override
  String get comparisonPrincipal => 'Tiền gốc (VNĐ)';

  @override
  String get comparisonFixedRate => 'Lãi suất cố định (%/năm)';

  @override
  String get comparisonFixedPeriod => 'Thời gian cố định (tháng)';

  @override
  String get comparisonFloatingRate => 'Lãi suất thả nổi (%/năm)';

  @override
  String get comparisonTerm => 'Thời hạn vay (tháng)';

  @override
  String get comparisonGrace => 'Ân hạn gốc (tháng)';

  @override
  String get comparisonMethodDeclining => 'Dư nợ giảm dần';

  @override
  String get comparisonMethodEqual => 'Trả góp đều';

  @override
  String comparisonOptionLabel(int index) {
    return 'Phương án $index';
  }

  @override
  String comparisonResultLabel(int index) {
    return 'Phương Án $index';
  }

  @override
  String get comparisonTotalPrincipal => 'Tổng gốc';

  @override
  String get comparisonTotalInterest => 'Tổng lãi';

  @override
  String get comparisonHighestMonthly => 'Mức cao nhất/tháng';

  @override
  String get comparisonLowestMonthly => 'Mức thấp nhất/tháng';

  @override
  String get comparisonTotalPayment => 'Tổng gốc và lãi';

  @override
  String get comparisonAllEqual => 'Các phương án tiết kiệm bằng nhau';

  @override
  String comparisonBestOption(int index) {
    return 'Phương án $index tiết kiệm nhất';
  }

  @override
  String comparisonSavingDiff(String amount) {
    return 'Mức chênh lệch: $amountđ';
  }

  @override
  String get consumerTitle => 'Vay Tín Chấp';

  @override
  String get consumerLoanAmount => 'Số tiền vay';

  @override
  String get consumerTotalInterest => 'Tổng lãi';

  @override
  String get consumerMonthlyPayment => 'Trả hàng tháng';

  @override
  String get consumerTotalPayment => 'Tổng thanh toán';

  @override
  String get consumerAnnualRate => 'Lãi suất hàng năm';

  @override
  String get consumerTermMonths => 'Thời gian vay';

  @override
  String get consumerScheduleButton => 'Tính lịch trả nợ';

  @override
  String get estimatorTitle => 'Sức Khỏe Tài Chính';

  @override
  String get estimatorSubtitle => 'Đánh giá khoản vay có phù hợp với bạn không';

  @override
  String get estimatorSectionTitle => 'Đánh giá sức khỏe tài chính';

  @override
  String get estimatorHint => 'Nhập thông tin để đánh giá sức khỏe tài chính';

  @override
  String get estimatorIncome => 'Thu nhập thực nhận mỗi tháng của bạn (VNĐ)';

  @override
  String get estimatorExpenses =>
      'Mỗi tháng bạn chi tiêu khoảng bao nhiêu (VNĐ)';

  @override
  String get estimatorExistingDebt =>
      'Hiện tại bạn đang trả góp các khoản vay bao nhiêu mỗi tháng? (VNĐ)';

  @override
  String get estimatorLoanAmount => 'Số tiền muốn vay (VNĐ)';

  @override
  String get estimatorTermMonths => 'Thời hạn vay (tháng)';

  @override
  String get estimatorRateNote =>
      'Lãi suất ước tính 12%/năm · Phương thức trả góp đều hàng tháng';

  @override
  String get estimatorButton => 'Đánh giá';

  @override
  String get estimatorValidation =>
      'Vui lòng nhập đầy đủ thu nhập, số tiền vay và thời hạn vay (phải lớn hơn 0)';

  @override
  String get estimatorResultTitle => 'Khoản vay này có phù hợp với bạn không?';

  @override
  String get estimatorExpectedPayment => 'Khoản trả dự kiến là';

  @override
  String get estimatorPressureLevel => 'Mức áp lực tài chính là';

  @override
  String get estimatorRemainingAfter => 'Sau khi trả khoản vay, bạn còn lại là';

  @override
  String get estimatorLevelVerySafeLabel => 'Rất an toàn';

  @override
  String get estimatorLevelVerySafeMsg =>
      'Khoản vay này hoàn toàn phù hợp với thu nhập của bạn. Bạn có thể thoải mái trả khoản vay này mà không ảnh hưởng nhiều đến cuộc sống hàng ngày.';

  @override
  String get estimatorLevelSafeLabel => 'An toàn';

  @override
  String get estimatorLevelSafeMsg =>
      'Khoản vay này nằm trong vùng tài chính an toàn. Bạn vẫn còn đủ dư địa để xử lý các chi phí phát sinh hàng tháng.';

  @override
  String get estimatorLevelConsiderLabel => 'Cần cân nhắc';

  @override
  String get estimatorLevelConsiderMsg =>
      'Khoản vay này tạo ra một chút áp lực trong những tháng có chi phí phát sinh. Bạn vẫn có thể vay nhưng nên có quỹ dự phòng ít nhất 3 tháng chi tiêu trước khi quyết định.';

  @override
  String get estimatorLevelHighPressureLabel => 'Áp lực cao';

  @override
  String get estimatorLevelHighPressureMsg =>
      'Sau khi trả khoản vay, số tiền còn lại chưa đến nửa tháng chi tiêu. Một khoản phát sinh nhỏ cũng có thể gây khó khăn. Nên cân nhắc giảm số tiền vay hoặc kéo dài thời hạn.';

  @override
  String get estimatorLevelImbalancedLabel => 'Mất cân đối tài chính';

  @override
  String get estimatorLevelImbalancedMsg =>
      'Thu nhập của bạn không đủ để trang trải chi tiêu và khoản vay này. Bạn nên giảm số tiền vay, kéo dài thời hạn, hoặc tăng thu nhập trước khi vay.';

  @override
  String get estimatorLevelCantBorrowLabel => 'Không thể vay';

  @override
  String get estimatorLevelCantBorrowMsg =>
      'Bạn không thể vay trong thời điểm này. Khoản trả vượt quá toàn bộ thu nhập của bạn.';

  @override
  String get scheduleTitle => 'Kết Quả';

  @override
  String get scheduleTotalInterest => 'Tổng tiền lãi phải trả';

  @override
  String get scheduleTotalPayment => 'Tổng phải thanh toán';

  @override
  String get scheduleHighestPayment => 'Mức thanh toán cao nhất';

  @override
  String get scheduleLowestPayment => 'Mức thanh toán thấp nhất';

  @override
  String get scheduleIncludesPrincipalInterest => 'Bao gồm gốc và lãi';

  @override
  String schedulePeriod(int period) {
    return 'Kỳ thứ $period';
  }

  @override
  String scheduleRateChangeWarning(int period) {
    return 'Sau thời gian ưu đãi (kỳ $period):';
  }

  @override
  String schedulePaymentChange(String direction, String amount) {
    return 'Khoản thanh toán $direction$amount/tháng';
  }

  @override
  String get scheduleChangeRate => 'Đổi lãi suất';

  @override
  String get scheduleExportFile => 'Xuất file';

  @override
  String get scheduleExportTitle => 'Xuất lịch trả nợ';

  @override
  String get scheduleChooseFormat => 'Chọn định dạng file';

  @override
  String get scheduleExportPDF => 'Xuất PDF';

  @override
  String get scheduleExportPDFDesc => 'Định dạng đẹp, dễ chia sẻ và in ấn';

  @override
  String get scheduleExportCSV => 'Xuất CSV';

  @override
  String get scheduleExportCSVDesc => 'Mở được bằng Excel, Google Sheets';

  @override
  String scheduleFileReady(String type) {
    return 'File $type đã tạo xong';
  }

  @override
  String get scheduleShareAction => 'Bạn muốn làm gì với file này?';

  @override
  String scheduleShareFile(String type) {
    return 'Chia sẻ $type ngay';
  }

  @override
  String scheduleSaveFile(String type) {
    return 'Lưu $type vào máy';
  }

  @override
  String scheduleShareError(String error) {
    return 'Lỗi chia sẻ: $error';
  }

  @override
  String get adLoadFailed => 'Không tải được quảng cáo, vui lòng thử lại sau.';

  @override
  String adScheduleLockRemaining(int count) {
    return 'Còn $count kỳ trả nợ nữa';
  }

  @override
  String get adScheduleLockHint =>
      'Xem quảng cáo ngắn để xem toàn bộ lịch trả nợ';

  @override
  String get adScheduleLockButton => 'Xem quảng cáo để xem tiếp';

  @override
  String adExportTitle(String type) {
    return 'Xem quảng cáo để xuất file $type';
  }

  @override
  String get adExportHint =>
      'Quảng cáo ngắn khoảng 15-30 giây, không watermark khi xuất xong.';

  @override
  String get adExportButton => 'Xem quảng cáo';

  @override
  String get tableColPeriod => 'Kỳ';

  @override
  String get tableColTotal => 'Tổng trả';

  @override
  String get tableColPrincipal => 'Gốc';

  @override
  String get tableColInterest => 'Lãi';

  @override
  String get tableColBalance => 'Dư nợ còn lại';

  @override
  String get consumerScheduleTitle => 'Kết Quả';

  @override
  String get consumerScheduleMonthly => 'Trả hàng tháng';

  @override
  String get consumerScheduleTotalPayment => 'Tổng thanh toán';

  @override
  String get consumerScheduleTotalInterest => 'Tổng lãi phải trả';

  @override
  String get consumerScheduleTerm => 'Kỳ hạn vay';

  @override
  String get consumerScheduleFixed => 'Cố định mỗi kỳ';

  @override
  String get consumerScheduleIncludesPrincipal => 'Bao gồm gốc và lãi';

  @override
  String consumerSchedulePercentOfTotal(String percent) {
    return 'Chiếm $percent% gốc và lãi';
  }

  @override
  String consumerScheduleYears(String years) {
    return 'Tương đương $years năm';
  }

  @override
  String get rateCheckerTitle => 'Kiểm tra lãi suất vay';

  @override
  String get rateCheckerSubtitle =>
      'Ước tính lãi suất vay hiện tại của khoản vay đang trả';

  @override
  String get rateCheckerSectionTitle => 'Ước tính lãi suất hiện tại';

  @override
  String get rateCheckerHint => 'Nhập thông tin khoản vay đang trả để ước tính';

  @override
  String get rateCheckerOriginalAmount => 'Số tiền vay gốc ban đầu';

  @override
  String get rateCheckerStartDate => 'Ngày bắt đầu vay';

  @override
  String get rateCheckerTotalTerm => 'Tổng thời gian vay';

  @override
  String get rateCheckerLastPayment => 'Số tiền thanh toán kỳ gần nhất';

  @override
  String get rateCheckerMethod => 'Phương thức tính lãi';

  @override
  String get rateCheckerMethodDeclining => 'Gốc giảm dần';

  @override
  String get rateCheckerMethodEqual => 'Trả góp đều';

  @override
  String get rateCheckerMethodInterestOnly => 'Chỉ trả lãi';

  @override
  String get rateCheckerButton => 'Ước tính lãi suất';

  @override
  String get rateCheckerValidation => 'Vui lòng kiểm tra lại thông tin đã nhập';

  @override
  String get rateCheckerNoResult =>
      'Không thể ước tính với thông tin đã nhập. Vui lòng kiểm tra lại số tiền thanh toán hoặc phương thức tính lãi.';

  @override
  String get rateCheckerResultHeader => '— Kết quả —';

  @override
  String get rateCheckerResultTitle => 'Lãi suất ước tính hiện tại';

  @override
  String get rateCheckerResultNote =>
      'Dựa trên dư nợ còn lại và số tiền đang thanh toán mỗi kỳ';

  @override
  String get rateCheckerResultDisclaimer =>
      '* Đây là số liệu ước tính, không phải lãi suất chính thức từ ngân hàng.';

  @override
  String get rateCheckerInfoBox =>
      'Kết quả là ước tính dựa trên số liệu bạn nhập, có thể chênh lệch nhẹ so với lãi suất chính thức ngân hàng áp dụng.';

  @override
  String get fullPayoffTitle => 'Tất Toán Toàn Phần';

  @override
  String get fullPayoffSubtitle =>
      'Tính chi phí khi trả hết khoản vay trước hạn';

  @override
  String get fullPayoffSectionTitle => 'Thông tin khoản vay';

  @override
  String get fullPayoffOriginalAmount => 'Số tiền vay gốc ban đầu';

  @override
  String get fullPayoffStartDate => 'Ngày bắt đầu vay';

  @override
  String get fullPayoffTotalTerm => 'Tổng thời gian vay';

  @override
  String get fullPayoffMethod => 'Phương thức tính lãi';

  @override
  String get fullPayoffMethodDeclining => 'Gốc giảm dần';

  @override
  String get fullPayoffMethodEqual => 'Trả góp đều';

  @override
  String get fullPayoffGracePeriod => 'Thời gian ân hạn gốc ban đầu (nếu có)';

  @override
  String get fullPayoffFixedRate => 'Lãi suất cố định';

  @override
  String get fullPayoffFixedPeriod => 'Thời gian ưu đãi';

  @override
  String get fullPayoffFloatingRate => 'Lãi suất thả nổi (sau ưu đãi)';

  @override
  String get fullPayoffTargetDate => 'Ngày dự kiến tất toán';

  @override
  String get fullPayoffPenaltyRate => 'Phí phạt trả trước';

  @override
  String get fullPayoffButton => 'Tính chi phí tất toán';

  @override
  String get fullPayoffValidation => 'Vui lòng kiểm tra lại thông tin đã nhập';

  @override
  String get fullPayoffNoResult =>
      'Không thể tính với thông tin đã nhập. Vui lòng kiểm tra lại ngày tất toán, thời gian vay và thời gian ân hạn.';

  @override
  String get fullPayoffResultHeader => '— Kết quả —';

  @override
  String get fullPayoffTotalNeeded => 'Tổng số tiền cần chuẩn bị để tất toán';

  @override
  String get fullPayoffRemainingBalance => 'Dư nợ gốc còn lại';

  @override
  String get fullPayoffPenaltyFee => 'Phí phạt trả trước hạn';

  @override
  String get fullPayoffInterestSaved =>
      'Lãi tiết kiệm được (so với trả hết theo lịch cũ)';

  @override
  String fullPayoffEarlyMonths(int months, String years) {
    return 'Thoát nợ sớm hơn $months tháng ($years năm)';
  }

  @override
  String get fullPayoffResultDisclaimer =>
      '* Số liệu ước tính, chưa bao gồm các phí khác (nếu có) theo quy định ngân hàng.';

  @override
  String get fullPayoffInfoBox =>
      'Phí phạt thực tế tùy theo hợp đồng và năm tất toán. Vui lòng kiểm tra với ngân hàng để có số liệu chính xác.';

  @override
  String get partialTitle => 'Tất Toán Từng Phần';

  @override
  String get partialSubtitle =>
      'Tính lại lịch trả nợ khi trả thêm một phần gốc';

  @override
  String get partialSectionTitle => 'Thông tin khoản vay';

  @override
  String get partialExtraDate => 'Ngày trả thêm';

  @override
  String get partialPenaltyRate => 'Phí phạt trả trước';

  @override
  String get partialExtraAmount => 'Số tiền muốn trả thêm vào gốc';

  @override
  String get partialPriority => 'Bạn muốn ưu tiên điều gì?';

  @override
  String get partialPriorityGrace => 'Ân hạn gốc';

  @override
  String get partialPriorityReducePayment => 'Giảm số tiền trả hàng tháng';

  @override
  String get partialPriorityShortenTerm => 'Rút ngắn thời hạn vay';

  @override
  String get partialButton => 'Tính lại lịch trả nợ';

  @override
  String get partialValidation => 'Vui lòng kiểm tra lại thông tin đã nhập';

  @override
  String get partialNoResult =>
      'Không thể tính với thông tin đã nhập. Vui lòng kiểm tra lại số tiền trả thêm, thời gian ân hạn và ngày áp dụng.';

  @override
  String get partialResultHeader => '— Kết quả —';

  @override
  String get partialRemainingBalance => 'Dư nợ còn lại sau khi trả thêm';

  @override
  String get partialPenaltyFee => 'Phí phạt trả trước hạn';

  @override
  String get partialNewTerm => 'Thời hạn vay mới';

  @override
  String partialTermReduced(int months) {
    return 'Giảm $months tháng';
  }

  @override
  String get partialMonthlyPayment => 'Khoản trả hàng tháng';

  @override
  String get partialNoChange => 'Không đổi';

  @override
  String get partialGracePeriods => 'Số kỳ được ân hạn gốc';

  @override
  String get partialGraceNote => 'Chỉ trả lãi trong giai đoạn này';

  @override
  String get partialGracePayment => 'Khoản trả trong giai đoạn ân hạn';

  @override
  String get partialTermLabel => 'Thời hạn vay';

  @override
  String get partialInterestSaved => 'Lãi tiết kiệm được';

  @override
  String get partialResultDisclaimer =>
      '* Số liệu ước tính. Vui lòng tham khảo chuyên gia tài chính trước khi quyết định.';

  @override
  String get partialGraceInfoTitle => 'Ân hạn gốc là gì?';

  @override
  String get partialGraceInfoBody =>
      'Số tiền bạn trả thêm sẽ được dùng để giảm dư nợ ngay lập tức. Sau đó, LoanBuddy tự tính ra một số kỳ tiếp theo bạn được tạm ngưng trả gốc — trong khoảng thời gian này bạn chỉ cần trả lãi trên dư nợ đã giảm. Sau khi hết thời gian ân hạn, bạn quay lại trả gốc và lãi như bình thường, và khoản vay vẫn kết thúc đúng vào thời hạn ban đầu.';

  @override
  String get partialGraceInfoNote =>
      'Phù hợp khi bạn muốn giảm áp lực tài chính trong một giai đoạn ngắn sắp tới.';

  @override
  String get partialReduceInfoTitle => 'Giảm số tiền trả hàng tháng là gì?';

  @override
  String get partialReduceInfoBody =>
      'Số tiền bạn trả thêm sẽ giảm dư nợ gốc ngay lập tức. Thời hạn vay giữ nguyên không đổi. Vì dư nợ còn lại sẽ được chia đều cho thời gian còn lại, phần gốc phải trả mỗi tháng sẽ thấp hơn — dẫn đến số tiền trả hàng tháng giảm.';

  @override
  String get partialReduceInfoNote =>
      'Phù hợp khi bạn muốn giảm gánh nặng chi tiêu hàng tháng lâu dài.';

  @override
  String get partialShortenInfoTitle => 'Rút ngắn thời hạn vay là gì?';

  @override
  String get partialShortenInfoBody =>
      'Số tiền bạn trả thêm sẽ giảm dư nợ gốc ngay lập tức. Khoản trả hàng tháng giữ nguyên không đổi, nhưng vì dư nợ thấp hơn, bạn sẽ trả hết khoản vay sớm hơn so với lịch ban đầu.';

  @override
  String get partialShortenInfoNote =>
      'Phù hợp khi bạn muốn tiết kiệm lãi nhiều nhất và thoát nợ sớm nhất.';

  @override
  String get earlySelectTitle => 'Kịch Bản Tất Toán';

  @override
  String get earlySelectSubtitle => 'Chọn loại kịch bản bạn muốn tính';

  @override
  String get earlySelectFullTitle => 'Tất toán toàn phần';

  @override
  String get earlySelectFullDesc =>
      'Trả hết toàn bộ dư nợ để chấm dứt khoản vay tại một thời điểm';

  @override
  String get earlySelectPartialTitle => 'Tất toán từng phần';

  @override
  String get earlySelectPartialDesc =>
      'Trả thêm một khoản vào gốc, giảm dư nợ hoặc rút ngắn thời hạn';

  @override
  String get earlySelectNote =>
      'Chỉ áp dụng cho khoản vay thế chấp. Kết quả mang tính tham khảo.';

  @override
  String get refinanceTitle => 'Phân Tích Chuyển Nợ';

  @override
  String get refinanceSubtitle =>
      'So sánh khoản vay hiện tại với khoản vay mới để quyết định có nên chuyển';

  @override
  String get refinanceCurrentLoan => 'Khoản vay hiện tại';

  @override
  String get refinanceCurrentLoanInfo => 'Thông tin từ ngân hàng đang vay';

  @override
  String get refinanceRemainingBalance => 'Dư nợ còn lại (VNĐ)';

  @override
  String get refinanceRemainingTerm => 'Thời hạn còn lại';

  @override
  String get refinanceCurrentRate => 'Lãi suất hiện tại';

  @override
  String get refinancePrepaymentFee => 'Phí trả nợ trước hạn';

  @override
  String get refinancePaymentMethod => 'Phương thức thanh toán';

  @override
  String get refinanceMethodDeclining => 'Gốc chia đều';

  @override
  String get refinanceMethodEqual => 'Trả góp đều';

  @override
  String get refinanceNewLoan => 'Khoản vay mới dự kiến';

  @override
  String get refinanceNewLoanInfo => 'Ngân hàng bạn muốn chuyển sang';

  @override
  String get refinanceNewAmount => 'Số tiền vay mới';

  @override
  String get refinanceNewTerm => 'Thời gian vay mới';

  @override
  String get refinanceFixedRate => 'Lãi suất cố định';

  @override
  String get refinancePromoTerm => 'Thời gian ưu đãi';

  @override
  String get refinanceFloatingRate => 'Lãi suất thả nổi';

  @override
  String get refinanceProcessingFee => 'Chi phí làm hồ sơ';

  @override
  String get refinanceButton => 'Phân tích chuyển nợ';

  @override
  String get refinanceValidation =>
      'Vui lòng nhập đầy đủ thông tin bắt buộc ở cả 2 khoản vay (phải lớn hơn 0)';

  @override
  String get refinanceResultHeader => '— Kết quả —';

  @override
  String get refinanceTotalCost => 'Tổng chi phí chuyển nợ';

  @override
  String get refinanceBreakevenMonths => 'Số tháng hòa vốn';

  @override
  String refinanceBreakevenValue(int months) {
    return '$months tháng';
  }

  @override
  String get refinanceNoBreakeven => 'Không hòa vốn';

  @override
  String get refinanceInterestSavedPromo =>
      'Lãi tiết kiệm trong thời gian ưu đãi';

  @override
  String get refinanceInterestSavedTotal => 'Lãi tiết kiệm suốt thời gian vay';

  @override
  String get refinanceInterestSavedMonthly =>
      'Lãi tiết kiệm trung bình mỗi tháng';

  @override
  String get refinanceNoResult =>
      'Không thể phân tích với thông tin đã nhập. Vui lòng kiểm tra lại các trường bắt buộc.';

  @override
  String get refinanceResultDisclaimer =>
      '* Lãi tiết kiệm suốt thời gian vay tính trên toàn bộ thời hạn vay mới. Số liệu ước tính.';

  @override
  String get feedbackTitle => 'Góp Ý';

  @override
  String get feedbackSubtitle => 'Ý kiến của bạn giúp LoanBuddy tốt hơn';

  @override
  String get feedbackEmailHint => 'Email (không bắt buộc)';

  @override
  String get feedbackContentHint => 'Nội dung góp ý...';

  @override
  String get feedbackButton => 'Gửi';

  @override
  String get feedbackFooter =>
      'Bạn cũng có thể gửi email cho chúng tôi:\nvinhdinh2610@gmail.com';

  @override
  String get feedbackValidation => 'Vui lòng nhập nội dung góp ý';

  @override
  String get feedbackSuccess => 'Cảm ơn bạn đã góp ý!';

  @override
  String get feedbackNoEmail => 'Không tìm thấy ứng dụng email';

  @override
  String get feedbackError => 'Có lỗi xảy ra, vui lòng thử lại';

  @override
  String get drawerSlogan => 'Vay thông minh, Tương lai vững vàng';

  @override
  String get drawerHome => 'Trang chủ';

  @override
  String get drawerHistory => 'Lịch sử tra cứu';

  @override
  String get drawerSettings => 'Cài đặt';

  @override
  String get drawerFeedback => 'Góp ý';

  @override
  String get drawerPrivacyPolicy => 'Chính sách bảo mật';

  @override
  String get drawerTermsOfUse => 'Điều khoản sử dụng';

  @override
  String get unitMonths => 'tháng';

  @override
  String get unitBillion => 'tỷ';

  @override
  String get unitMillion => 'triệu';

  @override
  String get partialInfoBox =>
      'Phí phạt thực tế tùy theo hợp đồng và năm trả thêm. Vui lòng kiểm tra với ngân hàng.';

  @override
  String partialPaymentReduced(String amount) {
    return 'Giảm $amount/tháng';
  }
}
