import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_popup.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/core/widgets/shimmer/info_card_shimmer.dart';
import 'package:wisper/app/modules/chat/controller/create_chat_controller.dart';
import 'package:wisper/app/modules/chat/views/person/message_screen.dart';
import 'package:wisper/app/modules/chat/widgets/location_info.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/app/modules/homepage/views/my_resume_section.dart';
import 'package:wisper/app/modules/homepage/views/others_post_section.dart';
import 'package:wisper/app/modules/profile/controller/person/others_profile_controller.dart';
import 'package:wisper/app/modules/profile/controller/recommendetion_controller.dart';
import 'package:wisper/app/modules/profile/model/recommendation_model.dart';
import 'package:wisper/app/modules/profile/views/person/edit_person_profile_screen.dart';
import 'package:wisper/app/modules/profile/views/recommendation_screen.dart';
import 'package:wisper/app/modules/profile/widget/info_card.dart';
import 'package:wisper/app/modules/profile/widget/recommendation_widget.dart';
import 'package:wisper/gen/assets.gen.dart';

class OthersPersonScreen extends StatefulWidget {
  final String userId;
  const OthersPersonScreen({super.key, required this.userId});

  @override
  State<OthersPersonScreen> createState() => _OthersPersonScreenState();
}

class _OthersPersonScreenState extends State<OthersPersonScreen> {
  final OtherPersonController controller = Get.put(OtherPersonController());
  final CreateChatController createChatController = Get.put(
    CreateChatController(),
  );
  final AllRecommendationController recommendationController = Get.put(
    AllRecommendationController(),
  );

  int selectedIndex = 0;

  @override
  void initState() {
    controller.getOthersProfile(widget.userId);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      recommendationController.getAllRecommendations(widget.userId);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    recommendationController.dispose();
    super.dispose();
  }

  void createChat(String? memberId, String? memberName, String? memberImage) {
    showLoadingOverLay(
      asyncFunction: () async =>
          await performCreateChat(context, memberId, memberName, memberImage),
      msg: 'Please wait...',
    );
  }

