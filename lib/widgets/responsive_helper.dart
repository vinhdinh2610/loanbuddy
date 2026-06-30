import 'package:flutter/material.dart';

/// Ngưỡng chiều rộng để phân biệt điện thoại vs tablet/iPad.
/// Dưới 600px = điện thoại, từ 600px trở lên = tablet.
const double kTabletBreakpoint = 600;

/// Kiểm tra màn hình hiện tại có phải tablet không.
bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width >= kTabletBreakpoint;

/// Bọc nội dung form để giới hạn chiều rộng tối đa trên màn hình lớn,
/// tránh input/text bị giãn quá rộng mất cân đối trên tablet/iPad.
/// Trên điện thoại (dưới breakpoint), nội dung chiếm full width như cũ.
class ResponsiveFormWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveFormWidth({
    super.key,
    required this.child,
    this.maxWidth = 480,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
