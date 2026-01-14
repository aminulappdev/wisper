// SplashScreen.dart - Updated version with correct internet check
// বাকি সব অপরিবর্তিত রাখা হয়েছে (deep link, token check, delay, build method ইত্যাদি)

import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/others/get_storage.dart';
import 'package:wisper/app/core/services/others/deeplink_services.dart';
import 'package:wisper/app/core/utils/connectivity_services.dart'; // ConnectivityService import
import 'package:wisper/app/core/utils/no_inter_screen.dart'; // NoInternetScreen import (path adjust করো যদি দরকার)
import 'package:wisper/gen/assets.gen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    // স্প্ল্যাশ স্ক্রিনে কিছু সময় দেখানোর জন্য
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500));

    // Internet check করা
    final connectivityService = Get.find<ConnectivityService>();

    // Connectivity check (v6+ version – List<ConnectivityResult> আসে)
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();

    // কোনো নেটওয়ার্ক আছে কি না চেক
    final bool hasNetwork = !results.isEmpty && !results.contains(ConnectivityResult.none);

    bool isActuallyOnline = false;

    if (hasNetwork) {
      // Real internet access চেক (captive portal / no data ধরার জন্য)
      isActuallyOnline = await connectivityService.checkInternetAccess();
    }

    // RxBool update
    connectivityService.isOnline.value = isActuallyOnline;

    if (!isActuallyOnline) {
      // No internet → No Internet Screen-এ যাও
      Get.offAll(() => const NoInternetScreen());
      return;
    }

    // Internet আছে → normal flow (token check)
    final String? token = StorageUtil.getData(StorageUtil.userAccessToken);

    print('Local Token in Splash: $token');

    if (token != null && token.isNotEmpty) {
      // টোকেন থাকলে ড্যাশবোর্ডে যাও
      Get.offAllNamed('/dashboard');

      // Pending deep link process করো
      final deepLinkService = Get.find<DeepLinkService>();
      deepLinkService.processPendingDeepLink();
    } else {
      // টোকেন না থাকলে onboarding-এ যাও
      Get.offAllNamed('/onboarding');
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