// lib/app/modules/profile/views/profile_screen.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/utils/image_picker.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_popup.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/chat/views/doc_info.dart';
import 'package:wisper/app/modules/chat/widgets/location_info.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/app/modules/homepage/views/my_post_section.dart';
import 'package:wisper/app/modules/profile/controller/profile_controller.dart';
import 'package:wisper/app/modules/profile/controller/upload_photo_controller.dart';
import 'package:wisper/app/modules/profile/views/edit_profile_screen.dart';
import 'package:wisper/app/modules/profile/views/recommendation_screen.dart';
import 'package:wisper/app/modules/profile/views/settings_screen.dart';
import 'package:wisper/app/modules/profile/widget/info_card.dart';
import 'package:wisper/app/modules/profile/widget/recommendation_widget.dart';
import 'package:wisper/gen/assets.gen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;

  final ProfileController profileController = Get.find<ProfileController>();
  final ProfilePhotoController photoController = Get.put(
    ProfilePhotoController(),
  );
  final RxString currentImagePath = ''.obs;

  @override
  void initState() {
    super.initState();
    final apiImage = profileController.profileData?.auth?.person?.image ?? '';
    if (apiImage.isNotEmpty) {
      currentImagePath.value = apiImage;
    } else {
      currentImagePath.value = Assets.images.person.keyName;
    }
  }

  void _onImagePicked(File imageFile) async {
    currentImagePath.value = imageFile.path;
    final bool success = await photoController.uploadProfilePhoto(imageFile);

    if (success) {
      final ProfileController profileController = Get.find<ProfileController>();
      await profileController.getMyProfile();
      await Future.delayed(const Duration(milliseconds: 800));
      final latestImageUrl = profileController.profileData?.auth?.person?.image;

      if (latestImageUrl != null && latestImageUrl.isNotEmpty) {
        currentImagePath.value = latestImageUrl;
      }
    } else {
      showSnackBarMessage(context, 'Image upload failed', true);
      final oldImage = profileController.profileData?.auth?.person?.image;
      currentImagePath.value = oldImage?.isNotEmpty == true
          ? oldImage!
          : Assets.images.person.keyName;
    }
  }

  void _showCreateGroup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const RcommendationButtomSheet(),
    );
  }

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
      optionActions: {'0': () => Get.to(() => const SettingsScreen())},
      menuWidth: 200,
      menuHeight: 30,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 30.h),

            Obx(
              () => InfoCard(
                trailingKey: suffixButtonKey,
                trailingOnTap: () {
                  customPopupMenu.showMenuAtPosition(context);
                },
                imagePath: currentImagePath.value,
                editOnTap: () {
                  ImagePickerHelper().showAlertDialog(context, _onImagePicked);
                },
                title: profileController.profileData?.auth?.person?.name ?? '',
                memberInfo:
                    profileController.profileData?.auth?.person?.title ?? '',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 31.h,
                      width: 116.w,
                      child: CustomElevatedButton(
                        textSize: 12,
                        title: 'Share Profile',
                        onPress: () {},
                        borderRadius: 50,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SizedBox(
                      height: 31.h,
                      width: 116.w,
                      child: CustomElevatedButton(
                        color: Colors.black,
                        textSize: 12,
                        title: 'Edit Profile',
                        onPress: () => Get.to(() => const EditProfileScreen()),
                        borderRadius: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10.h),
            Recommendation(onTap: _showCreateGroup, count: 3),
            SizedBox(height: 10.h),
            const LocationInfo(),
            SizedBox(height: 20.h),
            const StraightLiner(height: 0.4, color: Color(0xff454545)),
            SizedBox(height: 10.h),

            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => selectedIndex = 0),
                  child: SelectOptionWidget(
                    currentIndex: 0,
                    selectedIndex: selectedIndex,
                    title: 'Post',
                    lineColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(width: 100.w),
                GestureDetector(
                  onTap: () => setState(() => selectedIndex = 1),
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

            // Content
            if (selectedIndex == 0)
              MyPostSection(
                
              ),

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
}
