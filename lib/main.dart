import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/others/app_binder.dart';
import 'package:wisper/app/core/config/theme/my_theme.dart';
import 'package:wisper/app/core/config/translations/localization_service.dart';
import 'package:wisper/app/core/others/get_storage.dart';
import 'package:wisper/app/core/services/others/deeplink_services.dart';
import 'package:wisper/app/core/services/socket/socket_service.dart';
import 'package:wisper/app/core/utils/connectivity_services.dart';
import 'package:wisper/app/core/utils/no_inter_screen.dart';
import 'package:wisper/app/modules/dashboard/views/dashboard_screen.dart';
import 'package:wisper/app/modules/onboarding/views/onboarding_view.dart';
import 'package:wisper/app/modules/onboarding/views/splash_screen.dart';
import 'package:wisper/app/modules/profile/views/business/others_business_screen.dart';
import 'package:wisper/app/modules/profile/views/person/others_person_screen.dart';
import 'package:wisper/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Core initializations
  final SocketService socketService = Get.put(SocketService());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await socketService.init();
  await StorageUtil.init();
  await _initFCMToken();

  // New: Initialize ConnectivityService (runs in background, shows dialog when needed)
  Get.put(ConnectivityService());

  // DeepLink service
  Get.put(DeepLinkService());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, widget) {
          // Deep links initialize
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await Future.delayed(const Duration(milliseconds: 100));
            Get.find<DeepLinkService>().initDeepLinks();
          });

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: GetMaterialApp(
              initialBinding: ControllerBinder(),
              debugShowCheckedModeBanner: false,
              theme: MyTheme.getThemeData(isLight: true),
              darkTheme: MyTheme.getThemeData(isLight: false),
              themeMode: StorageUtil.isLightTheme()
                  ? ThemeMode.light
                  : ThemeMode.dark,
              builder: (context, widget) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  child: widget!,
                );
              },

              initialRoute: '/',
              getPages: [
                GetPage(name: '/', page: () => const SplashScreen()),
                GetPage(
                  name: '/dashboard',
                  page: () => const MainButtonNavbarScreen(),
                ),
                GetPage(
                  name: '/onboarding',
                  page: () => const OnboardingView(),
                ),
                GetPage(
                  name: '/profile/person/:id',
                  page: () => OthersPersonScreen(
                    userId: Get.parameters['id'] ?? '',
                  ),
                ),
                GetPage(
                  name: '/profile/business/:id',
                  page: () => OthersBusinessScreen(
                    userId: Get.parameters['id'] ?? '',
                  ),
                ),
                // নতুন route যোগ করা হলো (No Internet Screen-এর জন্য)
                GetPage(
                  name: '/no-internet',
                  page: () => const NoInternetScreen(),
                ),
              ],

              locale: StorageUtil.getLocale(),
              translations: LocalizationService.getInstance(),
              defaultTransition: GetPlatform.isAndroid
                  ? Transition.rightToLeft
                  : Transition.cupertino,
            ),
          );
        },
      ),
    );
  });
}

Future<void> _initFCMToken() async {
  debugPrint("📡 Starting FCM token initialization...");

  if (Platform.isIOS) {
    final permission = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint("iOS Notification Permission: ${permission.authorizationStatus}");

    String? apnsToken;
    for (int i = 0; i < 3; i++) {
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      debugPrint("Attempt ${i + 1} - APNs token: $apnsToken");
      if (apnsToken != null) break;
      await Future.delayed(const Duration(seconds: 2));
    }

    if (apnsToken == null) {
      debugPrint("⚠️ Failed to get APNs token after retries");
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint("iOS FCM Token (via refresh): $newToken");
      });
      return;
    }
  }

  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint("FCM Token: $fcmToken");

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint("FCM Token Refreshed: $newToken");
  });
}