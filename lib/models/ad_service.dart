import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Quản lý quảng cáo AdMob cho LoanBuddy.
///
/// Đợt 1: dùng TEST Ad Unit ID của Google cho tất cả vị trí quảng cáo vì
/// chưa có tài khoản AdMob production. Khi có tài khoản thật, chỉ cần thay
/// 2 hằng số bên dưới bằng Ad Unit ID thật.
class AdService {
  AdService._();

  static const String testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testRewardedAndroid =
      'ca-app-pub-3940256099942544/5224354917';

  /// google_mobile_ads chỉ hỗ trợ Android/iOS, không hỗ trợ Web.
  /// Đợt này mới cấu hình cho Android nên chỉ bật quảng cáo trên Android;
  /// các nền tảng khác tự động bỏ qua để không phá vỡ luồng test/dev.
  static bool get isSupported => !kIsWeb && Platform.isAndroid;

  static Future<void> initialize() async {
    if (!isSupported) return;
    await MobileAds.instance.initialize();
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
      adUnitId: testRewardedAndroid,
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
