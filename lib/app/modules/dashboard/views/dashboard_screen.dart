import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/modules/authentication/views/auth_screen.dart';
import 'package:wisper/app/modules/homepage/views/home_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class MainButtonNavbarScreen extends StatefulWidget {
  const MainButtonNavbarScreen({super.key});

  @override
  State<MainButtonNavbarScreen> createState() => _MainButtonNavbarScreenState();
}

class _MainButtonNavbarScreenState extends State<MainButtonNavbarScreen> {
  int selectedKey = 0;

  // List of screens for navigation
  List<Widget> screens = [
    const HomeScreen(),
    const AuthScreen(), // Replace with other screens as needed
    const AuthScreen(),
    const AuthScreen(),
    const AuthScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedKey],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(0.h),
        child: Container(
          height: 84.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color(0xff121212)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                selectedIcon: Assets.images.home.keyName,
                unselectedIcon: Assets.images.unselectedHome.keyName,
                label: "Home",
              ),
              _buildNavItem(
                index: 1,
                selectedIcon: Assets.images.selectedCall.keyName,
                unselectedIcon: Assets.images.call.keyName,
                label: "Call",
              ),
              _buildNavItem(
                index: 2,
                height: 44.h,
                width: 54.h,
                selectedIcon: Assets.images.frame5313.keyName,
                unselectedIcon: Assets.images.frame5313.keyName,
                label: "",
              ),
              _buildNavItem(
                index: 3,
                selectedIcon: Assets.images.unselectedChat.keyName,
                unselectedIcon: Assets.images.selectedChat.keyName,
                label: "Chat",
              ),
              _buildNavItem(
                index: 4,
                selectedIcon: Assets.images.container2.keyName,
                unselectedIcon: Assets.images.container2.keyName,
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String selectedIcon,
    required String unselectedIcon,
    required String label,
    double? height,
    double? width,
  }) {
    bool isSelected = selectedKey == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedKey = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          heightBox8,
          CrashSafeImage(
            isSelected ? selectedIcon : unselectedIcon,
            height: height ?? 24.h,
            width: width ?? 24.h,
          ),

          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xffFFFFFF) : Color(0xff98A2B3),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
