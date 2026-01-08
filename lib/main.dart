// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:wisper/app/core/app_binder.dart';
// import 'package:wisper/app/core/config/theme/my_theme.dart';
// import 'package:wisper/app/core/config/translations/localization_service.dart';
// import 'package:wisper/app/core/get_storage.dart';
// import 'package:wisper/app/core/services/socket/socket_service.dart';
// import 'package:wisper/app/modules/dashboard/views/dashboard_screen.dart';
// import 'package:wisper/app/modules/onboarding/views/splash_screen.dart';
// import 'package:wisper/firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final SocketService socketService = Get.put(SocketService());
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await socketService.init();
//   await StorageUtil.init();
//   await _initFCMToken();

//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]).then((_) {
//     runApp(
//       ScreenUtilInit(
//         designSize: const Size(375, 812),
//         minTextAdapt: true,
//         splitScreenMode: true,
//         useInheritedMediaQuery: true,
//         rebuildFactor: (old, data) => true,
//         builder: (context, widget) {
//           return GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () {
//               FocusManager.instance.primaryFocus?.unfocus();
//             },
//             child: GetMaterialApp(
//               initialBinding: ControllerBinder(),
//               debugShowCheckedModeBanner: false,
//               theme: MyTheme.getThemeData(isLight: true),
//               darkTheme: MyTheme.getThemeData(isLight: false),
//               themeMode: StorageUtil.isLightTheme()
//                   ? ThemeMode.light
//                   : ThemeMode.dark,
//               builder: (context, widget) {
//                 return MediaQuery(
//                   data: MediaQuery.of(
//                     context,
//                   ).copyWith(textScaler: TextScaler.linear(1.0)),
//                   child: widget!,
//                 );
//               },
//               home: StorageUtil.getData(StorageUtil.userAccessToken) != null
//                   ? const MainButtonNavbarScreen()
//                   : const SplashScreen(),
//               locale: StorageUtil.getLocale(),
//               translations: LocalizationService.getInstance(),

//               // 🔥 এখানে নতুন যোগ করা অংশ 🔥
//               defaultTransition: GetPlatform.isAndroid
//                   ? Transition.rightToLeft
//                   : Transition.cupertino,
//             ),
//           );
//         },
//       ),
//     );
//   });
// }

// Future<void> _initFCMToken() async {
//   debugPrint("📡 Starting FCM token initialization...");

//   if (Platform.isIOS) {
//     // Request notification permissions for iOS
//     final permission = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     debugPrint(
//       "📝 iOS Notification Permission: ${permission.authorizationStatus}",
//     );

//     // Try to get APNs token with retries
//     String? apnsToken;
//     for (int i = 0; i < 3; i++) {
//       apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//       debugPrint("📡 Attempt ${i + 1} - APNs token: $apnsToken");
//       if (apnsToken != null) break;
//       await Future.delayed(const Duration(seconds: 2)); // Wait before retry
//     }

//     if (apnsToken == null) {
//       debugPrint("⚠️ Failed to get APNs token after retries");
//       FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//         debugPrint("📱 iOS FCM Token (via refresh): $newToken");
//       });
//       return;
//     }
//   }

//   // Get FCM token for iOS (if APNs token exists) or Android
//   final fcmToken = await FirebaseMessaging.instance.getToken();
//   debugPrint("📱 FCM Token: $fcmToken");

//   // Listen for token refresh
//   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//     debugPrint("🔄 FCM Token Refreshed: $newToken");
//   });
// }

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/app_binder.dart';
import 'package:wisper/app/core/config/theme/my_theme.dart';
import 'package:wisper/app/core/config/translations/localization_service.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/deeplink_services.dart';
import 'package:wisper/app/core/services/socket/socket_service.dart';
import 'package:wisper/app/modules/dashboard/views/dashboard_screen.dart'; // তোমার MainButtonNavbarScreen
import 'package:wisper/app/modules/onboarding/views/splash_screen.dart';
import 'package:wisper/app/modules/profile/views/others_person_screen.dart';
import 'package:wisper/app/modules/profile/views/profile_screen.dart';
import 'package:wisper/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Socket & Firebase init
  final SocketService socketService = Get.put(SocketService());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await socketService.init();
  await StorageUtil.init();
  await _initFCMToken();

  // 🔥 DeepLinkService কে GetX-এ inject করা
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
          // 🔥 App চালু হওয়ার পর DeepLink init করা (context ready হলে)
          WidgetsBinding.instance.addPostFrameCallback((_) {
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
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: widget!,
                );
              },

              // 🔥 Initial route GetX দিয়ে decide করা
              initialRoute:
                  StorageUtil.getData(StorageUtil.userAccessToken) != null
                  ? '/dashboard'
                  : '/',

              // 🔥 সব Named Routes এখানে define করা
              getPages: [
                GetPage(name: '/', page: () => const SplashScreen()),
                GetPage(
                  name: '/dashboard',
                  page: () => const MainButtonNavbarScreen(),
                ),

                // 🔥 Deep Link এর জন্য Dynamic Route
                GetPage(
                  name: '/running/:id',
                  page: () {
                    final id = Get.parameters['id'];
                    // এখানে তোমার RunDetailPage return করো
                    // return RunDetailPage(runId: id!);
                    return OthersPersonScreen(userId: id ?? '');
                  },
                ),

                // তোমার প্রজেক্টের অন্যান্য routes এখানে যোগ করো
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
    // Request notification permissions for iOS
    final permission = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint(
      "📝 iOS Notification Permission: ${permission.authorizationStatus}",
    );

    // Try to get APNs token with retries
    String? apnsToken;
    for (int i = 0; i < 3; i++) {
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      debugPrint("📡 Attempt ${i + 1} - APNs token: $apnsToken");
      if (apnsToken != null) break;
      await Future.delayed(const Duration(seconds: 2));
    }

    if (apnsToken == null) {
      debugPrint("⚠️ Failed to get APNs token after retries");
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint("📱 iOS FCM Token (via refresh): $newToken");
      });
      return;
    }
  }

  // Get FCM token
  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint("📱 FCM Token: $fcmToken");

  // Listen for token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint("🔄 FCM Token Refreshed: $newToken");
  });
}
