// SplashScreen.dart - Updated version
// এখানে deep link handling যোগ করা হয়েছে

import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/others/get_storage.dart';
import 'package:wisper/app/core/services/others/deeplink_services.dart';
import 'package:wisper/gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    // স্প্ল্যাশ স্ক্রিনে কিছু সময় দেখানোর জন্য
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500));

    final String? token = StorageUtil.getData(StorageUtil.userAccessToken);

    print('Local Token in Splash: $token');

    if (token != null && token.isNotEmpty) {
      // টোকেন থাকলে ড্যাশবোর্ডে যাও
      Get.offAllNamed('/dashboard');

      // এখন pending deep link থাকলে প্রসেস করো
      final deepLinkService = Get.find<DeepLinkService>();
      deepLinkService.processPendingDeepLink();
    } else {
      // টোকেন না থাকলে অনবোর্ডিং/লগইন এ যাও
      Get.offAllNamed('/onboarding'); // বা তোমার লগইন রুট
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightThemeColors.blueColor,
      body: Center(
        child: CrashSafeImage(
          Assets.images.appLogo.keyName,
          height: 84.h,
          width: 84.h,
        ),
      ),
    );
  }
}