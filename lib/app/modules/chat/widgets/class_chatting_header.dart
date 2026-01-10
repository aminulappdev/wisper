// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wisper/app/core/config/theme/light_theme_colors.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/utils/show_over_loading.dart';
import 'package:wisper/app/core/utils/snack_bar.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/custom_button.dart';
import 'package:wisper/app/core/widgets/custom_popup.dart';
import 'package:wisper/app/core/widgets/details_card.dart';
import 'package:wisper/app/modules/calls/views/group_audio_screen.dart';
import 'package:wisper/app/modules/calls/views/group_video_call_screen.dart';
import 'package:wisper/app/modules/chat/controller/delete_group_chat_controller.dart';
import 'package:wisper/app/modules/chat/controller/mute_chat_controller.dart';
import 'package:wisper/app/modules/chat/controller/mute_info_controller.dart';
import 'package:wisper/app/modules/chat/views/class/class_info.dart';
import 'package:wisper/app/modules/chat/views/group/group_info_screen.dart';
import 'package:wisper/app/modules/dashboard/views/dashboard_screen.dart';
import 'package:wisper/gen/assets.gen.dart';

class ClassChatHeader extends StatefulWidget {
  final String className;
  final String classImage;
  final String classId;
  final String chatId;

  const ClassChatHeader({
    super.key,
    required this.className,
    required this.classImage,
    required this.classId,
    required this.chatId,
  });

  @override
  State<ClassChatHeader> createState() => _ClassChatHeaderState();
}

class _ClassChatHeaderState extends State<ClassChatHeader> {
  List<CameraDescription>? cameras; // Nullable to handle initialization
  final DeleteGroupController deleteGroupController = DeleteGroupController();
  final GetMuteInfoController getMuteInfoController = Get.put(
    GetMuteInfoController(),
  );

  final MuteChatController muteChatController = MuteChatController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMuteInfoController.getMuteInfo(widget.chatId);
    });

    _initializeCamera();
  }

  // Initialize Camera
  Future<void> _initializeCamera() async {
    final availableCamerasList = await availableCameras();
    setState(() {
      cameras = availableCamerasList;
    });
  }

  void deleteChat() {
    showLoadingOverLay(
      asyncFunction: () async => await performDeleteChat(context),
      msg: 'Please wait...',
    );
  }

  Future<void> performDeleteChat(BuildContext context) async {
    final bool isSuccess = await deleteGroupController.deleteGroup(
      groupId: widget.chatId,
    );

    if (isSuccess) {
      Get.to(MainButtonNavbarScreen());
    } else {
      showSnackBarMessage(context, deleteGroupController.errorMessage, true);
    }
  }

  void muteChat(String? muteFor) {
    showLoadingOverLay(
      asyncFunction: () async => await performMuteChat(context, muteFor),
      msg: 'Please wait...',
    );
  }

  Future<void> performMuteChat(BuildContext context, String? muteFor) async {
    final bool isSuccess = await muteChatController.muteChat(
      chatId: widget.chatId,
      muteFor: muteFor,
    );

    if (isSuccess) {
      Get.to(MainButtonNavbarScreen());
    } else {
      showSnackBarMessage(context, deleteGroupController.errorMessage, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey suffixButtonKey = GlobalKey();
    final customPopupMenu = CustomPopupMenu(
      targetKey: suffixButtonKey,
      options: [
        // Pass widgets instead of strings
        Text(
          'Class Info',
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
            () =>
                ClassInfoScreen(classId: widget.classId, chatId: widget.chatId),
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
                      () => GroupInfoScreen(
                        groupId: widget.classId,
                        chatId: widget.chatId,
                      ),
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
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(widget.classImage),
                        radius: 20,
                      ),
                      widthBox10,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.className,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    CircleIconWidget(
                      imagePath: Assets.images.call.keyName,
                      onTap: () {
                        Get.to(() => GroupAudioCallScreen());
                      },
                      radius: 15,
                      iconColor: Colors.white,
                    ),
                    widthBox10,
                    CircleIconWidget(
                      imagePath: Assets.images.video.keyName,
                      onTap: () {
                        if (cameras != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupVideoCallScreen(),
                            ),
                          );
                        }
                      },
                      radius: 15,
                    ),
                    widthBox10,
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
          height: 290,
          child: Padding(
            padding:  EdgeInsets.all(20.0),
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
                        title: 'Delete',
                        onPress: () {
                          deleteChat();
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
                    child: Obx(() {
                      if (getMuteInfoController.inProgress) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (getMuteInfoController.muteInfoData == null) {
                        return Center(child: Text('No data'));
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                muteChat('EIGHT_HOURS');
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '8 hour',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Spacer(),
                                  getMuteInfoController.muteInfoData?.muteFor ==
                                          'EIGHT_HOURS'
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            heightBox8,
                            GestureDetector(
                              onTap: () {
                                muteChat('ONE_WEEK');
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '1 Week',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Spacer(),
                                  getMuteInfoController.muteInfoData?.muteFor ==
                                          'ONE_WEEK'
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            heightBox8,
                            GestureDetector(
                              onTap: () {
                                muteChat('ALWAYS');
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Always',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Spacer(),
                                  getMuteInfoController.muteInfoData?.muteFor ==
                                          'ALWAYS'
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }),
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
}
