import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/others/custom_size.dart';
import 'package:wisper/app/core/widgets/common/circle_icon.dart';

class CallFeature extends StatelessWidget {
  final String? imagePath;
  final String? title;
  final VoidCallback? onTap;
  final Color? color;
  final double? radius;
  const CallFeature({
    super.key,
    this.imagePath,
    this.title,
    this.onTap,
    this.color,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleIconWidget(
          radius: radius ?? 28,
          iconRadius: 20,
          color: color ?? Colors.white.withValues(alpha: 0.20),
          imagePath: imagePath!,
          onTap: onTap!,
        ),
        heightBox8,
        title != null
            ? Text(
                title!,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              )
            : Container(),
      ],
    );
  }
}
