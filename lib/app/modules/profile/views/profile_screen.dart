// lib/app/modules/profile/views/profile_screen.dart

// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';          // ← new
import 'package:geolocator/geolocator.dart';        // ← new
import 'package:share_plus/share_plus.dart';
import 'package:wisper/app/core/others/get_storage.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/core/utils/image_picker.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/common/custom_button.dart';
import 'package:wisper/app/core/widgets/common/custom_popup.dart';
import 'package:wisper/app/core/widgets/common/line_widget.dart';
import 'package:wisper/app/modules/chat/widgets/location_info.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/app/modules/homepage/views/my_resume_section.dart';
import 'package:wisper/app/modules/job/views/my_job_section.dart';
import 'package:wisper/app/modules/post/controller/feed_post_controller.dart';
import 'package:wisper/app/modules/post/controller/my_post_controller.dart';
import 'package:wisper/app/modules/post/views/my_post_section.dart';
import 'package:wisper/app/modules/profile/controller/buisness/buisness_controller.dart';
import 'package:wisper/app/modules/profile/controller/person/profile_controller.dart';
import 'package:wisper/app/modules/profile/controller/recommendetion_controller.dart';
import 'package:wisper/app/modules/profile/controller/upload_photo_controller.dart';
import 'package:wisper/app/modules/profile/views/business/edit_business_profile_screen.dart';
import 'package:wisper/app/modules/profile/views/person/edit_person_profile_screen.dart';
import 'package:wisper/app/modules/profile/views/recommendation_screen.dart';
import 'package:wisper/app/modules/profile/widget/info_card.dart';
import 'package:wisper/app/modules/profile/widget/recommendation_widget.dart';
import 'package:wisper/app/modules/settings/views/settings_screen.dart';
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
  
  // New: location display (city, country)
  final RxString currentCityCountry = 'Fetching location...'.obs;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    userRole = StorageUtil.getData(StorageUtil.userRole) ?? 'PERSON';
    _updateProfileImage();
    _getProfileImage();
    
    print('User id in ProfileScreen: ${StorageUtil.getData(StorageUtil.userId)}');

    // Fetch current location once
    _fetchCurrentCityAndCountry();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userRole == 'PERSON'
          ? recommendationController.getAllRecommendations(
              StorageUtil.getData(StorageUtil.userId),
            )
          : null;
    });
  }

  Future<void> _fetchCurrentCityAndCountry() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        currentCityCountry.value = 'Location services disabled';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentCityCountry.value = 'Location permission denied';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        currentCityCountry.value = 'Location permission permanently denied';
        return;
      }

      // Get position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      // Reverse geocoding → get city & country
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.locality ?? place.subAdministrativeArea ?? 'Unknown city';
        String country = place.country ?? 'Unknown country';

        currentCityCountry.value = '$city, $country';
      } else {
        currentCityCountry.value = 'Location not available';
      }
    } catch (e) {
      print('Location error: $e');
      currentCityCountry.value = 'Could not get location';
    }
  }

  Future<void> _getProfileImage() async {
    print('Called get image');
    await personController.getMyProfile();
    await businessController.getMyProfile();
    if (userRole == 'PERSON') {
      print(
        'Person image: ${personController.profileData?.auth?.person?.image}',
      );
      currentImagePath.value =
          personController.profileData?.auth?.person?.image ?? '';
    } else if (userRole == 'BUSINESS') {
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
        final AllFeedPostController feedController = Get.put(
          AllFeedPostController(),
        );
        final MyFeedPostController myFeedPostController = Get.put(
          MyFeedPostController(),
        );

        myFeedPostController.resetPagination();
        feedController.resetPagination();
        await myFeedPostController.getAllPost();
        await feedController.getAllPost();
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

  void _showCreateGroup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return RcommendationButtomSheet(
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

      // final String? displayAddress = userRole == 'PERSON'   ← removed
      //     ? personData?.address
      //     : businessData?.address;

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
                        onPress: () async {
                          try {
                            final String userId =
                                StorageUtil.getData(StorageUtil.userId) ?? '';
                            if (userId.isEmpty) {
                              Get.snackbar('Error', 'User ID not found');
                              return;
                            }

                            final String role =
                                StorageUtil.getData(StorageUtil.userRole) ??
                                'PERSON';
                            final bool isPerson =
                                role.toUpperCase() == 'PERSON';

                            const String baseUrl =
                                'https://c9f1d48ba47f.ngrok-free.app';

                            final Uri shareUri = Uri.https(
                              baseUrl.replaceAll('https://', ''),
                              isPerson
                                  ? '/persons/$userId'
                                  : '/businesses/$userId',
                            );

                            debugPrint("Sharing profile link: $shareUri");

                            await Share.shareUri(shareUri);
                          } catch (e) {
                            debugPrint('Share error: $e');
                            Get.snackbar('Error', 'Failed to share profile');
                          }
                        },
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
                          () => StorageUtil.getData(StorageUtil.userRole) ==
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

              // Fixed Recommendation Widget
              userRole == 'PERSON'
                  ? SizedBox(
                      height: 30.h,
                      child: GetBuilder<AllRecommendationController>(
                        builder: (controller) {
                          final int count =
                              controller.recommendationData.length;
                          return Recommendation(
                            images: controller.recommendationData
                                .map((e) => e.giver!)
                                .toList(),
                            isEmpty: count == 0,
                            onTap: _showCreateGroup,
                            count: count,
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink(),

              SizedBox(height: 10.h),

              // Now using current location instead of profile address
              Obx(
                () => LocationInfo(
                  location: currentCityCountry.value,
                  date: dateFormatter.getShortDateFormat(),
                ),
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
                      if (idx < tabs.length - 1) SizedBox(width: 100.w),
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