// lib/app/modules/profile/views/profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/core/utils/image_picker.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_popup.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/chat/views/doc_info.dart';
import 'package:wisper/app/modules/chat/widgets/location_info.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/app/modules/homepage/views/my_job_section.dart';
import 'package:wisper/app/modules/homepage/views/my_post_section.dart';
import 'package:wisper/app/modules/profile/controller/buisness/buisness_controller.dart';
import 'package:wisper/app/modules/profile/controller/person/profile_controller.dart';
import 'package:wisper/app/modules/profile/controller/upload_photo_controller.dart';
import 'package:wisper/app/modules/profile/views/business/edit_business_profile_screen.dart';
import 'package:wisper/app/modules/profile/views/person/edit_person_profile_screen.dart';
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

  // কন্ট্রোলার
  final ProfileController personController = Get.find<ProfileController>();
  final BusinessController businessController = Get.put(BusinessController());
  final ProfilePhotoController photoController = Get.put(
    ProfilePhotoController(),
  );

  // কারেন্ট ইউজারের রোল ও ইমেজ পাথ
  late final String userRole;
  final RxString currentImagePath = ''.obs;

  @override
  void initState() {
    super.initState();
    userRole = StorageUtil.getData(StorageUtil.userRole) ?? 'PERSON';
    _updateProfileImage();
  }

  // প্রোফাইল ইমেজ আপডেট করার হেল্পার
  void _updateProfileImage() {
    String? imageUrl;
    if (userRole == 'PERSON') {
      imageUrl = personController.profileData?.auth?.person?.image;
    } else {
      imageUrl = businessController.buisnessData?.auth?.business?.image;
    }

    currentImagePath.value = imageUrl?.isNotEmpty == true
        ? imageUrl!
        : (userRole == 'PERSON'
              ? Assets.images.person.keyName
              : Assets.images.person.keyName); // BUSINESS এর জন্য ডিফল্ট ইমেজ
  }

  // ইমেজ পিক করার পর আপলোড + রিফ্রেশ
  void _onImagePicked(File imageFile) async {
    currentImagePath.value = imageFile.path; // লোকাল ইমেজ দেখানোর জন্য

    final bool success = await photoController.uploadProfilePhoto(imageFile);

    if (success) {
      // API থেকে লেটেস্ট ডাটা রিফ্রেশ
      if (userRole == 'PERSON') {
        await personController.getMyProfile();
      } else {
        await businessController.getMyProfile();
      }

      await Future.delayed(const Duration(milliseconds: 800));
      _updateProfileImage(); // UI আপডেট
      showSnackBarMessage(context, 'Profile photo updated!', false);
    } else {
      showSnackBarMessage(context, 'Failed to upload image', true);
      _updateProfileImage(); // পুরানো ইমেজে ফিরে যাও
    }
  }

  void _showCreateGroup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const RcommendationButtomSheet(),
    );
  }

  // ট্যাব কন্টেন্ট – রোল অনুযায়ী
  Widget _getTabContent(int index) {
    if (userRole == 'PERSON') {
      if (index == 0) return const MyPostSection();
      if (index == 1) {
        return DocInfo(title: 'Resume.pdf', isDownloaded: true, onTap: () {});
      }
    } else {
      // BUSINESS
      if (index == 0) return  MyPostSection();
      if (index == 1) return  MyJobSection();
      if (index == 2) {
        return DocInfo(
          title: 'Company Brochure.pdf',
          isDownloaded: true,
          onTap: () {},
        );
      }
    }
    return const SizedBox.shrink();
  }

  void _onTabTapped(int index) => setState(() => selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final GlobalKey suffixButtonKey = GlobalKey();

    return Obx(() {
      // লেটেস্ট প্রোফাইল ডাটা
      final personData = userRole == 'PERSON'
          ? personController.profileData?.auth?.person
          : null;
      final businessData = userRole != 'PERSON'
          ? businessController.buisnessData?.auth?.business
          : null;

      final String displayName = userRole == 'PERSON'
          ? (personData?.name ?? 'User')
          : (businessData?.name ?? 'Company');

      final String displayTitle = userRole == 'PERSON'
          ? (personData?.title ?? '')
          : (businessData?.industry ?? '');

      final String? displayAddress = userRole == 'PERSON'
          ? personData?.address
          : businessData?.address;

      final DateTime? createdAt = userRole == 'PERSON'
          ? personController.profileData?.auth?.createdAt
          : businessController.buisnessData?.auth?.createdAt;

      final DateFormatter dateFormatter = createdAt != null
          ? DateFormatter(createdAt)
          : DateFormatter(DateTime.now());

      // ট্যাব লিস্ট – রোল অনুযায়ী
      final List<Map<String, String>> tabs = userRole == 'PERSON'
          ? [
              {'index': '0', 'title': 'Post'},
              {'index': '1', 'title': 'Resume'},
            ]
          : [
              {'index': '0', 'title': 'Post'},
              {'index': '1', 'title': 'Job'},
              {'index': '2', 'title': 'Resume'},
            ];

      return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),

              // Profile Info Card
              InfoCard(
                trailingKey: suffixButtonKey,
                trailingOnTap: () => CustomPopupMenu(
                  targetKey: suffixButtonKey,
                  options: [
                    Text(
                      'Settings',
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  ],
                  optionActions: {
                    '0': () => Get.to(() => const SettingsScreen()),
                  },
                  menuWidth: 200,
                  menuHeight: 40,
                ).showMenuAtPosition(context),
                imagePath: currentImagePath.value,
                editOnTap: () => ImagePickerHelper().showAlertDialog(
                  context,
                  _onImagePicked,
                ),
                title: displayName,
                memberInfo: displayTitle,
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
                        onPress: () => Get.to(
                          () =>
                              StorageUtil.getData(StorageUtil.userRole) ==
                                  'PERSON'
                              ? EditPersonProfileScreen()
                              : EditBusinessProfileScreen(),
                        ),
                        borderRadius: 50,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),
              Recommendation(onTap: _showCreateGroup, count: 3),
              SizedBox(height: 10.h),

              LocationInfo(
                location: displayAddress ?? 'Location not set',
                date: dateFormatter.getFullDateFormat(),
              ),

              SizedBox(height: 20.h),
              const StraightLiner(height: 0.4, color: Color(0xff454545)),
              SizedBox(height: 10.h),

              // Dynamic Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: tabs.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var tab = entry.value;
                  int tabIndex = int.parse(tab['index']!);
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => _onTabTapped(tabIndex),
                        child: SelectOptionWidget(
                          currentIndex: tabIndex,
                          selectedIndex: selectedIndex,
                          title: tab['title']!,
                          lineColor: Colors.white,
                        ),
                      ),
                      if (idx < tabs.length - 1) SizedBox(width: 30.w),
                    ],
                  );
                }).toList(),
              ),

              const StraightLiner(height: 0.4, color: Color(0xff454545)),
              SizedBox(height: 10.h),

              // Tab Content
              Expanded(child: _getTabContent(selectedIndex)),
            ],
          ),
        ),
      );
    });
  }
}
