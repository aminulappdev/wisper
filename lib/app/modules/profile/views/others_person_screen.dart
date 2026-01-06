import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/date_formatter.dart' show DateFormatter;
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/core/widgets/shimmer/info_card_shimmer.dart';
import 'package:wisper/app/modules/chat/controller/all_connection_controller.dart';
import 'package:wisper/app/modules/chat/controller/create_chat_controller.dart';
import 'package:wisper/app/modules/chat/views/person/message_screen.dart';
import 'package:wisper/app/modules/chat/widgets/location_info.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/app/modules/homepage/controller/add_request_controller.dart';
import 'package:wisper/app/modules/homepage/views/my_resume_section.dart';
import 'package:wisper/app/modules/homepage/views/others_post_section.dart';
import 'package:wisper/app/modules/profile/controller/person/others_profile_controller.dart';
import 'package:wisper/app/modules/profile/controller/recommendetion_controller.dart';
import 'package:wisper/app/modules/profile/controller/remove_connection_controller.dart';
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
  final AllConnectionController connectionController = Get.put(
    AllConnectionController(),
  );
  final RemoveConnectionController removeConnectionController = Get.put(
    RemoveConnectionController(),
  );
  final AllRecommendationController recommendationController = Get.put(
    AllRecommendationController(),
  );
  final AddRequestController addRequestController = Get.put(
    AddRequestController(),
  );

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // প্রোফাইল এবং রেকমেন্ডেশন লোড করো
    controller.getOthersProfile(widget.userId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      recommendationController.getAllRecommendations(widget.userId);
    });
  }

  @override
  void dispose() {
    // Get.put করা controller গুলো dispose করো (যদি একাধিকবার put না করতে চাও)
    Get.delete<OtherPersonController>();
    Get.delete<CreateChatController>();
    Get.delete<AllConnectionController>();
    Get.delete<RemoveConnectionController>();
    Get.delete<AllRecommendationController>();
    Get.delete<AddRequestController>();
    super.dispose();
  }

  // চ্যাট তৈরি করা
  void createChat(String? memberId, String? memberName, String? memberImage) {
    showLoadingOverLay(
      asyncFunction: () async =>
          await performCreateChat(memberId, memberName, memberImage),
      msg: 'Please wait...',
    );
  }

  Future<void> performCreateChat(
    String? memberId,
    String? memberName,
    String? memberImage,
  ) async {
    final bool isSuccess = await createChatController.createChat(
      memberId: widget.userId,
    );

    if (isSuccess && mounted) {
      Get.to(
        () => ChatScreen(
          chatId: createChatController.chatId,
          receiverId: memberId ?? '',
          receiverImage: memberImage ?? '',
          receiverName: memberName ?? '',
        ),
      );
    } else if (mounted) {
      showSnackBarMessage(context, createChatController.errorMessage, true);
    }
  }

  // কানেকশন রিমুভ
  void removeConnection() {
    showLoadingOverLay(
      asyncFunction: () async => await performRemoveConnection(),
      msg: 'Removing connection...',
    );
  }

  Future<void> performRemoveConnection() async {
    final bool isSuccess = await removeConnectionController.deleteConnection(
      connectionMemberId: widget.userId,
    );

    if (isSuccess && mounted) {
      controller.getOthersProfile(widget.userId); // রিফ্রেশ প্রোফাইল
      showSnackBarMessage(context, 'Connection removed', false);
      Navigator.pop(context); // bottom sheet বন্ধ
    } else if (mounted) {
      showSnackBarMessage(context, 'Failed to remove connection', true);
    }
  }

  // রিকোয়েস্ট পাঠানো
  void addRequest() {
    showLoadingOverLay(
      asyncFunction: () async => await performAddRequest(),
      msg: 'Sending request...',
    );
  }

  Future<void> performAddRequest() async {
    final bool isSuccess = await addRequestController.addRequest(
      receiverId: widget.userId,
    );

    if (isSuccess && mounted) {
      controller.getOthersProfile(widget.userId);
      showSnackBarMessage(context, 'Request sent successfully', false);
    } else if (mounted) {
      showSnackBarMessage(context, addRequestController.errorMessage, true);
    }
  }

  // রেকমেন্ডেশন বটম শিট দেখানো (লিস্ট পাস না করে!)
  void _showRecommendationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RcommendationButtomSheet(
        recieverId: widget.userId,
        isCreateReview: true, // অন্যের প্রোফাইলে রিভিউ দিতে পারবে
      ),
    );
  }

  // রিমুভ কানেকশন কনফার্মেশন
  void _showRemoveConnection() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.black,
        height: 250.h,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleIconWidget(
              imagePath: Assets.images.delete.keyName,
              onTap: () {},
              iconRadius: 22,
              radius: 24,
              color: const Color(0xff312609),
              iconColor: const Color(0xffDC8B44),
            ),
            heightBox20,
            Text(
              'Remove Connection?',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            heightBox8,
            Text(
              'Are you sure you want to remove this connection?',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xff9FA3AA)),
            ),
            heightBox20,
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    color: const Color.fromARGB(255, 15, 15, 15),
                    borderColor: const Color(0xff262629),
                    title: 'Discard',
                    onPress: () => Navigator.pop(context),
                  ),
                ),
                widthBox12,
                Expanded(
                  child: CustomElevatedButton(
                    color: const Color(0xffE62047),
                    title: 'Remove',
                    onPress: () {
                      Navigator.pop(context); // কনফার্মেশন শিট বন্ধ
                      removeConnection();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),

            // প্রোফাইল কার্ড
            Obx(() {
              if (controller.inProgress) {
                return const InfoCardShimmerEffectWidget();
              }

              final person = controller.othersProfileData?.auth?.person;

              return InfoCard(
                isBack: true,
                isEditImage: false,
                isTrailing: false,
                imagePath: person?.image ?? '',
                editOnTap: () {},
                title: person?.name ?? 'Unknown',
                memberInfo: person?.title ?? '',
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
                      onTap: () =>
                          createChat(person?.id, person?.name, person?.image),
                      radius: 15,
                      color: LightThemeColors.blueColor,
                      iconColor: Colors.white,
                    ),
                    SizedBox(width: 10.w),
                    SizedBox(
                      height: 31.h,
                      width: 116.w,
                      child: CustomElevatedButton(
                        color:
                            controller.othersProfileData!.connection?.status ==
                                null
                            ? LightThemeColors.blueColor
                            : LightThemeColors.themeGreyColor,
                        textSize: 12,
                        title:
                            controller.othersProfileData!.connection?.status ==
                                'ACCEPTED'
                            ? 'Added'
                            : controller
                                      .othersProfileData!
                                      .connection
                                      ?.status ==
                                  'PENDING'
                            ? 'Pending'
                            : controller
                                      .othersProfileData!
                                      .connection
                                      ?.status ==
                                  'REJECTED'
                            ? 'Rejected'
                            : controller
                                      .othersProfileData!
                                      .connection
                                      ?.status ==
                                  'BLOCKED'
                            ? 'Blocked'
                            : 'Add',
                        onPress:
                            controller.othersProfileData!.connection?.status ==
                                'ACCEPTED'
                            ? _showRemoveConnection
                            : controller
                                      .othersProfileData!
                                      .connection
                                      ?.status ==
                                  null
                            ? addRequest
                            : null,
                        borderRadius: 50,
                      ),
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: 10.h),

            // রেকমেন্ডেশন উইজেট - GetBuilder দিয়ে real-time update
            Obx(() {
              final int count =
                  recommendationController.recommendationData.length;
              if (controller.inProgress) return const Text('Loading...');
              return Recommendation(
                isEmpty: recommendationController.recommendationData.isEmpty
                    ? true
                    : false,
                onTap: _showRecommendationSheet, // live sheet খুলবে
                count: count,
              );
            }),

            SizedBox(height: 10.h),

            // লোকেশন ও জয়েন ডেট
            Obx(() {
              if (controller.inProgress) return const SizedBox();

              final createdAt = controller.othersProfileData?.auth?.createdAt;
              final dateFormatter = createdAt != null
                  ? DateFormatter(createdAt)
                  : DateFormatter(DateTime.now());

              return LocationInfo(
                date: dateFormatter.getShortDateFormat(),
                location:
                    controller.othersProfileData?.auth?.person?.address ??
                    'No Location',
              );
            }),

            SizedBox(height: 20.h),
            const StraightLiner(height: 0.4, color: Color(0xff454545)),
            SizedBox(height: 10.h),

            // ট্যাব: Post / Resume
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => selectedIndex = 0),
                  child: SelectOptionWidget(
                    currentIndex: 0,
                    selectedIndex: selectedIndex,
                    title: 'Post',
                    lineColor: Colors.white,
                  ),
                ),
                SizedBox(width: 100.w),
                GestureDetector(
                  onTap: () => setState(() => selectedIndex = 1),
                  child: SelectOptionWidget(
                    currentIndex: 1,
                    selectedIndex: selectedIndex,
                    title: 'Resume',
                    lineColor: Colors.white,
                  ),
                ),
              ],
            ),

            const StraightLiner(height: 0.4, color: Color(0xff454545)),
            SizedBox(height: 10.h),

            // ট্যাব কন্টেন্ট
            Expanded(
              child: selectedIndex == 0
                  ? OthersPostSection(userId: widget.userId)
                  : MyResumeSection(userId: widget.userId),
            ),
          ],
        ),
      ),
    );
  }
}
