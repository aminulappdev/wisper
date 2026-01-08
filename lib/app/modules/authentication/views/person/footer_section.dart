

import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/gen/assets.gen.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sign Up With",
              style: TextStyle(color: const Color(0xff8C8C8C), fontSize: 16.sp),
            ),
            heightBox10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CrashSafeImage(Assets.images.gmail.keyName, height: 30.h),
                // widthBox14,
                // CrashSafeImage(Assets.images.facebook.keyName, height: 30.h),
              ],
            ),
          ],
        ),
        heightBox16,
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'By signing up, I agree to the Wispa  ',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xffAEAEAE),
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Terms and Conditions',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 14.sp,
                  color: Color(0xffAEAEAE),
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: ' and ',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xffAEAEAE),
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 14.sp,
                  color: Color(0xffAEAEAE),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
