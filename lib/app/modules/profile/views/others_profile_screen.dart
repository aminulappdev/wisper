import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_popup.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/chat/views/doc_info.dart';
import 'package:wisper/app/modules/chat/widgets/location_info.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/app/modules/homepage/views/post_section.dart';
import 'package:wisper/app/modules/profile/views/edit_profile_screen.dart';
import 'package:wisper/app/modules/profile/views/recommendation_screen.dart';
import 'package:wisper/app/modules/profile/views/settings_screen.dart';
import 'package:wisper/app/modules/profile/widget/info_card.dart';
import 'package:wisper/app/modules/profile/widget/recommendation_widget.dart';
import 'package:wisper/gen/assets.gen.dart';

class OthersProfileScreen extends StatefulWidget {
  const OthersProfileScreen({super.key});

  @override
  State<OthersProfileScreen> createState() => _OthersProfileScreenState();
}

class _OthersProfileScreenState extends State<OthersProfileScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final GlobalKey suffixButtonKey = GlobalKey();
    final customPopupMenu = CustomPopupMenu(
      targetKey: suffixButtonKey,
      options: [
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
      optionActions: {
        '0': () {
          Get.to(() => const SettingsScreen());
        },
      },
      menuWidth: 200,
      menuHeight: 30,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            InfoCard(
              trailingKey: suffixButtonKey, // Pass the GlobalKey
              trailingOnTap: () {
                customPopupMenu.showMenuAtPosition(context);
              },
              imagePath: Assets.images.person.keyName,
              editOnTap: () {},
              title: 'Md Aminul Islam',
              memberInfo: 'Software engineer',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleIconWidget(
                    imagePath: Assets.images.call.keyName,
                    onTap: () {},
                    radius: 15,
                    color: LightThemeColors.blueColor,
                    iconColor: Colors.white,
                  ),
                  SizedBox(width: 10.w),
                  CircleIconWidget(
                    imagePath: Assets.images.unselectedChat.keyName,
                    onTap: () {},
                    radius: 15,
                    color: LightThemeColors.blueColor,
                    iconColor: Colors.white,
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    height: 31.h,
                    width: 116.w,
                    child: CustomElevatedButton(
                      color: LightThemeColors.blueColor,
                      textSize: 12,
                      title: 'Edit Profile',
                      onPress: () {
                        Get.to(() => const EditProfileScreen());
                      },
                      borderRadius: 50,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Recommendation(
              onTap: () {
                _showCreateGroup();
              },
              count: 3,
            ),
            SizedBox(height: 10.h),
            const LocationInfo(),
            SizedBox(height: 20.h),
            const StraightLiner(height: 0.4, color: Color(0xff454545)),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: SelectOptionWidget(
                    currentIndex: 0,
                    selectedIndex: selectedIndex,
                    title: 'Post',
                    lineColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(width: 100.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: SelectOptionWidget(
                    currentIndex: 1,
                    selectedIndex: selectedIndex,
                    title: 'Resume',
                    lineColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
            const StraightLiner(height: 0.4, color: Color(0xff454545)),
            SizedBox(height: 10.h),
            if (selectedIndex == 0) PostSection(),
            if (selectedIndex == 1)
              DocInfo(
                title: 'job_description.pdf',
                isDownloaded: true,
                onTap: () {},
              ),
          ],
        ),
      ),
    );
  }

  void _showCreateGroup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const RcommendationButtomSheet();
      },
    );
  }
}