  Future<void> performCreateChat(
    BuildContext context,
    String? memberId,
    String? memberName,
    String? memberImage,
  ) async {
    final bool isSuccess = await createChatController.createChat(
      memberId: widget.userId,
    );

    if (isSuccess) {
      var chatId = createChatController.chatId;
      Get.to(
        ChatScreen(
          chatId: chatId,
          receiverId: memberId ?? '',
          receiverImage: memberImage ?? '',
          receiverName: memberName ?? '',
        ),
      );
    } else {
      showSnackBarMessage(context, createChatController.errorMessage, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Obx(() {
              if (controller.inProgress) {
                return InfoCardShimmerEffectWidget();
              }
              {
                return InfoCard(
                  isEditImage: false,
                  isTrailing: false,
                  imagePath: controller.profileData?.auth?.person?.image ?? '',
                  editOnTap: () {},
                  title: controller.profileData?.auth?.person?.name ?? '',
                  memberInfo: controller.profileData?.auth?.person?.title ?? '',
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
                        onTap: () {
                          print('call');
                          createChat(
                            controller.profileData?.auth?.person?.id ?? '',
                            controller.profileData?.auth?.person?.name ?? '',
                            controller.profileData?.auth?.person?.image ?? '',
                          );
                        },
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
                          title: 'Block',
                          onPress: () {
                            Get.to(() => const EditPersonProfileScreen());
                          },
                          borderRadius: 50,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
            SizedBox(height: 10.h),
            Obx(() {
              if (recommendationController.inProgress) {
                return SizedBox(height: 30, child: const Center());
              } else if (recommendationController.recommendationData!.isEmpty) {
                return Recommendation(
                  onTap: () {
                    _showCreateGroup(
                      recommendationController.recommendationData ?? [],
                    );
                  },
                  count: 0,
                );
              } else {
                return Recommendation(
                  onTap: () {
                    _showCreateGroup(
                      recommendationController.recommendationData!,
                    );
                  },
                  count:
                      recommendationController.recommendationData?.length ?? 0,
                );
              }
            }),
            SizedBox(height: 10.h),
            Obx(() {
              if (controller.inProgress) {
                return const Center();
              } else {
                return LocationInfo(
                  isDate: false,
                  location:
                      controller.profileData?.auth?.person?.address ??
                      'Unknown Address',
                );
              }
            }),
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
            if (selectedIndex == 0) OthersPostSection(userId: widget.userId),
            if (selectedIndex == 1) MyResumeSection(userId: widget.userId),
          ],
        ),
      ),
    );
  }

  void _showCreateGroup(List<RecommendationItemModel> model) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return RcommendationButtomSheet(
          recommendationItemModel: model,
          isCreateReview: true,
          recieverId: widget.userId,
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
// import 'package:wisper/app/core/utils/show_over_loading.dart';
// import 'package:wisper/app/core/utils/snack_bar.dart';
// import 'package:wisper/app/core/widgets/circle_icon.dart';
// import 'package:wisper/app/core/widgets/custom_button.dart';
// import 'package:wisper/app/core/widgets/custom_popup.dart';
// import 'package:wisper/app/core/widgets/line_widget.dart';
// import 'package:wisper/app/modules/chat/controller/create_chat_controller.dart';
// import 'package:wisper/app/modules/chat/views/person/message_screen.dart';
// import 'package:wisper/app/modules/chat/widgets/location_info.dart';
// import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
// import 'package:wisper/app/modules/homepage/views/my_resume_section.dart';
// import 'package:wisper/app/modules/homepage/views/others_post_section.dart';
// import 'package:wisper/app/modules/profile/controller/person/others_profile_controller.dart';
// import 'package:wisper/app/modules/profile/controller/recommendetion_controller.dart';
// import 'package:wisper/app/modules/profile/model/recommendation_model.dart';
// import 'package:wisper/app/modules/profile/views/person/edit_person_profile_screen.dart';
// import 'package:wisper/app/modules/profile/views/recommendation_screen.dart';
// import 'package:wisper/app/modules/profile/views/settings_screen.dart';
// import 'package:wisper/app/modules/profile/widget/info_card.dart';
// import 'package:wisper/app/modules/profile/widget/recommendation_widget.dart';
// import 'package:wisper/gen/assets.gen.dart';

// class OthersPersonScreen extends StatefulWidget {
//   final String userId;
//   const OthersPersonScreen({super.key, required this.userId});

//   @override
//   State<OthersPersonScreen> createState() => _OthersPersonScreenState();
// }

// class _OthersPersonScreenState extends State<OthersPersonScreen> {
//   final OtherPersonController controller = Get.put(OtherPersonController());
//   final AllRecommendationController recommendationController = Get.put(
//     AllRecommendationController(),
//   );
//   final CreateChatController createChatController = Get.put(
//     CreateChatController(),
//   );

//   int selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.getOthersProfile(widget.userId);
//       recommendationController.getAllRecommendations(widget.userId);
//     });
//   }

//   void createChat(String? memberId, String? memberName, String? memberImage) {
//     showLoadingOverLay(
//       asyncFunction: () async =>
//           await performCreateChat(context, memberId, memberName, memberImage),
//       msg: 'Please wait...',
//     );
//   }

//   Future<void> performCreateChat(
//     BuildContext context,
//     String? memberId,
//     String? memberName,
//     String? memberImage,
//   ) async {
//     final bool isSuccess = await createChatController.createChat(
//       memberId: memberId,
//     );

//     if (isSuccess) {
//       var chatId = createChatController.chatId;
//       Get.to(
//         ChatScreen(
//           chatId: chatId,
//           receiverId: memberId ?? '',
//           receiverImage: memberImage ?? '',
//           receiverName: memberName ?? '',
//         ),
//       );
//     } else {
//       showSnackBarMessage(context, createChatController.errorMessage, true);
//     }
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     recommendationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey suffixButtonKey = GlobalKey();
//     final customPopupMenu = CustomPopupMenu(
//       targetKey: suffixButtonKey,
//       options: [
//         Text(
//           'Settings',
//           style: TextStyle(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w400,
//             color: Colors.white,
//           ),
//         ),
//       ],
//       optionActions: {
//         '0': () {
//           Get.to(() => const SettingsScreen());
//         },
//       },
//       menuWidth: 200,
//       menuHeight: 30,
//     );
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           children: [
//             SizedBox(height: 30.h),
//             Obx(() {
//               if (controller.inProgress) {
//                 return SizedBox(
//                   height: 200,
//                   child: const Center(
//                     child: CircularProgressIndicator(strokeAlign: 1),
//                   ),
//                 );
//               }
//               {
//                 var image = controller.profileData!.auth!.person?.image ?? '';
//                 return InfoCard(
//                   isTrailing: false,
//                   isEditImage: false,
//                   trailingKey: suffixButtonKey, // Pass the GlobalKey
//                   trailingOnTap: () {},
//                   imagePath: image,
//                   editOnTap: () {},
//                   title: controller.profileData?.auth?.person?.name ?? '',
//                   memberInfo: controller.profileData?.auth?.person?.title ?? '',
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircleIconWidget(
//                         imagePath: Assets.images.call.keyName,
//                         onTap: () {},
//                         radius: 15,
//                         color: LightThemeColors.blueColor,
//                         iconColor: Colors.white,
//                       ),
//                       SizedBox(width: 10.w),
//                       CircleIconWidget(
//                         imagePath: Assets.images.unselectedChat.keyName,
//                         onTap: () {
//                           createChat(
//                             controller.profileData?.auth?.person?.id,
//                             controller.profileData?.auth?.person?.name,
//                             controller.profileData?.auth?.person?.image,
//                           );
//                         },
//                         radius: 15,
//                         color: LightThemeColors.blueColor,
//                         iconColor: Colors.white,
//                       ),
//                       SizedBox(width: 10.w),
//                       SizedBox(
//                         height: 31.h,
//                         width: 116.w,
//                         child: CustomElevatedButton(
//                           color: LightThemeColors.blueColor,
//                           textSize: 12,
//                           title: 'Block',
//                           onPress: () {
//                             Get.to(() => const EditPersonProfileScreen());
//                           },
//                           borderRadius: 50,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             }),
//             SizedBox(height: 10.h),
//             Obx(() {
//               if (recommendationController.inProgress) {
//                 return SizedBox(height: 30, child: const Center());
//               } else if (recommendationController.recommendationData!.isEmpty) {
//                 return Recommendation(
//                   onTap: () {
//                     _showCreateGroup(
//                       recommendationController.recommendationData ?? [],
//                     );
//                   },
//                   count: 0,
//                 );
//               } else {
//                 return Recommendation(
//                   onTap: () {
//                     _showCreateGroup(
//                       recommendationController.recommendationData!,
//                     );
//                   },
//                   count:
//                       recommendationController.recommendationData?.length ?? 0,
//                 );
//               }
//             }),
//             SizedBox(height: 10.h),
//             LocationInfo(
//               isDate: false,
//               location:
//                   controller.profileData!.auth!.person?.address ??
//                   'Unknown Address',
//             ),
//             SizedBox(height: 20.h),
//             const StraightLiner(height: 0.4, color: Color(0xff454545)),
//             SizedBox(height: 10.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedIndex = 0;
//                     });
//                   },
//                   child: SelectOptionWidget(
//                     currentIndex: 0,
//                     selectedIndex: selectedIndex,
//                     title: 'Post',
//                     lineColor: const Color.fromARGB(255, 255, 255, 255),
//                   ),
//                 ),
//                 SizedBox(width: 100.w),
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedIndex = 1;
//                     });
//                   },
//                   child: SelectOptionWidget(
//                     currentIndex: 1,
//                     selectedIndex: selectedIndex,
//                     title: 'Resume',
//                     lineColor: const Color.fromARGB(255, 255, 255, 255),
//                   ),
//                 ),
//               ],
//             ),
//             const StraightLiner(height: 0.4, color: Color(0xff454545)),
//             SizedBox(height: 10.h),
//             if (selectedIndex == 0) OthersPostSection(userId: widget.userId),
//             if (selectedIndex == 1) MyResumeSection(userId: widget.userId),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCreateGroup(List<RecommendationItemModel> model) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return RcommendationButtomSheet(
//           recommendationItemModel: model,
//           isCreateReview: true,
//           recieverId: widget.userId,
//         );
//       },
//     );
//   }
// }
