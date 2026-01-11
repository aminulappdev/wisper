
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/gen/assets.gen.dart';

class SettingsFeatureRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const SettingsFeatureRow({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),

          CrashSafeImage(
            Assets.images.arrowForwoard.keyName,
            height: 12.h,
            width: 12.w,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
