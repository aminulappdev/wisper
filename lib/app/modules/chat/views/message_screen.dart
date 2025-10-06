import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/modules/chat/widgets/chatting_field.dart';
import 'package:wisper/app/modules/chat/widgets/chatting_header.dart';
import 'package:wisper/gen/assets.gen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messageList = [
    {
      "text": "I have some loads, can you transfer them to Dhaka safely?",
      "isSent": true,
    },
    {"text": "Oh it’s okay.", "isSent": false},
    {"text": "Next time, we will meet again", "isSent": true},
    {"text": "Oh it’s okay i like it too babe", "isSent": false},
    {"text": "Okay see you soon very soon", "isSent": true},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0.0.h),
        child: Column(
          children: [
            ChatHeader(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10.r),
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  final message = messageList[index];
                  return Align(
                    alignment: message['isSent']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: message['isSent']
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: message['isSent']
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            message['isSent']
                                ? SizedBox()
                                : CircleAvatar(
                                    backgroundImage: AssetImage(
                                      Assets.images.image.keyName,
                                    ),
                                    radius: 16.r,
                                  ),
                            message['isSent'] ? widthBox10 : widthBox4,
                            SizedBox(
                              width: 270.w,
                              child: Column(
                                crossAxisAlignment: message['isSent']
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: message['isSent']
                                            ? [
                                                Color(0xff2799EA),
                                                Color(0xff2799EA),
                                              ]
                                            : [
                                                Color(0xffF3F3F5),
                                                Color(0xffF3F3F5),
                                              ],
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: message['isSent']
                                            ? Radius.circular(16.r)
                                            : Radius.circular(0.r),
                                        bottomRight: message['isSent']
                                            ? Radius.circular(0.r)
                                            : Radius.circular(16.r),
                                        topLeft: Radius.circular(16.r),
                                        topRight: Radius.circular(16.r),
                                      ),
                                    ),
                                    child: Text(
                                      message['text'],
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: message['isSent']
                                            ? Color.fromARGB(255, 253, 253, 252)
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  message['isSent']
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '11:30 AM',
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.check,
                                              color: Colors.blue,
                                              size: 18,
                                            ),
                                          ],
                                        )
                                      : Text(
                                          '11:30 AM',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
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

class Option extends StatelessWidget {
  final VoidCallback onTap;
  final String imagePath;
  final String title;
  final Color? iconColor;
  const Option({
    super.key,
    required this.onTap,
    required this.imagePath,
    required this.title,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleIconWidget(
          imagePath: imagePath,
          onTap: onTap,
          iconColor: iconColor,
          iconRadius: 22,
          radius: 20,
        ),
        heightBox4,
        Text(title, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }
}
