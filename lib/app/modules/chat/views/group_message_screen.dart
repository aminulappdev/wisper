import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/core/widgets/details_card.dart';
import 'package:wisper/app/modules/chat/views/message_screen.dart';
import 'package:wisper/app/modules/chat/widgets/chat_custom_elevated_button.dart';
import 'package:wisper/app/modules/chat/widgets/chatting_field.dart';
import 'package:wisper/app/modules/chat/widgets/chatting_header.dart';
import 'package:wisper/gen/assets.gen.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0.0.h),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ChatHeader(),
              heightBox16,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    CircleIconWidget(
                      color: Color(0xff051B33),
                      iconColor: Color(0xff1F7DE9),
                      iconRadius: 35,
                      radius: 35,
                      imagePath: Assets.images.userGroup.keyName,
                      onTap: () {},
                    ),
                    heightBox20,
                    Text(
                      'You created this group',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    heightBox8,
                    Text(
                      'Group • 3 members',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff717182),
                      ),
                    ),

                    heightBox20,
                    Text(
                      'Corp members serving in Abuja',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1F7DE9),
                      ),
                    ),
                    heightBox10,
                    ChatCustomElevatedButton(
                      onTap: () => {},
                      imagePath: Assets.images.userAdd.keyName,
                      title: 'Add members',
                    ),
                    heightBox10,
                    ChatCustomElevatedButton(
                      onTap: () => {},
                      imagePath: Assets.images.attatchment.keyName,
                      title: 'Invite via link',
                    ),

                    heightBox14,
                    DetailsCard(
                      borderColor: Colors.transparent,
                      bgColor: Color(0xff1B1E25).withValues(alpha: 0.50),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CrashSafeImage(
                              Assets.images.adds.keyName,
                              height: 20,
                              color: Color(0xff717182),
                            ),
                            widthBox10,
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Messages and calls are end-to-end encrypted. Only people in this chat can read, listen to, or share them. ',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff717182),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Learn more',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff1F7DE9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: heightBox10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2,
                  color: Colors.black,
                  child: Container(
                    height: 70.h,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 200.w, child: ChattingFieldWidget()),
                        Row(
                          children: [
                            CircleIconWidget(
                              imagePath: Assets.images.attatchment.keyName,
                              onTap: _showAttachmentOptions,
                              radius: 18,
                              iconRadius: 24,
                            ),
                            widthBox8,
                            CircleIconWidget(
                              imagePath: Assets.images.send.keyName,
                              onTap: () {},
                              radius: 18,
                              iconRadius: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          height: 180,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Option(
                      onTap: () {},
                      imagePath: Assets.images.gallery.keyName,
                      iconColor: Color(0xff6192FD),
                      title: 'Image',
                    ),
                    Option(
                      onTap: () {},
                      imagePath: Assets.images.video.keyName,
                      iconColor: Color(0xffB95BFC),
                      title: '  Video',
                    ),
                    Option(
                      onTap: () {},
                      imagePath: Assets.images.file.keyName,
                      iconColor: Color(0xff00F359),
                      title: 'Document',
                    ),
                  ],
                ),
                heightBox16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Option(
                      onTap: () {},
                      imagePath: Assets.images.mic.keyName,
                      iconColor: Color(0xffF5AD31),
                      title: 'Audio',
                    ),
                    Option(
                      onTap: () {},
                      imagePath: Assets.images.location.keyName,
                      iconColor: Color(0xffF67748),
                      title: 'Location',
                    ),
                    Option(
                      onTap: () {},
                      imagePath: Assets.images.gallery.keyName,
                      iconColor: Color(0xff6192FD),
                      title: 'Contact  ',
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
