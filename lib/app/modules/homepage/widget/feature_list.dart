import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart' show widthBox4, heightBox10;

class FeatureList extends StatelessWidget {
  final String? title;
  final String? iconPath;
  const FeatureList({super.key, this.title, this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CrashSafeImage(iconPath!, height: 16.h, width: 16),
        widthBox4,
        Text(
          title!,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff8C8C8C),
          ),
        ),
        heightBox10,
      ],
    );
  }
}