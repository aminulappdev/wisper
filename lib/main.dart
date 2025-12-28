import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/app_binder.dart';
import 'package:wisper/app/core/config/theme/my_theme.dart';
import 'package:wisper/app/core/config/translations/localization_service.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/socket/socket_service.dart';
import 'package:wisper/app/modules/dashboard/views/dashboard_screen.dart';
import 'package:wisper/app/modules/onboarding/views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SocketService socketService = Get.put(SocketService());
  await socketService.init();
  await StorageUtil.init();

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
        rebuildFactor: (old, data) => true,
        builder: (context, widget) {
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
                  ).copyWith(textScaler: TextScaler.linear(1.0)),
                  child: widget!,
                );
              },
              home: StorageUtil.getData(StorageUtil.userAccessToken) != null
                  ? const MainButtonNavbarScreen()
                  : const SplashScreen(),
              locale: StorageUtil.getLocale(),
              translations: LocalizationService.getInstance(),

              // 🔥 এখানে নতুন যোগ করা অংশ 🔥
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
