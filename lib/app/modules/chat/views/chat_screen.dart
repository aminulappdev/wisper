import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/modules/chat/views/group_message_screen.dart';
import 'package:wisper/app/modules/chat/views/message_screen.dart';

import 'package:wisper/app/modules/chat/widgets/chat_list_widget.dart';
import 'package:wisper/gen/assets.gen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List members = [
    {
      'isGroup': false,
      'imagePath': Assets.images.image.keyName,
      'name': 'Aminul',
      'message': 'Hello! How are you?',
      'time': '1 min ago',
      'unreadMessageCount': '5',
    },
    {
      'isGroup': true,
      'imagePath': Assets.images.userGroup.keyName,
      'name': 'Tech Debuggers',
      'message': 'Hello! How are you?',
      'time': '5 min',
      'unreadMessageCount': '5',
    },
    {
      'isGroup': false,
      'imagePath': Assets.images.image.keyName,
      'name': 'Emon Hossain',
      'message': 'Hello! How are you?',
      'time': '1 min ago',
      'unreadMessageCount': '5',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatListHeader(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return MemberListTile(
                          onTap: () {
                            members[index]['isGroup']
                                ? Get.to(() => const GroupChatScreen())
                                : Get.to(() => ChatScreen());
                          },
                          isGroup: members[index]['isGroup'],
                          imagePath: members[index]['imagePath'],
                          name: members[index]['name'],
                          message: members[index]['message'],
                          time: members[index]['time'],
                          unreadMessageCount:
                              members[index]['unreadMessageCount'],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemberListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final bool? isGroup;
  final String imagePath;
  final String name;
  final String message;
  final String time;
  final String unreadMessageCount;
  const MemberListTile({
    super.key,
    this.isGroup,
    required this.imagePath,
    required this.name,
    required this.message,
    required this.time,
    required this.unreadMessageCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isGroup!
                    ? CircleAvatar(
                        radius: 25.r,

                        backgroundColor: Color(0xff051B33),
                        child: CrashSafeImage(
                          Assets.images.userGroup.keyName,
                          color: Color(0xff1F7DE9),
                          height: 26,
                        ),
                      )
                    : CircleAvatar(
                        radius: 25.r,
                        backgroundImage: AssetImage(imagePath),
                      ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xff98A2B3),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            message,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff98A2B3),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        CircleAvatar(
                          radius: 7,
                          backgroundColor: Colors.blue,
                          child: Text(
                            unreadMessageCount,
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    heightBox12,
                    Container(height: 0.5, width: 250, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
