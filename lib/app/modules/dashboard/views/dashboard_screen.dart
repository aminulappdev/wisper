import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/modules/calls/views/call_screen.dart';
import 'package:wisper/app/modules/chat/views/chat_screen.dart'; // ChatListScreen আসলে এই ফাইলে আছে ধরে নিচ্ছি
import 'package:wisper/app/modules/homepage/views/create_post_screen.dart';
import 'package:wisper/app/modules/homepage/views/home_screen.dart';
import 'package:wisper/app/modules/profile/controller/buisness/buisness_controller.dart';
import 'package:wisper/app/modules/profile/controller/person/profile_controller.dart';
import 'package:wisper/app/modules/profile/views/profile_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class MainButtonNavbarScreen extends StatefulWidget {
  const MainButtonNavbarScreen({super.key});

  @override
  State<MainButtonNavbarScreen> createState() => _MainButtonNavbarScreenState();
}

class _MainButtonNavbarScreenState extends State<MainButtonNavbarScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  final BusinessController businessController = Get.put(BusinessController());

  int selectedKey = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    CallScreen(),
    CreatePostScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // প্রোফাইল ডাটা লোড – PERSON নাকি BUSINESS তার উপর ভিত্তি করে
    if (StorageUtil.getData(StorageUtil.userRole) == 'PERSON') {
      profileController.getMyProfile();
    } else {
      businessController.getMyProfile();
    }
  }

  // প্রোফাইল ইমেজ URL বের করার হেল্পার
  String _getProfileImageUrl() {
    final role = StorageUtil.getData(StorageUtil.userRole);
    if (role == 'PERSON') {
      return profileController.profileData?.auth?.person?.image ?? '';
    } else {
      return businessController.buisnessData?.auth?.business?.image ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedKey],
      bottomNavigationBar: Container(
        height: 100.h,
        color: const Color(0xff121212),
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
            // Middle big button (Create Post)
            _buildNavItem(
              index: 2,
              height: 50.h,
              width: 50.h,
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
            _buildProfileNavItem(index: 4),
          ],
        ),
      ),
    );
  }

  // সাধারণ আইটেম
  Widget _buildNavItem({
    required int index,
    required String selectedIcon,
    required String unselectedIcon,
    required String label,
    double? height,
    double? width,
  }) {
    final bool isSelected = selectedKey == index;

    return GestureDetector(
      onTap: () => setState(() => selectedKey = index),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            heightBox8,
            CrashSafeImage(
              isSelected ? selectedIcon : unselectedIcon,
              height: height ?? 24.h,
              width: width ?? 24.h,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xffFFFFFF)
                    : const Color(0xff98A2B3),
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // প্রোফাইল আইটেম – PERSON / BUSINESS দুই রোলেই সঠিক ইমেজ দেখাবে
  Widget _buildProfileNavItem({required int index}) {
    final bool isSelected = selectedKey == index;
    final String imageUrl = _getProfileImageUrl();

    return GestureDetector(
      onTap: () => setState(() => selectedKey = index),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            heightBox8,
            CircleAvatar(
              radius: 14.r,
              backgroundColor: const Color(0xff2A2A2A),
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null, // null হলে child দেখাবে
              child: imageUrl.isEmpty
                  ? Icon(Icons.person, size: 18.r, color: Colors.white70)
                  : null,
            ),
            SizedBox(height: 4.h),
            Text(
              "Profile",
              style: TextStyle(
                color: isSelected
                    ? const Color(0xffFFFFFF)
                    : const Color(0xff98A2B3),
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
