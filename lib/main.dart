import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:wisper/app/core/config/theme/my_theme.dart';
import 'package:wisper/app/core/config/translations/localization_service.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/modules/onboarding/views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  // try {
  //   await dotenv.load(fileName: ".env");
  // } catch (e) {
  //   debugPrint("⚠️ Could not load .env file: $e");
  // }

  await StorageUtil.init(); // ✅ এখন থেকে সব data GetStorage এ save হবে

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
              home: SplashScreen(),
              locale: StorageUtil.getLocale(),
              translations: LocalizationService.getInstance(),
            ),
          );
        },
      ),
    );
  });
}


// InputDecorationTheme _inputDecorationTheme() {
//   return InputDecorationTheme(
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     hintStyle: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 14),
//     fillColor: Color(0xffF3F3F5),
//     filled: true,
//     border: _inputBorder(),
//     enabledBorder: _inputBorder(),
//     focusedBorder: _inputBorder(),
//     errorBorder: _inputBorder(),
//   );
// }

// OutlineInputBorder _inputBorder() {
//   return OutlineInputBorder(
//     borderSide: BorderSide.none,
//     borderRadius: BorderRadius.circular(50.r),
//   );
// }
