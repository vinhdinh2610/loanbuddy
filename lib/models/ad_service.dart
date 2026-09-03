import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

/// Quản lý quảng cáo AdMob cho LoanBuddy.
///
/// Android dùng Ad Unit ID PRODUCTION thật (đã có tài khoản AdMob).
/// iOS vẫn dùng TEST Ad Unit ID của Google cho đến khi có ID thật riêng cho iOS.
class AdService {
  AdService._();

  static const String _bannerAndroid =
      'ca-app-pub-2115132623917146/5713108590';
  static const String _rewardedAndroid =
      'ca-app-pub-2115132623917146/7900288236';
  static const String _testBannerIOS =
      'ca-app-pub-3940256099942544/2934735716';
  static const String _testRewardedIOS =
      'ca-app-pub-3940256099942544/1712485313';

  /// Ad Unit ID banner đúng theo nền tảng hiện tại.
  static String get bannerAdUnitId =>
      Platform.isIOS ? _testBannerIOS : _bannerAndroid;

  /// Ad Unit ID rewarded ad đúng theo nền tảng hiện tại.
  static String get rewardedAdUnitId =>
      Platform.isIOS ? _testRewardedIOS : _rewardedAndroid;

  /// google_mobile_ads hỗ trợ Android/iOS, không hỗ trợ Web.
  static bool get isSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static Future<void> initialize() async {
    if (!isSupported) return;
    await MobileAds.instance.initialize();
  }

  /// Xin quyền App Tracking Transparency (chỉ áp dụng cho iOS, Android không
  /// có khái niệm này nên bỏ qua). Theo khuyến nghị của Apple, không gọi lúc
  /// mới mở app lần đầu mà gọi sau khi user đã hiểu ngữ cảnh (vd sau khi hoàn
  /// tất Onboarding).
  static Future<void> requestTrackingAuthorization() async {
    if (kIsWeb || !Platform.isIOS) return;
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  /// Tải và hiện rewarded ad. Gọi [onRewarded] khi user xem xong và nhận
  /// reward; gọi [onFailed] nếu tải/hiện quảng cáo thất bại.
  /// Trên nền tảng không hỗ trợ AdMob (vd Web), tự coi như đã xem xong
  /// để không chặn luồng test/dev trên Chrome.
  static void showRewarded({
    required BuildContext context,
    required VoidCallback onRewarded,
    VoidCallback? onFailed,
  }) {
    if (!isSupported) {
      onRewarded();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          Navigator.of(context, rootNavigator: true).pop();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) => ad.dispose(),
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              onFailed?.call();
            },
          );
          ad.show(onUserEarnedReward: (ad, reward) => onRewarded());
        },
        onAdFailedToLoad: (error) {
          Navigator.of(context, rootNavigator: true).pop();
          onFailed?.call();
        },
      ),
    );
  }
}
