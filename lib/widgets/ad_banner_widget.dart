import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/ad_service.dart';

/// Banner ad dạng Anchored Adaptive (tự tính chiều cao tối ưu theo chiều
/// rộng thiết bị, eCPM cao hơn banner kích thước cố định 320x50).
/// Tự ẩn (SizedBox.shrink) nếu nền tảng không hỗ trợ AdMob hoặc quảng cáo
/// chưa tải xong, để không để lại khoảng trống.
///
/// Adaptive banner được tính theo bề rộng toàn màn hình (MediaQuery), nên có
/// thể rộng hơn phần nội dung đang có padding ngang xung quanh nó — dùng
/// [OverflowBox] để banner hiển thị full-bề-rộng (tràn lề) mà không gây lỗi
/// tràn layout, trong khi chiều cao vẫn được đặt chỗ bình thường.
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_requested && AdService.isSupported) {
      _requested = true;
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    final width = MediaQuery.of(context).size.width.truncate();
    final size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (size == null || !mounted) return;

    _bannerAd = BannerAd(
      adUnitId: AdService.testBannerAndroid,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdService.isSupported || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }
    final width = _bannerAd!.size.width.toDouble();
    final height = _bannerAd!.size.height.toDouble();
    return SizedBox(
      height: height,
      child: OverflowBox(
        minWidth: width,
        maxWidth: width,
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
