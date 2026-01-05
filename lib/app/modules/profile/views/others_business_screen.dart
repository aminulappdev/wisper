import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/line_widget.dart';
import 'package:wisper/app/modules/chat/controller/create_chat_controller.dart';
import 'package:wisper/app/modules/chat/views/person/message_screen.dart';
import 'package:wisper/app/modules/chat/widgets/location_info.dart';
import 'package:wisper/app/modules/chat/widgets/select_option_widget.dart';
import 'package:wisper/app/modules/homepage/views/others_job_section.dart';
import 'package:wisper/app/modules/homepage/views/others_post_section.dart';
import 'package:wisper/app/modules/profile/controller/buisness/other_business_controller.dart';
import 'package:wisper/app/modules/profile/views/person/edit_person_profile_screen.dart';
import 'package:wisper/app/modules/profile/widget/info_card.dart';
import 'package:wisper/gen/assets.gen.dart';

class OthersBusinessScreen extends StatefulWidget {
  final String userId; 
  const OthersBusinessScreen({super.key, required this.userId});

  @override
  State<OthersBusinessScreen> createState() => _OthersBusinessScreenState();
}

class _OthersBusinessScreenState extends State<OthersBusinessScreen> {
  final OtherBusinessController controller = Get.put(OtherBusinessController());
  final CreateChatController createChatController = Get.put(CreateChatController());

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    print('User ID: ${widget.userId}');
    controller.getOthersProfile(widget.userId);
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Obx(() {
          // Show loading while data is being fetched
          if (controller.inProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Data is loaded — now safe to access without fear of null
          final business = controller.profileData?.auth?.business;
          final createdAt = controller.profileData?.auth?.createdAt;
          final DateFormatter dateFormatter = createdAt != null
          ? DateFormatter(createdAt)
          : DateFormatter(DateTime.now());

          return Column(
            children: [
              SizedBox(height: 30.h),
              InfoCard(
                isEditImage: false,
                isTrailing: false,
                trailingOnTap: () {},
                imagePath: Assets.images.person.keyName,
                editOnTap: () {},
                title: business?.name ?? 'No Name',
                memberInfo: business?.industry ?? 'No Industry',
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
                        // Uncomment when ready
                        createChat(
                          business?.id ?? '',
                          business?.name ?? '',
                          business?.image ?? '',
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
              ),
              SizedBox(height: 10.h),
              LocationInfo(
                
                location: business?.address ?? 'No Address',
                date: dateFormatter.getShortDateFormat(),
              ),
              SizedBox(height: 20.h),
              const StraightLiner(height: 0.4, color: Color(0xff454545)),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  GestureDetector(
                    onTap: () => setState(() => selectedIndex = 1),
                    child: SelectOptionWidget(
                      currentIndex: 1,
                      selectedIndex: selectedIndex,
                      title: 'Job',
                      lineColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
              const StraightLiner(height: 0.4, color: Color(0xff454545)),
              SizedBox(height: 10.h),
              Expanded(
                child: selectedIndex == 0
                    ? OthersPostSection(userId: widget.userId)
                    : OthersJobSection(userId: widget.userId),
              ),
            ],
          );
        }),
      ),
    );
  }
}