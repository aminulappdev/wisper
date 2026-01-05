import 'package:camera/camera.dart';
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_popup.dart';
import 'package:wisper/app/core/widgets/details_card.dart';
import 'package:wisper/app/modules/calls/views/audio_call_screen.dart';
import 'package:wisper/app/modules/calls/views/video_call_screen.dart';
import 'package:wisper/app/modules/chat/controller/block_user_controller.dart';
import 'package:wisper/app/modules/profile/views/others_business_screen.dart';
import 'package:wisper/app/modules/profile/views/others_person_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class ChatHeader extends StatefulWidget {
  final String? name;
  final String? image;
  final String? status;
  final String? memberId;
  final String? chatId;
  final bool? isPerson;
  const ChatHeader({
    super.key,
    this.name,
    this.image,
    this.status,
    this.memberId,
    this.chatId,
    this.isPerson,
  });

  @override
  State<ChatHeader> createState() => _ChatHeaderState();
}

class _ChatHeaderState extends State<ChatHeader> {
  List<CameraDescription>? cameras; // Nullable to handle initialization
  final BlockUnblockMemberController blockUnblockMemberController =
      BlockUnblockMemberController();

  @override
  void initState() {
    super.initState();
    print(' is person: ${widget.isPerson}');
    _initializeCamera();
  }

  void blockMember(String? chatId, String? memberId) {
    showLoadingOverLay(
      asyncFunction: () async =>
          await performBlockMember(context, chatId, memberId),
      msg: 'Please wait...',
    );
  }

  Future<void> performBlockMember(
    BuildContext context,
    String? chatId,
    String? memberId,
  ) async {
    final bool isSuccess = await blockUnblockMemberController.blockMember(
      chatId: chatId,
      memberId: memberId,
    );

    if (isSuccess) {
      setState(() {});
      showSnackBarMessage(context, 'Blocked successfully', false);
    } else {
      showSnackBarMessage(
        context,
        blockUnblockMemberController.errorMessage,
        true,
      );
    }
  }

  // Initialize Camera
  Future<void> _initializeCamera() async {
    final availableCamerasList = await availableCameras();
    setState(() {
      cameras = availableCamerasList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey suffixButtonKey = GlobalKey();
    final customPopupMenu = CustomPopupMenu(
      targetKey: suffixButtonKey,
      options: [
        // Pass widgets instead of strings
        Text(
          'View Profile',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        Text(
          'Mute Notifications',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            CrashSafeImage(
              Assets.images.alert.keyName,
              height: 16.h,
              width: 16,
            ),
            widthBox10,
            Text(
              'Block User',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),

        Row(
          children: [
            CrashSafeImage(
              Assets.images.delete.keyName,
              height: 16.h,
              width: 16,
            ),
            widthBox10,
            Text(
              'Delete Conversation',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
            ),
          ],
        ),

        // Example of another widget
      ],
      optionActions: {
        '0': () {
          Get.to(
            () => widget.isPerson!
                ? OthersPersonScreen(userId: widget.memberId ?? '')
                : OthersBusinessScreen(userId: widget.memberId ?? ''),
          );
        },
        '1': () {
          _showMutePopup();
        },
        '2': () {
          _shoBlockUser();
        },
        '3': () {
          _shoDeleteConversation();
        },
      },
      menuWidth: 200,
      menuHeight: 30,
    );

    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => widget.isPerson!
                          ? OthersPersonScreen(userId: widget.memberId ?? '')
                          : OthersBusinessScreen(userId: widget.memberId ?? ''),
                    );
                  },
                  child: Row(
                    children: [
                      CircleIconWidget(
                        imagePath: Assets.images.arrowBack.keyName,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        radius: 13,
                      ),
                      widthBox10,
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          Assets.images.image.keyName,
                        ),
                        radius: 20,
                      ),
                      widthBox10,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.status!,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: LightThemeColors.themeGreyColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // CircleIconWidget(
                    //   imagePath: Assets.images.call.keyName,
                    //   onTap: () {
                    //     Get.to(() => AudioCallScreen());
                    //   },
                    //   radius: 15,
                    //   iconColor: Colors.white,
                    // ),
                    // widthBox10,
                    // CircleIconWidget(
                    //   imagePath: Assets.images.video.keyName,
                    //   onTap: () {
                    //     if (cameras != null) {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) =>
                    //               VideoCallScreen(cameras: cameras!),
                    //         ),
                    //       );
                    //     }
                    //   },
                    //   radius: 15,
                    // ),
                    // widthBox10,
                    CircleIconWidget(
                      key: suffixButtonKey,
                      imagePath: Assets.images.moreHor.keyName,
                      onTap: () {
                        customPopupMenu.showMenuAtPosition(context);
                      },
                      radius: 15,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _shoDeleteConversation() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleIconWidget(
                  imagePath: Assets.images.delete.keyName,
                  onTap: () {},
                  iconRadius: 22,
                  radius: 24,
                  color: Color(0xff310B09),
                  iconColor: Color(0xffD4183D),
                ),
                heightBox20,
                Text(
                  'Delete Conversation?',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                heightBox8,
                Text(
                  'This will permanently delete your conversation with Sarah Chen. This action cannot be undone.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff9FA3AA),
                  ),
                ),
                heightBox12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        color: Color.fromARGB(255, 15, 15, 15),
                        borderColor: Color(0xff262629),
                        title: 'Discard',
                        onPress: () {},
                      ),
                    ),
                    widthBox12,
                    Expanded(
                      child: CustomElevatedButton(
                        color: Color(0xffE62047),
                        title: 'Block',
                        onPress: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMutePopup() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          height: 260,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'Mute notifications',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    CircleIconWidget(
                      imagePath: Assets.images.cross.keyName,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      radius: 15,
                    ),
                  ],
                ),
                heightBox10,
                DetailsCard(
                  bgColor: Color(0xff181818),
                  borderColor: Color(0xff181818),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Other members will not see that you muted this chat, and you will still be notified if you are mentioned.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                heightBox12,
                DetailsCard(
                  width: double.infinity,
                  bgColor: Color(0xff181818),
                  borderColor: Color(0xff181818),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '8 hours',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        heightBox8,
                        Text(
                          '1 week',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        heightBox8,
                        Text(
                          'Always',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _shoBlockUser() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleIconWidget(
                  imagePath: Assets.images.delete.keyName,
                  onTap: () {},
                  iconRadius: 22,
                  radius: 24,
                  color: Color(0xff312609),
                  iconColor: Color(0xffDC8B44),
                ),
                heightBox20,
                Text(
                  'Block Sarah Chen?',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                heightBox8,
                Text(
                  'Sarah Chen wont be able to call or message you. They wont be notified that you blocked them.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff9FA3AA),
                  ),
                ),
                heightBox12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        color: Color.fromARGB(255, 15, 15, 15),
                        borderColor: Color(0xff262629),
                        title: 'Discard',
                        onPress: () {},
                      ),
                    ),
                    widthBox12,
                    Expanded(
                      child: CustomElevatedButton(
                        color: Color(0xffE62047),
                        title: 'Block',
                        onPress: () {
                          blockMember(widget.chatId, widget.memberId);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
