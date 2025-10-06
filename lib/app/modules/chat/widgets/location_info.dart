
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/gen/assets.gen.dart';

class LocationInfo extends StatelessWidget {
  const LocationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            CrashSafeImage(
              Assets.images.location.keyName,
              height: 16.h,
              color: const Color(0xff7F8694),
            ),
            widthBox4,
            Text(
              'Building 1, Nigeria',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff7F8694),
              ),
            ),
          ],
        ),
        widthBox10,
        Row(
          children: [
            CrashSafeImage(
              Assets.images.calendar.keyName,
              height: 16.h,
              color: const Color(0xff7F8694),
            ),
            widthBox4,
            Text(
              'Created August 2025',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff7F8694),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
