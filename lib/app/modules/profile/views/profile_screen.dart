// lib/app/modules/profile/views/profile_screen.dart

// ignore_for_file: use_build_context_synchronously, avoid_print

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
import 'package:wisper/app/modules/chat/widgets/location_info.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/app/modules/homepage/views/my_job_section.dart';
import 'package:wisper/app/modules/homepage/views/my_post_section.dart';
import 'package:wisper/app/modules/homepage/views/my_resume_section.dart';
import 'package:wisper/app/modules/profile/controller/buisness/buisness_controller.dart';
import 'package:wisper/app/modules/profile/controller/person/profile_controller.dart';
import 'package:wisper/app/modules/profile/controller/recommendetion_controller.dart';
import 'package:wisper/app/modules/profile/controller/upload_photo_controller.dart';
import 'package:wisper/app/modules/profile/model/recommendation_model.dart';
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

  final ProfileController personController = Get.put(ProfileController());
  final BusinessController businessController = Get.put(BusinessController());
  final ProfilePhotoController photoController =
      Get.find<ProfilePhotoController>();

  final AllRecommendationController recommendationController = Get.put(
    AllRecommendationController(),
  );

  late final String userRole;
  final RxString currentImagePath = ''.obs;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    userRole = StorageUtil.getData(StorageUtil.userRole) ?? 'PERSON';
    _updateProfileImage();
    _getProfileImage();
    print(
      'User id in ProfileScreen: ${StorageUtil.getData(StorageUtil.userId)}',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userRole == 'PERSON'
          ? recommendationController.getAllRecommendations(
              StorageUtil.getData(StorageUtil.userId),
            )
          : null;
    });
  }

  Future<void> _getProfileImage() async {
    print('Called get image');
    await personController.getMyProfile();
    if (userRole == 'PERSON') {
      print(
        'Person image: ${personController.profileData?.auth?.person?.image}',
      );
      currentImagePath.value =
          personController.profileData?.auth?.person?.image ?? '';
    } else {
      print(
        'Business image: ${businessController.buisnessData?.auth?.business?.image}',
      );
      currentImagePath.value =
          businessController.buisnessData?.auth?.business?.image ?? '';
    }
  }

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
              : Assets.images.person.keyName);
  }

  void _onImagePicked(File imageFile) async {
    currentImagePath.value = imageFile.path;

    final bool success = await photoController.uploadProfilePhoto(imageFile);

    if (success) {
      if (userRole == 'PERSON') {
        await personController.getMyProfile();
      } else {
        await businessController.getMyProfile();
      }

      await Future.delayed(const Duration(milliseconds: 800));
      _updateProfileImage();
      showSnackBarMessage(context, 'Profile photo updated!', false);
    } else {
      showSnackBarMessage(context, 'Failed to upload image', true);
      _updateProfileImage();
    }
  }

  void _showCreateGroup(List<RecommendationItemModel> model) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return RcommendationButtomSheet(
          recommendationItemModel: model,
          isCreateReview: false,
          recieverId: StorageUtil.getData(StorageUtil.userId),
        );
      },
    );
  }

  Widget _getTabContent(int index) {
    if (userRole == 'PERSON') {
      if (index == 0) return const MyPostSection();
      if (index == 1) {
        return MyResumeSection(
          userId: StorageUtil.getData(StorageUtil.userAuthId)!,
        );
      }
    } else {
      // BUSINESS
      if (index == 0) return MyPostSection();
      if (index == 1) return MyJobSection();
      if (index == 2) {
        return MyResumeSection(
          userId: StorageUtil.getData(StorageUtil.userAuthId)!,
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

      final List<Map<String, String>> tabs = userRole == 'PERSON'
          ? [
              {'index': '0', 'title': 'Post'},
              {'index': '1', 'title': 'Resume'},
            ]
          : [
              {'index': '0', 'title': 'Post'},
              {'index': '1', 'title': 'Job'},
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

              // Fixed Recommendation Widget - Safe null handling
              userRole == 'PERSON'
                  ? SizedBox(
                      height: 30.h,
                      child: Obx(() {
                        // Safely get the list, default to empty if null
                        final List<RecommendationItemModel> recList =
                            recommendationController.recommendationData ?? [];

                        if (recommendationController.inProgress) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Recommendation(
                          onTap: () {
                            _showCreateGroup(recList);
                          },
                          count: recList.length,
                        );
                      }),
                    )
                  : const SizedBox.shrink(),

              SizedBox(height: 10.h),

              LocationInfo(
                location: displayAddress ?? 'Location not set',
                date: dateFormatter.getShortDateFormat(),
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
                          title: tab['title'] ?? '',
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
