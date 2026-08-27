import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'LoanBuddy'**
  String get appTitle;

  /// No description provided for @appSlogan.
  ///
  /// In vi, this message translates to:
  /// **'Vay thông minh, Tương lai vững vàng'**
  String get appSlogan;

  /// No description provided for @appVersion.
  ///
  /// In vi, this message translates to:
  /// **'LoanBuddy v1.0.0'**
  String get appVersion;

  /// No description provided for @appVersionShort.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản 1.0.0'**
  String get appVersionShort;

  /// No description provided for @resultDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'* Kết quả mang tính tham khảo, không đại diện cho lời khuyên đầu tư hay tài chính.'**
  String get resultDisclaimer;

  /// No description provided for @resultDisclaimerShort.
  ///
  /// In vi, this message translates to:
  /// **'* Kết quả mang tính tham khảo.'**
  String get resultDisclaimerShort;

  /// No description provided for @fillCompletely.
  ///
  /// In vi, this message translates to:
  /// **'Nhập đầy đủ để tính chính xác'**
  String get fillCompletely;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @send.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get send;

  /// No description provided for @calculate.
  ///
  /// In vi, this message translates to:
  /// **'Tính'**
  String get calculate;

  /// No description provided for @export.
  ///
  /// In vi, this message translates to:
  /// **'Xuất file'**
  String get export;

  /// No description provided for @share.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get share;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @featureComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Chức năng đang trong quá trình hoàn thiện'**
  String get featureComingSoon;

  /// No description provided for @navHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get navSettings;

  /// No description provided for @splashSlogan.
  ///
  /// In vi, this message translates to:
  /// **'Vay thông minh,\nTương lai vững vàng'**
  String get splashSlogan;

  /// No description provided for @homeGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào 👋'**
  String get homeGreeting;

  /// No description provided for @homeQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn tính gì\nhôm nay?'**
  String get homeQuestion;

  /// No description provided for @homeSectionLoan.
  ///
  /// In vi, this message translates to:
  /// **'Vay & Tính toán'**
  String get homeSectionLoan;

  /// No description provided for @homeMortgage.
  ///
  /// In vi, this message translates to:
  /// **'Vay thế chấp'**
  String get homeMortgage;

  /// No description provided for @homeConsumer.
  ///
  /// In vi, this message translates to:
  /// **'Vay tín chấp'**
  String get homeConsumer;

  /// No description provided for @homeComparison.
  ///
  /// In vi, this message translates to:
  /// **'So sánh'**
  String get homeComparison;

  /// No description provided for @homeSectionManage.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý khoản vay'**
  String get homeSectionManage;

  /// No description provided for @homeEarlySettlement.
  ///
  /// In vi, this message translates to:
  /// **'Tất toán\ntrước hạn'**
  String get homeEarlySettlement;

  /// No description provided for @homeEarlySettlementFull.
  ///
  /// In vi, this message translates to:
  /// **'Tất toán trước hạn'**
  String get homeEarlySettlementFull;

  /// No description provided for @homeDebtRefinance.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích\nchuyển nợ'**
  String get homeDebtRefinance;

  /// No description provided for @homeDebtRefinanceFull.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích chuyển nợ'**
  String get homeDebtRefinanceFull;

  /// No description provided for @homeSectionPersonal.
  ///
  /// In vi, this message translates to:
  /// **'Tài chính cá nhân'**
  String get homeSectionPersonal;

  /// No description provided for @homeFinancialHealth.
  ///
  /// In vi, this message translates to:
  /// **'Sức khỏe\ntài chính'**
  String get homeFinancialHealth;

  /// No description provided for @homeFinancialHealthFull.
  ///
  /// In vi, this message translates to:
  /// **'Sức khỏe tài chính'**
  String get homeFinancialHealthFull;

  /// No description provided for @homeRateChecker.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra\nlãi suất'**
  String get homeRateChecker;

  /// No description provided for @homeRateCheckerFull.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra lãi suất'**
  String get homeRateCheckerFull;

  /// No description provided for @homeExplore.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá LoanBuddy'**
  String get homeExplore;

  /// No description provided for @homeRecentLoans.
  ///
  /// In vi, this message translates to:
  /// **'Khoản vay gần đây'**
  String get homeRecentLoans;

  /// No description provided for @homeReview.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại'**
  String get homeReview;

  /// No description provided for @homeBannerMortgageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tính lãi vay thế chấp'**
  String get homeBannerMortgageTitle;

  /// No description provided for @homeBannerMortgageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Lên kế hoạch mua nhà với lịch trả nợ chi tiết'**
  String get homeBannerMortgageSubtitle;

  /// No description provided for @homeBannerConsumerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tính lãi vay tín chấp'**
  String get homeBannerConsumerTitle;

  /// No description provided for @homeBannerConsumerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Ước tính khoản vay tiêu dùng nhanh chóng'**
  String get homeBannerConsumerSubtitle;

  /// No description provided for @homeBannerHealthTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra sức khỏe tài chính'**
  String get homeBannerHealthTitle;

  /// No description provided for @homeBannerHealthSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xem mức vay phù hợp với thu nhập của bạn'**
  String get homeBannerHealthSubtitle;

  /// No description provided for @homePerYear.
  ///
  /// In vi, this message translates to:
  /// **'%/năm'**
  String get homePerYear;

  /// No description provided for @homeMonths.
  ///
  /// In vi, this message translates to:
  /// **'{months} tháng'**
  String homeMonths(int months);

  /// No description provided for @homeLoanTypeMortgage.
  ///
  /// In vi, this message translates to:
  /// **'Vay thế chấp'**
  String get homeLoanTypeMortgage;

  /// No description provided for @homeLoanTypeConsumer.
  ///
  /// In vi, this message translates to:
  /// **'Vay tín chấp'**
  String get homeLoanTypeConsumer;

  /// No description provided for @homeMethodDeclining.
  ///
  /// In vi, this message translates to:
  /// **'Gốc giảm dần'**
  String get homeMethodDeclining;

  /// No description provided for @homeMethodInterestOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ trả lãi'**
  String get homeMethodInterestOnly;

  /// No description provided for @homeMethodEqual.
  ///
  /// In vi, this message translates to:
  /// **'Trả góp đều'**
  String get homeMethodEqual;

  /// No description provided for @historyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch Sử'**
  String get historyTitle;

  /// No description provided for @historyDeleteAll.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tất cả'**
  String get historyDeleteAll;

  /// No description provided for @historyDeleteAllConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xóa toàn bộ lịch sử?'**
  String get historyDeleteAllConfirm;

  /// No description provided for @historyDeleteAllMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hành động này không thể hoàn tác.'**
  String get historyDeleteAllMessage;

  /// No description provided for @historyDeleteAllButton.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tất cả'**
  String get historyDeleteAllButton;

  /// No description provided for @historyEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch sử tra cứu'**
  String get historyEmpty;

  /// No description provided for @historyEmptyHint.
  ///
  /// In vi, this message translates to:
  /// **'Tính lịch trả nợ để lưu vào đây'**
  String get historyEmptyHint;

  /// No description provided for @historyCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} bảng tính đã lưu'**
  String historyCount(int count);

  /// No description provided for @historyJustNow.
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get historyJustNow;

  /// No description provided for @historyMinutesAgo.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút trước'**
  String historyMinutesAgo(int minutes);

  /// No description provided for @historyHoursAgo.
  ///
  /// In vi, this message translates to:
  /// **'{hours} giờ trước'**
  String historyHoursAgo(int hours);

  /// No description provided for @historyYesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get historyYesterday;

  /// No description provided for @historyMethodDeclining.
  ///
  /// In vi, this message translates to:
  /// **'Gốc giảm dần'**
  String get historyMethodDeclining;

  /// No description provided for @historyMethodEqual.
  ///
  /// In vi, this message translates to:
  /// **'Trả góp đều'**
  String get historyMethodEqual;

  /// No description provided for @historyMethodConsumer.
  ///
  /// In vi, this message translates to:
  /// **'Tín chấp'**
  String get historyMethodConsumer;

  /// No description provided for @historyTypeMortgage.
  ///
  /// In vi, this message translates to:
  /// **'Vay thế chấp'**
  String get historyTypeMortgage;

  /// No description provided for @historyTypeConsumer.
  ///
  /// In vi, this message translates to:
  /// **'Vay tín chấp'**
  String get historyTypeConsumer;

  /// No description provided for @historyTotalInterest.
  ///
  /// In vi, this message translates to:
  /// **'Tổng lãi: {amount}'**
  String historyTotalInterest(String amount);

  /// No description provided for @historyPerYear.
  ///
  /// In vi, this message translates to:
  /// **'%/năm'**
  String get historyPerYear;

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài Đặt'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get settingsLanguage;

  /// No description provided for @settingsSupport.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ'**
  String get settingsSupport;

  /// No description provided for @settingsFeedback.
  ///
  /// In vi, this message translates to:
  /// **'Góp ý'**
  String get settingsFeedback;

  /// No description provided for @settingsAbout.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu ứng dụng'**
  String get settingsAbout;

  /// No description provided for @settingsLegal.
  ///
  /// In vi, this message translates to:
  /// **'Pháp lý'**
  String get settingsLegal;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfUse.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản sử dụng'**
  String get settingsTermsOfUse;

  /// No description provided for @settingsChooseLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get settingsChooseLanguage;

  /// No description provided for @settingsLangVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get settingsLangVietnamese;

  /// No description provided for @settingsLangEnglish.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get settingsLangEnglish;

  /// No description provided for @aboutVersion.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutDescription.
  ///
  /// In vi, this message translates to:
  /// **'LoanBuddy giúp bạn tính toán lịch trả nợ, so sánh các khoản vay và đánh giá sức khỏe tài chính một cách thông minh và trực quan.\n\nỨng dụng được thiết kế dành riêng cho thị trường Việt Nam, hỗ trợ cả vay thế chấp lẫn vay tín chấp với đầy đủ các tính năng chuyên nghiệp.'**
  String get aboutDescription;

  /// No description provided for @aboutFeature1.
  ///
  /// In vi, this message translates to:
  /// **'Tính lãi vay thế chấp'**
  String get aboutFeature1;

  /// No description provided for @aboutFeature2.
  ///
  /// In vi, this message translates to:
  /// **'Tính lãi vay tín chấp'**
  String get aboutFeature2;

  /// No description provided for @aboutFeature3.
  ///
  /// In vi, this message translates to:
  /// **'So sánh khoản vay'**
  String get aboutFeature3;

  /// No description provided for @aboutFeature4.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá sức khỏe tài chính'**
  String get aboutFeature4;

  /// No description provided for @aboutFeature5.
  ///
  /// In vi, this message translates to:
  /// **'Lưu lịch sử tra cứu'**
  String get aboutFeature5;

  /// No description provided for @aboutFeature6.
  ///
  /// In vi, this message translates to:
  /// **'Tất toán trước hạn'**
  String get aboutFeature6;

  /// No description provided for @aboutFeature7.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích chuyển nợ'**
  String get aboutFeature7;

  /// No description provided for @aboutFeature8.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra lãi suất'**
  String get aboutFeature8;

  /// No description provided for @calcMortgageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vay Thế Chấp'**
  String get calcMortgageTitle;

  /// No description provided for @calcLoanInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin khoản vay'**
  String get calcLoanInfo;

  /// No description provided for @calcLoanAmount.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền vay'**
  String get calcLoanAmount;

  /// No description provided for @calcTermMonths.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian vay (tháng)'**
  String get calcTermMonths;

  /// No description provided for @calcFixedRate.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất cố định (%/năm)'**
  String get calcFixedRate;

  /// No description provided for @calcFixedPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian lãi suất cố định (tháng)'**
  String get calcFixedPeriod;

  /// No description provided for @calcFloatingRate.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất thả nổi (%/năm)'**
  String get calcFloatingRate;

  /// No description provided for @calcGracePeriod.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian ân hạn gốc (tháng)'**
  String get calcGracePeriod;

  /// No description provided for @calcPaymentMethod.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức thanh toán'**
  String get calcPaymentMethod;

  /// No description provided for @calcMethodDeclining.
  ///
  /// In vi, this message translates to:
  /// **'Gốc chia đều, lãi giảm dần'**
  String get calcMethodDeclining;

  /// No description provided for @calcMethodDecliningDesc.
  ///
  /// In vi, this message translates to:
  /// **'Gốc cố định hàng tháng, lãi giảm dần'**
  String get calcMethodDecliningDesc;

  /// No description provided for @calcMethodEqual.
  ///
  /// In vi, this message translates to:
  /// **'Trả góp đều hàng tháng'**
  String get calcMethodEqual;

  /// No description provided for @calcMethodEqualDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tổng tiền thanh toán hàng tháng bằng nhau'**
  String get calcMethodEqualDesc;

  /// No description provided for @calcMethodInterestOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ trả lãi'**
  String get calcMethodInterestOnly;

  /// No description provided for @calcMethodInterestOnlyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ trả lãi mỗi tháng, hoàn trả toàn bộ gốc vào tháng cuối'**
  String get calcMethodInterestOnlyDesc;

  /// No description provided for @calcScheduleButton.
  ///
  /// In vi, this message translates to:
  /// **'Tính lịch trả nợ'**
  String get calcScheduleButton;

  /// No description provided for @calcValidatorAmount.
  ///
  /// In vi, this message translates to:
  /// **'Nhập số tiền'**
  String get calcValidatorAmount;

  /// No description provided for @calcValidatorInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Không hợp lệ'**
  String get calcValidatorInvalid;

  /// No description provided for @calcValidatorValue.
  ///
  /// In vi, this message translates to:
  /// **'Nhập giá trị'**
  String get calcValidatorValue;

  /// No description provided for @comparisonTitle.
  ///
  /// In vi, this message translates to:
  /// **'So Sánh Khoản Vay'**
  String get comparisonTitle;

  /// No description provided for @comparisonAddOption.
  ///
  /// In vi, this message translates to:
  /// **'Thêm phương án'**
  String get comparisonAddOption;

  /// No description provided for @comparisonCompareButton.
  ///
  /// In vi, this message translates to:
  /// **'So sánh ngay'**
  String get comparisonCompareButton;

  /// No description provided for @comparisonPrincipal.
  ///
  /// In vi, this message translates to:
  /// **'Tiền gốc (VNĐ)'**
  String get comparisonPrincipal;

  /// No description provided for @comparisonFixedRate.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất cố định (%/năm)'**
  String get comparisonFixedRate;

  /// No description provided for @comparisonFixedPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian cố định (tháng)'**
  String get comparisonFixedPeriod;

  /// No description provided for @comparisonFloatingRate.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất thả nổi (%/năm)'**
  String get comparisonFloatingRate;

  /// No description provided for @comparisonTerm.
  ///
  /// In vi, this message translates to:
  /// **'Thời hạn vay (tháng)'**
  String get comparisonTerm;

  /// No description provided for @comparisonGrace.
  ///
  /// In vi, this message translates to:
  /// **'Ân hạn gốc (tháng)'**
  String get comparisonGrace;

  /// No description provided for @comparisonMethodDeclining.
  ///
  /// In vi, this message translates to:
  /// **'Dư nợ giảm dần'**
  String get comparisonMethodDeclining;

  /// No description provided for @comparisonMethodEqual.
  ///
  /// In vi, this message translates to:
  /// **'Trả góp đều'**
  String get comparisonMethodEqual;

  /// No description provided for @comparisonOptionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phương án {index}'**
  String comparisonOptionLabel(int index);

  /// No description provided for @comparisonResultLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phương Án {index}'**
  String comparisonResultLabel(int index);

  /// No description provided for @comparisonTotalPrincipal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng gốc'**
  String get comparisonTotalPrincipal;

  /// No description provided for @comparisonTotalInterest.
  ///
  /// In vi, this message translates to:
  /// **'Tổng lãi'**
  String get comparisonTotalInterest;

  /// No description provided for @comparisonHighestMonthly.
  ///
  /// In vi, this message translates to:
  /// **'Mức cao nhất/tháng'**
  String get comparisonHighestMonthly;

  /// No description provided for @comparisonLowestMonthly.
  ///
  /// In vi, this message translates to:
  /// **'Mức thấp nhất/tháng'**
  String get comparisonLowestMonthly;

  /// No description provided for @comparisonTotalPayment.
  ///
  /// In vi, this message translates to:
  /// **'Tổng gốc và lãi'**
  String get comparisonTotalPayment;

  /// No description provided for @comparisonAllEqual.
  ///
  /// In vi, this message translates to:
  /// **'Các phương án tiết kiệm bằng nhau'**
  String get comparisonAllEqual;

  /// No description provided for @comparisonBestOption.
  ///
  /// In vi, this message translates to:
  /// **'Phương án {index} tiết kiệm nhất'**
  String comparisonBestOption(int index);

  /// No description provided for @comparisonSavingDiff.
  ///
  /// In vi, this message translates to:
  /// **'Mức chênh lệch: {amount}đ'**
  String comparisonSavingDiff(String amount);

  /// No description provided for @consumerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vay Tín Chấp'**
  String get consumerTitle;

  /// No description provided for @consumerLoanAmount.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền vay'**
  String get consumerLoanAmount;

  /// No description provided for @consumerTotalInterest.
  ///
  /// In vi, this message translates to:
  /// **'Tổng lãi'**
  String get consumerTotalInterest;

  /// No description provided for @consumerMonthlyPayment.
  ///
  /// In vi, this message translates to:
  /// **'Trả hàng tháng'**
  String get consumerMonthlyPayment;

  /// No description provided for @consumerTotalPayment.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thanh toán'**
  String get consumerTotalPayment;

  /// No description provided for @consumerAnnualRate.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất hàng năm'**
  String get consumerAnnualRate;

  /// No description provided for @consumerTermMonths.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian vay'**
  String get consumerTermMonths;

  /// No description provided for @consumerScheduleButton.
  ///
  /// In vi, this message translates to:
  /// **'Tính lịch trả nợ'**
  String get consumerScheduleButton;

  /// No description provided for @estimatorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sức Khỏe Tài Chính'**
  String get estimatorTitle;

  /// No description provided for @estimatorSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá khoản vay có phù hợp với bạn không'**
  String get estimatorSubtitle;

  /// No description provided for @estimatorSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá sức khỏe tài chính'**
  String get estimatorSectionTitle;

  /// No description provided for @estimatorHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập thông tin để đánh giá sức khỏe tài chính'**
  String get estimatorHint;

  /// No description provided for @estimatorIncome.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập thực nhận mỗi tháng của bạn (VNĐ)'**
  String get estimatorIncome;

  /// No description provided for @estimatorExpenses.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi tháng bạn chi tiêu khoảng bao nhiêu (VNĐ)'**
  String get estimatorExpenses;

  /// No description provided for @estimatorExistingDebt.
  ///
  /// In vi, this message translates to:
  /// **'Hiện tại bạn đang trả góp các khoản vay bao nhiêu mỗi tháng? (VNĐ)'**
  String get estimatorExistingDebt;

  /// No description provided for @estimatorLoanAmount.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền muốn vay (VNĐ)'**
  String get estimatorLoanAmount;

  /// No description provided for @estimatorTermMonths.
  ///
  /// In vi, this message translates to:
  /// **'Thời hạn vay (tháng)'**
  String get estimatorTermMonths;

  /// No description provided for @estimatorRateNote.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất ước tính 12%/năm · Phương thức trả góp đều hàng tháng'**
  String get estimatorRateNote;

  /// No description provided for @estimatorButton.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá'**
  String get estimatorButton;

  /// No description provided for @estimatorValidation.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập đầy đủ thu nhập, số tiền vay và thời hạn vay (phải lớn hơn 0)'**
  String get estimatorValidation;

  /// No description provided for @estimatorResultTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khoản vay này có phù hợp với bạn không?'**
  String get estimatorResultTitle;

  /// No description provided for @estimatorExpectedPayment.
  ///
  /// In vi, this message translates to:
  /// **'Khoản trả dự kiến là'**
  String get estimatorExpectedPayment;

  /// No description provided for @estimatorPressureLevel.
  ///
  /// In vi, this message translates to:
  /// **'Mức áp lực tài chính là'**
  String get estimatorPressureLevel;

  /// No description provided for @estimatorRemainingAfter.
  ///
  /// In vi, this message translates to:
  /// **'Sau khi trả khoản vay, bạn còn lại là'**
  String get estimatorRemainingAfter;

  /// No description provided for @estimatorLevelVerySafeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Rất an toàn'**
  String get estimatorLevelVerySafeLabel;

  /// No description provided for @estimatorLevelVerySafeMsg.
  ///
  /// In vi, this message translates to:
  /// **'Khoản vay này hoàn toàn phù hợp với thu nhập của bạn. Bạn có thể thoải mái trả khoản vay này mà không ảnh hưởng nhiều đến cuộc sống hàng ngày.'**
  String get estimatorLevelVerySafeMsg;

  /// No description provided for @estimatorLevelSafeLabel.
  ///
  /// In vi, this message translates to:
  /// **'An toàn'**
  String get estimatorLevelSafeLabel;

  /// No description provided for @estimatorLevelSafeMsg.
  ///
  /// In vi, this message translates to:
  /// **'Khoản vay này nằm trong vùng tài chính an toàn. Bạn vẫn còn đủ dư địa để xử lý các chi phí phát sinh hàng tháng.'**
  String get estimatorLevelSafeMsg;

  /// No description provided for @estimatorLevelConsiderLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cần cân nhắc'**
  String get estimatorLevelConsiderLabel;

  /// No description provided for @estimatorLevelConsiderMsg.
  ///
  /// In vi, this message translates to:
  /// **'Khoản vay này tạo ra một chút áp lực trong những tháng có chi phí phát sinh. Bạn vẫn có thể vay nhưng nên có quỹ dự phòng ít nhất 3 tháng chi tiêu trước khi quyết định.'**
  String get estimatorLevelConsiderMsg;

  /// No description provided for @estimatorLevelHighPressureLabel.
  ///
  /// In vi, this message translates to:
  /// **'Áp lực cao'**
  String get estimatorLevelHighPressureLabel;

  /// No description provided for @estimatorLevelHighPressureMsg.
  ///
  /// In vi, this message translates to:
  /// **'Sau khi trả khoản vay, số tiền còn lại chưa đến nửa tháng chi tiêu. Một khoản phát sinh nhỏ cũng có thể gây khó khăn. Nên cân nhắc giảm số tiền vay hoặc kéo dài thời hạn.'**
  String get estimatorLevelHighPressureMsg;

  /// No description provided for @estimatorLevelImbalancedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mất cân đối tài chính'**
  String get estimatorLevelImbalancedLabel;

  /// No description provided for @estimatorLevelImbalancedMsg.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập của bạn không đủ để trang trải chi tiêu và khoản vay này. Bạn nên giảm số tiền vay, kéo dài thời hạn, hoặc tăng thu nhập trước khi vay.'**
  String get estimatorLevelImbalancedMsg;

  /// No description provided for @estimatorLevelCantBorrowLabel.
  ///
  /// In vi, this message translates to:
  /// **'Không thể vay'**
  String get estimatorLevelCantBorrowLabel;

  /// No description provided for @estimatorLevelCantBorrowMsg.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không thể vay trong thời điểm này. Khoản trả vượt quá toàn bộ thu nhập của bạn.'**
  String get estimatorLevelCantBorrowMsg;

  /// No description provided for @scheduleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kết Quả'**
  String get scheduleTitle;

  /// No description provided for @scheduleTotalInterest.
  ///
  /// In vi, this message translates to:
  /// **'Tổng tiền lãi phải trả'**
  String get scheduleTotalInterest;

  /// No description provided for @scheduleTotalPayment.
  ///
  /// In vi, this message translates to:
  /// **'Tổng phải thanh toán'**
  String get scheduleTotalPayment;

  /// No description provided for @scheduleHighestPayment.
  ///
  /// In vi, this message translates to:
  /// **'Mức thanh toán cao nhất'**
  String get scheduleHighestPayment;

  /// No description provided for @scheduleLowestPayment.
  ///
  /// In vi, this message translates to:
  /// **'Mức thanh toán thấp nhất'**
  String get scheduleLowestPayment;

  /// No description provided for @scheduleIncludesPrincipalInterest.
  ///
  /// In vi, this message translates to:
  /// **'Bao gồm gốc và lãi'**
  String get scheduleIncludesPrincipalInterest;

  /// No description provided for @schedulePeriod.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ thứ {period}'**
  String schedulePeriod(int period);

  /// No description provided for @scheduleRateChangeWarning.
  ///
  /// In vi, this message translates to:
  /// **'Sau thời gian ưu đãi (kỳ {period}):'**
  String scheduleRateChangeWarning(int period);

  /// No description provided for @schedulePaymentChange.
  ///
  /// In vi, this message translates to:
  /// **'Khoản thanh toán {direction}{amount}/tháng'**
  String schedulePaymentChange(String direction, String amount);

  /// No description provided for @scheduleChangeRate.
  ///
  /// In vi, this message translates to:
  /// **'Đổi lãi suất'**
  String get scheduleChangeRate;

  /// No description provided for @scheduleExportFile.
  ///
  /// In vi, this message translates to:
  /// **'Xuất file'**
  String get scheduleExportFile;

  /// No description provided for @scheduleExportTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xuất lịch trả nợ'**
  String get scheduleExportTitle;

  /// No description provided for @scheduleChooseFormat.
  ///
  /// In vi, this message translates to:
  /// **'Chọn định dạng file'**
  String get scheduleChooseFormat;

  /// No description provided for @scheduleExportPDF.
  ///
  /// In vi, this message translates to:
  /// **'Xuất PDF'**
  String get scheduleExportPDF;

  /// No description provided for @scheduleExportPDFDesc.
  ///
  /// In vi, this message translates to:
  /// **'Định dạng đẹp, dễ chia sẻ và in ấn'**
  String get scheduleExportPDFDesc;

  /// No description provided for @scheduleExportCSV.
  ///
  /// In vi, this message translates to:
  /// **'Xuất CSV'**
  String get scheduleExportCSV;

  /// No description provided for @scheduleExportCSVDesc.
  ///
  /// In vi, this message translates to:
  /// **'Mở được bằng Excel, Google Sheets'**
  String get scheduleExportCSVDesc;

  /// No description provided for @scheduleFileReady.
  ///
  /// In vi, this message translates to:
  /// **'File {type} đã tạo xong'**
  String scheduleFileReady(String type);

  /// No description provided for @scheduleShareAction.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn làm gì với file này?'**
  String get scheduleShareAction;

  /// No description provided for @scheduleShareFile.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ {type} ngay'**
  String scheduleShareFile(String type);

  /// No description provided for @scheduleSaveFile.
  ///
  /// In vi, this message translates to:
  /// **'Lưu {type} vào máy'**
  String scheduleSaveFile(String type);

  /// No description provided for @scheduleShareError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi chia sẻ: {error}'**
  String scheduleShareError(String error);

  /// No description provided for @adLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được quảng cáo, vui lòng thử lại sau.'**
  String get adLoadFailed;

  /// No description provided for @adScheduleLockRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn {count} kỳ trả nợ nữa'**
  String adScheduleLockRemaining(int count);

  /// No description provided for @adScheduleLockHint.
  ///
  /// In vi, this message translates to:
  /// **'Xem quảng cáo ngắn để xem toàn bộ lịch trả nợ'**
  String get adScheduleLockHint;

  /// No description provided for @adScheduleLockButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem quảng cáo để xem tiếp'**
  String get adScheduleLockButton;

  /// No description provided for @adExportTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xem quảng cáo để xuất file {type}'**
  String adExportTitle(String type);

  /// No description provided for @adExportHint.
  ///
  /// In vi, this message translates to:
  /// **'Quảng cáo ngắn khoảng 15-30 giây, không watermark khi xuất xong.'**
  String get adExportHint;

  /// No description provided for @adExportButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem quảng cáo'**
  String get adExportButton;

  /// No description provided for @tableColPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ'**
  String get tableColPeriod;

  /// No description provided for @tableColTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng trả'**
  String get tableColTotal;

  /// No description provided for @tableColPrincipal.
  ///
  /// In vi, this message translates to:
  /// **'Gốc'**
  String get tableColPrincipal;

  /// No description provided for @tableColInterest.
  ///
  /// In vi, this message translates to:
  /// **'Lãi'**
  String get tableColInterest;

  /// No description provided for @tableColBalance.
  ///
  /// In vi, this message translates to:
  /// **'Dư nợ còn lại'**
  String get tableColBalance;

  /// No description provided for @consumerScheduleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kết Quả'**
  String get consumerScheduleTitle;

  /// No description provided for @consumerScheduleMonthly.
  ///
  /// In vi, this message translates to:
  /// **'Trả hàng tháng'**
  String get consumerScheduleMonthly;

  /// No description provided for @consumerScheduleTotalPayment.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thanh toán'**
  String get consumerScheduleTotalPayment;

  /// No description provided for @consumerScheduleTotalInterest.
  ///
  /// In vi, this message translates to:
  /// **'Tổng lãi phải trả'**
  String get consumerScheduleTotalInterest;

  /// No description provided for @consumerScheduleTerm.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ hạn vay'**
  String get consumerScheduleTerm;

  /// No description provided for @consumerScheduleFixed.
  ///
  /// In vi, this message translates to:
  /// **'Cố định mỗi kỳ'**
  String get consumerScheduleFixed;

  /// No description provided for @consumerScheduleIncludesPrincipal.
  ///
  /// In vi, this message translates to:
  /// **'Bao gồm gốc và lãi'**
  String get consumerScheduleIncludesPrincipal;

  /// No description provided for @consumerSchedulePercentOfTotal.
  ///
  /// In vi, this message translates to:
  /// **'Chiếm {percent}% gốc và lãi'**
  String consumerSchedulePercentOfTotal(String percent);

  /// No description provided for @consumerScheduleYears.
  ///
  /// In vi, this message translates to:
  /// **'Tương đương {years} năm'**
  String consumerScheduleYears(String years);

  /// No description provided for @rateCheckerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra lãi suất vay'**
  String get rateCheckerTitle;

  /// No description provided for @rateCheckerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Ước tính lãi suất vay hiện tại của khoản vay đang trả'**
  String get rateCheckerSubtitle;

  /// No description provided for @rateCheckerSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ước tính lãi suất hiện tại'**
  String get rateCheckerSectionTitle;

  /// No description provided for @rateCheckerHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập thông tin khoản vay đang trả để ước tính'**
  String get rateCheckerHint;

  /// No description provided for @rateCheckerOriginalAmount.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền vay gốc ban đầu'**
  String get rateCheckerOriginalAmount;

  /// No description provided for @rateCheckerStartDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày bắt đầu vay'**
  String get rateCheckerStartDate;

  /// No description provided for @rateCheckerTotalTerm.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thời gian vay'**
  String get rateCheckerTotalTerm;

  /// No description provided for @rateCheckerLastPayment.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền thanh toán kỳ gần nhất'**
  String get rateCheckerLastPayment;

  /// No description provided for @rateCheckerMethod.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức tính lãi'**
  String get rateCheckerMethod;

  /// No description provided for @rateCheckerMethodDeclining.
  ///
  /// In vi, this message translates to:
  /// **'Gốc giảm dần'**
  String get rateCheckerMethodDeclining;

  /// No description provided for @rateCheckerMethodEqual.
  ///
  /// In vi, this message translates to:
  /// **'Trả góp đều'**
  String get rateCheckerMethodEqual;

  /// No description provided for @rateCheckerMethodInterestOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ trả lãi'**
  String get rateCheckerMethodInterestOnly;

  /// No description provided for @rateCheckerButton.
  ///
  /// In vi, this message translates to:
  /// **'Ước tính lãi suất'**
  String get rateCheckerButton;

  /// No description provided for @rateCheckerValidation.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng kiểm tra lại thông tin đã nhập'**
  String get rateCheckerValidation;

  /// No description provided for @rateCheckerNoResult.
  ///
  /// In vi, this message translates to:
  /// **'Không thể ước tính với thông tin đã nhập. Vui lòng kiểm tra lại số tiền thanh toán hoặc phương thức tính lãi.'**
  String get rateCheckerNoResult;

  /// No description provided for @rateCheckerResultHeader.
  ///
  /// In vi, this message translates to:
  /// **'— Kết quả —'**
  String get rateCheckerResultHeader;

  /// No description provided for @rateCheckerResultTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất ước tính hiện tại'**
  String get rateCheckerResultTitle;

  /// No description provided for @rateCheckerResultNote.
  ///
  /// In vi, this message translates to:
  /// **'Dựa trên dư nợ còn lại và số tiền đang thanh toán mỗi kỳ'**
  String get rateCheckerResultNote;

  /// No description provided for @rateCheckerResultDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'* Đây là số liệu ước tính, không phải lãi suất chính thức từ ngân hàng.'**
  String get rateCheckerResultDisclaimer;

  /// No description provided for @rateCheckerInfoBox.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả là ước tính dựa trên số liệu bạn nhập, có thể chênh lệch nhẹ so với lãi suất chính thức ngân hàng áp dụng.'**
  String get rateCheckerInfoBox;

  /// No description provided for @fullPayoffTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tất Toán Toàn Phần'**
  String get fullPayoffTitle;

  /// No description provided for @fullPayoffSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tính chi phí khi trả hết khoản vay trước hạn'**
  String get fullPayoffSubtitle;

  /// No description provided for @fullPayoffSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin khoản vay'**
  String get fullPayoffSectionTitle;

  /// No description provided for @fullPayoffOriginalAmount.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền vay gốc ban đầu'**
  String get fullPayoffOriginalAmount;

  /// No description provided for @fullPayoffStartDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày bắt đầu vay'**
  String get fullPayoffStartDate;

  /// No description provided for @fullPayoffTotalTerm.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thời gian vay'**
  String get fullPayoffTotalTerm;

  /// No description provided for @fullPayoffMethod.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức tính lãi'**
  String get fullPayoffMethod;

  /// No description provided for @fullPayoffMethodDeclining.
  ///
  /// In vi, this message translates to:
  /// **'Gốc giảm dần'**
  String get fullPayoffMethodDeclining;

  /// No description provided for @fullPayoffMethodEqual.
  ///
  /// In vi, this message translates to:
  /// **'Trả góp đều'**
  String get fullPayoffMethodEqual;

  /// No description provided for @fullPayoffGracePeriod.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian ân hạn gốc ban đầu (nếu có)'**
  String get fullPayoffGracePeriod;

  /// No description provided for @fullPayoffFixedRate.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất cố định'**
  String get fullPayoffFixedRate;

  /// No description provided for @fullPayoffFixedPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian ưu đãi'**
  String get fullPayoffFixedPeriod;

  /// No description provided for @fullPayoffFloatingRate.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất thả nổi (sau ưu đãi)'**
  String get fullPayoffFloatingRate;

  /// No description provided for @fullPayoffTargetDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày dự kiến tất toán'**
  String get fullPayoffTargetDate;

  /// No description provided for @fullPayoffPenaltyRate.
  ///
  /// In vi, this message translates to:
  /// **'Phí phạt trả trước'**
  String get fullPayoffPenaltyRate;

  /// No description provided for @fullPayoffButton.
  ///
  /// In vi, this message translates to:
  /// **'Tính chi phí tất toán'**
  String get fullPayoffButton;

  /// No description provided for @fullPayoffValidation.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng kiểm tra lại thông tin đã nhập'**
  String get fullPayoffValidation;

  /// No description provided for @fullPayoffNoResult.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tính với thông tin đã nhập. Vui lòng kiểm tra lại ngày tất toán, thời gian vay và thời gian ân hạn.'**
  String get fullPayoffNoResult;

  /// No description provided for @fullPayoffResultHeader.
  ///
  /// In vi, this message translates to:
  /// **'— Kết quả —'**
  String get fullPayoffResultHeader;

  /// No description provided for @fullPayoffTotalNeeded.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số tiền cần chuẩn bị để tất toán'**
  String get fullPayoffTotalNeeded;

  /// No description provided for @fullPayoffRemainingBalance.
  ///
  /// In vi, this message translates to:
  /// **'Dư nợ gốc còn lại'**
  String get fullPayoffRemainingBalance;

  /// No description provided for @fullPayoffPenaltyFee.
  ///
  /// In vi, this message translates to:
  /// **'Phí phạt trả trước hạn'**
  String get fullPayoffPenaltyFee;

  /// No description provided for @fullPayoffInterestSaved.
  ///
  /// In vi, this message translates to:
  /// **'Lãi tiết kiệm được (so với trả hết theo lịch cũ)'**
  String get fullPayoffInterestSaved;

  /// No description provided for @fullPayoffEarlyMonths.
  ///
  /// In vi, this message translates to:
  /// **'Thoát nợ sớm hơn {months} tháng ({years} năm)'**
  String fullPayoffEarlyMonths(int months, String years);

  /// No description provided for @fullPayoffResultDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'* Số liệu ước tính, chưa bao gồm các phí khác (nếu có) theo quy định ngân hàng.'**
  String get fullPayoffResultDisclaimer;

  /// No description provided for @fullPayoffInfoBox.
  ///
  /// In vi, this message translates to:
  /// **'Phí phạt thực tế tùy theo hợp đồng và năm tất toán. Vui lòng kiểm tra với ngân hàng để có số liệu chính xác.'**
  String get fullPayoffInfoBox;

  /// No description provided for @partialTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tất Toán Từng Phần'**
  String get partialTitle;

  /// No description provided for @partialSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tính lại lịch trả nợ khi trả thêm một phần gốc'**
  String get partialSubtitle;

  /// No description provided for @partialSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin khoản vay'**
  String get partialSectionTitle;

  /// No description provided for @partialExtraDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày trả thêm'**
  String get partialExtraDate;

  /// No description provided for @partialPenaltyRate.
  ///
  /// In vi, this message translates to:
  /// **'Phí phạt trả trước'**
  String get partialPenaltyRate;

  /// No description provided for @partialExtraAmount.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền muốn trả thêm vào gốc'**
  String get partialExtraAmount;

  /// No description provided for @partialPriority.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn ưu tiên điều gì?'**
  String get partialPriority;

  /// No description provided for @partialPriorityGrace.
  ///
  /// In vi, this message translates to:
  /// **'Ân hạn gốc'**
  String get partialPriorityGrace;

  /// No description provided for @partialPriorityReducePayment.
  ///
  /// In vi, this message translates to:
  /// **'Giảm số tiền trả hàng tháng'**
  String get partialPriorityReducePayment;

  /// No description provided for @partialPriorityShortenTerm.
  ///
  /// In vi, this message translates to:
  /// **'Rút ngắn thời hạn vay'**
  String get partialPriorityShortenTerm;

  /// No description provided for @partialButton.
  ///
  /// In vi, this message translates to:
  /// **'Tính lại lịch trả nợ'**
  String get partialButton;

  /// No description provided for @partialValidation.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng kiểm tra lại thông tin đã nhập'**
  String get partialValidation;

  /// No description provided for @partialNoResult.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tính với thông tin đã nhập. Vui lòng kiểm tra lại số tiền trả thêm, thời gian ân hạn và ngày áp dụng.'**
  String get partialNoResult;

  /// No description provided for @partialResultHeader.
  ///
  /// In vi, this message translates to:
  /// **'— Kết quả —'**
  String get partialResultHeader;

  /// No description provided for @partialRemainingBalance.
  ///
  /// In vi, this message translates to:
  /// **'Dư nợ còn lại sau khi trả thêm'**
  String get partialRemainingBalance;

  /// No description provided for @partialPenaltyFee.
  ///
  /// In vi, this message translates to:
  /// **'Phí phạt trả trước hạn'**
  String get partialPenaltyFee;

  /// No description provided for @partialNewTerm.
  ///
  /// In vi, this message translates to:
  /// **'Thời hạn vay mới'**
  String get partialNewTerm;

  /// No description provided for @partialTermReduced.
  ///
  /// In vi, this message translates to:
  /// **'Giảm {months} tháng'**
  String partialTermReduced(int months);

  /// No description provided for @partialMonthlyPayment.
  ///
  /// In vi, this message translates to:
  /// **'Khoản trả hàng tháng'**
  String get partialMonthlyPayment;

  /// No description provided for @partialNoChange.
  ///
  /// In vi, this message translates to:
  /// **'Không đổi'**
  String get partialNoChange;

  /// No description provided for @partialGracePeriods.
  ///
  /// In vi, this message translates to:
  /// **'Số kỳ được ân hạn gốc'**
  String get partialGracePeriods;

  /// No description provided for @partialGraceNote.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ trả lãi trong giai đoạn này'**
  String get partialGraceNote;

  /// No description provided for @partialGracePayment.
  ///
  /// In vi, this message translates to:
  /// **'Khoản trả trong giai đoạn ân hạn'**
  String get partialGracePayment;

  /// No description provided for @partialTermLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời hạn vay'**
  String get partialTermLabel;

  /// No description provided for @partialInterestSaved.
  ///
  /// In vi, this message translates to:
  /// **'Lãi tiết kiệm được'**
  String get partialInterestSaved;

  /// No description provided for @partialResultDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'* Số liệu ước tính. Vui lòng tham khảo chuyên gia tài chính trước khi quyết định.'**
  String get partialResultDisclaimer;

  /// No description provided for @partialGraceInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ân hạn gốc là gì?'**
  String get partialGraceInfoTitle;

  /// No description provided for @partialGraceInfoBody.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền bạn trả thêm sẽ được dùng để giảm dư nợ ngay lập tức. Sau đó, LoanBuddy tự tính ra một số kỳ tiếp theo bạn được tạm ngưng trả gốc — trong khoảng thời gian này bạn chỉ cần trả lãi trên dư nợ đã giảm. Sau khi hết thời gian ân hạn, bạn quay lại trả gốc và lãi như bình thường, và khoản vay vẫn kết thúc đúng vào thời hạn ban đầu.'**
  String get partialGraceInfoBody;

  /// No description provided for @partialGraceInfoNote.
  ///
  /// In vi, this message translates to:
  /// **'Phù hợp khi bạn muốn giảm áp lực tài chính trong một giai đoạn ngắn sắp tới.'**
  String get partialGraceInfoNote;

  /// No description provided for @partialReduceInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giảm số tiền trả hàng tháng là gì?'**
  String get partialReduceInfoTitle;

  /// No description provided for @partialReduceInfoBody.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền bạn trả thêm sẽ giảm dư nợ gốc ngay lập tức. Thời hạn vay giữ nguyên không đổi. Vì dư nợ còn lại sẽ được chia đều cho thời gian còn lại, phần gốc phải trả mỗi tháng sẽ thấp hơn — dẫn đến số tiền trả hàng tháng giảm.'**
  String get partialReduceInfoBody;

  /// No description provided for @partialReduceInfoNote.
  ///
  /// In vi, this message translates to:
  /// **'Phù hợp khi bạn muốn giảm gánh nặng chi tiêu hàng tháng lâu dài.'**
  String get partialReduceInfoNote;

  /// No description provided for @partialShortenInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Rút ngắn thời hạn vay là gì?'**
  String get partialShortenInfoTitle;

  /// No description provided for @partialShortenInfoBody.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền bạn trả thêm sẽ giảm dư nợ gốc ngay lập tức. Khoản trả hàng tháng giữ nguyên không đổi, nhưng vì dư nợ thấp hơn, bạn sẽ trả hết khoản vay sớm hơn so với lịch ban đầu.'**
  String get partialShortenInfoBody;

  /// No description provided for @partialShortenInfoNote.
  ///
  /// In vi, this message translates to:
  /// **'Phù hợp khi bạn muốn tiết kiệm lãi nhiều nhất và thoát nợ sớm nhất.'**
  String get partialShortenInfoNote;

  /// No description provided for @earlySelectTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kịch Bản Tất Toán'**
  String get earlySelectTitle;

  /// No description provided for @earlySelectSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn loại kịch bản bạn muốn tính'**
  String get earlySelectSubtitle;

  /// No description provided for @earlySelectFullTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tất toán toàn phần'**
  String get earlySelectFullTitle;

  /// No description provided for @earlySelectFullDesc.
  ///
  /// In vi, this message translates to:
  /// **'Trả hết toàn bộ dư nợ để chấm dứt khoản vay tại một thời điểm'**
  String get earlySelectFullDesc;

  /// No description provided for @earlySelectPartialTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tất toán từng phần'**
  String get earlySelectPartialTitle;

  /// No description provided for @earlySelectPartialDesc.
  ///
  /// In vi, this message translates to:
  /// **'Trả thêm một khoản vào gốc, giảm dư nợ hoặc rút ngắn thời hạn'**
  String get earlySelectPartialDesc;

  /// No description provided for @earlySelectNote.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ áp dụng cho khoản vay thế chấp. Kết quả mang tính tham khảo.'**
  String get earlySelectNote;

  /// No description provided for @refinanceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phân Tích Chuyển Nợ'**
  String get refinanceTitle;

  /// No description provided for @refinanceSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'So sánh khoản vay hiện tại với khoản vay mới để quyết định có nên chuyển'**
  String get refinanceSubtitle;

  /// No description provided for @refinanceCurrentLoan.
  ///
  /// In vi, this message translates to:
  /// **'Khoản vay hiện tại'**
  String get refinanceCurrentLoan;

  /// No description provided for @refinanceCurrentLoanInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin từ ngân hàng đang vay'**
  String get refinanceCurrentLoanInfo;

  /// No description provided for @refinanceRemainingBalance.
  ///
  /// In vi, this message translates to:
  /// **'Dư nợ còn lại (VNĐ)'**
  String get refinanceRemainingBalance;

  /// No description provided for @refinanceRemainingTerm.
  ///
  /// In vi, this message translates to:
  /// **'Thời hạn còn lại'**
  String get refinanceRemainingTerm;

  /// No description provided for @refinanceCurrentRate.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất hiện tại'**
  String get refinanceCurrentRate;

  /// No description provided for @refinancePrepaymentFee.
  ///
  /// In vi, this message translates to:
  /// **'Phí trả nợ trước hạn'**
  String get refinancePrepaymentFee;

  /// No description provided for @refinancePaymentMethod.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức thanh toán'**
  String get refinancePaymentMethod;

  /// No description provided for @refinanceMethodDeclining.
  ///
  /// In vi, this message translates to:
  /// **'Gốc chia đều'**
  String get refinanceMethodDeclining;

  /// No description provided for @refinanceMethodEqual.
  ///
  /// In vi, this message translates to:
  /// **'Trả góp đều'**
  String get refinanceMethodEqual;

  /// No description provided for @refinanceNewLoan.
  ///
  /// In vi, this message translates to:
  /// **'Khoản vay mới dự kiến'**
  String get refinanceNewLoan;

  /// No description provided for @refinanceNewLoanInfo.
  ///
  /// In vi, this message translates to:
  /// **'Ngân hàng bạn muốn chuyển sang'**
  String get refinanceNewLoanInfo;

  /// No description provided for @refinanceNewAmount.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền vay mới'**
  String get refinanceNewAmount;

  /// No description provided for @refinanceNewTerm.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian vay mới'**
  String get refinanceNewTerm;

  /// No description provided for @refinanceFixedRate.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất cố định'**
  String get refinanceFixedRate;

  /// No description provided for @refinancePromoTerm.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian ưu đãi'**
  String get refinancePromoTerm;

  /// No description provided for @refinanceFloatingRate.
  ///
  /// In vi, this message translates to:
  /// **'Lãi suất thả nổi'**
  String get refinanceFloatingRate;

  /// No description provided for @refinanceProcessingFee.
  ///
  /// In vi, this message translates to:
  /// **'Chi phí làm hồ sơ'**
  String get refinanceProcessingFee;

  /// No description provided for @refinanceButton.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích chuyển nợ'**
  String get refinanceButton;

  /// No description provided for @refinanceValidation.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập đầy đủ thông tin bắt buộc ở cả 2 khoản vay (phải lớn hơn 0)'**
  String get refinanceValidation;

  /// No description provided for @refinanceResultHeader.
  ///
  /// In vi, this message translates to:
  /// **'— Kết quả —'**
  String get refinanceResultHeader;

  /// No description provided for @refinanceTotalCost.
  ///
  /// In vi, this message translates to:
  /// **'Tổng chi phí chuyển nợ'**
  String get refinanceTotalCost;

  /// No description provided for @refinanceBreakevenMonths.
  ///
  /// In vi, this message translates to:
  /// **'Số tháng hòa vốn'**
  String get refinanceBreakevenMonths;

  /// No description provided for @refinanceBreakevenValue.
  ///
  /// In vi, this message translates to:
  /// **'{months} tháng'**
  String refinanceBreakevenValue(int months);

  /// No description provided for @refinanceNoBreakeven.
  ///
  /// In vi, this message translates to:
  /// **'Không hòa vốn'**
  String get refinanceNoBreakeven;

  /// No description provided for @refinanceInterestSavedPromo.
  ///
  /// In vi, this message translates to:
  /// **'Lãi tiết kiệm trong thời gian ưu đãi'**
  String get refinanceInterestSavedPromo;

  /// No description provided for @refinanceInterestSavedTotal.
  ///
  /// In vi, this message translates to:
  /// **'Lãi tiết kiệm suốt thời gian vay'**
  String get refinanceInterestSavedTotal;

  /// No description provided for @refinanceInterestSavedMonthly.
  ///
  /// In vi, this message translates to:
  /// **'Lãi tiết kiệm trung bình mỗi tháng'**
  String get refinanceInterestSavedMonthly;

  /// No description provided for @refinanceNoResult.
  ///
  /// In vi, this message translates to:
  /// **'Không thể phân tích với thông tin đã nhập. Vui lòng kiểm tra lại các trường bắt buộc.'**
  String get refinanceNoResult;

  /// No description provided for @refinanceResultDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'* Lãi tiết kiệm suốt thời gian vay tính trên toàn bộ thời hạn vay mới. Số liệu ước tính.'**
  String get refinanceResultDisclaimer;

  /// No description provided for @feedbackTitle.
  ///
  /// In vi, this message translates to:
  /// **'Góp Ý'**
  String get feedbackTitle;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Ý kiến của bạn giúp LoanBuddy tốt hơn'**
  String get feedbackSubtitle;

  /// No description provided for @feedbackEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'Email (không bắt buộc)'**
  String get feedbackEmailHint;

  /// No description provided for @feedbackContentHint.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung góp ý...'**
  String get feedbackContentHint;

  /// No description provided for @feedbackButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get feedbackButton;

  /// No description provided for @feedbackFooter.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cũng có thể gửi email cho chúng tôi:\nadmin@loanbuddy.io.vn'**
  String get feedbackFooter;

  /// No description provided for @feedbackValidation.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập nội dung góp ý'**
  String get feedbackValidation;

  /// No description provided for @feedbackSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã góp ý!'**
  String get feedbackSuccess;

  /// No description provided for @feedbackNoEmail.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy ứng dụng email'**
  String get feedbackNoEmail;

  /// No description provided for @feedbackError.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra, vui lòng thử lại'**
  String get feedbackError;

  /// No description provided for @drawerSlogan.
  ///
  /// In vi, this message translates to:
  /// **'Vay thông minh, Tương lai vững vàng'**
  String get drawerSlogan;

  /// No description provided for @drawerHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get drawerHome;

  /// No description provided for @drawerHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử tra cứu'**
  String get drawerHistory;

  /// No description provided for @drawerSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get drawerSettings;

  /// No description provided for @drawerFeedback.
  ///
  /// In vi, this message translates to:
  /// **'Góp ý'**
  String get drawerFeedback;

  /// No description provided for @drawerPrivacyPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get drawerPrivacyPolicy;

  /// No description provided for @drawerTermsOfUse.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản sử dụng'**
  String get drawerTermsOfUse;

  /// No description provided for @unitMonths.
  ///
  /// In vi, this message translates to:
  /// **'tháng'**
  String get unitMonths;

  /// No description provided for @unitBillion.
  ///
  /// In vi, this message translates to:
  /// **'tỷ'**
  String get unitBillion;

  /// No description provided for @unitMillion.
  ///
  /// In vi, this message translates to:
  /// **'triệu'**
  String get unitMillion;

  /// No description provided for @partialInfoBox.
  ///
  /// In vi, this message translates to:
  /// **'Phí phạt thực tế tùy theo hợp đồng và năm trả thêm. Vui lòng kiểm tra với ngân hàng.'**
  String get partialInfoBox;

  /// No description provided for @partialPaymentReduced.
  ///
  /// In vi, this message translates to:
  /// **'Giảm {amount}/tháng'**
  String partialPaymentReduced(String amount);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
