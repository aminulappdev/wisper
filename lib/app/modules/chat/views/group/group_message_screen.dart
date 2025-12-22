// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/modules/chat/controller/message_controller.dart';
import 'package:wisper/app/modules/chat/model/message_keys.dart';
import 'package:wisper/app/modules/chat/views/person/message_input_bar.dart';
import 'package:wisper/app/modules/chat/widgets/empty_group_card.dart';
import 'package:wisper/app/modules/chat/widgets/group_chatting_header.dart';
import 'package:wisper/app/modules/chat/widgets/message_bubble.dart';
import 'package:wisper/app/modules/chat/widgets/option.dart';
import 'package:wisper/gen/assets.gen.dart';

class GroupChatScreen extends StatelessWidget {
  final String? groupName;
  final String? groupImage;
  final String? chatId; 
  final String? groupId;

  const GroupChatScreen({
    super.key,
    this.groupName,
    this.groupImage,
    this.chatId,
    this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    final MessageController ctrl = Get.put(MessageController());

    // Chat setup একবারই (group এর জন্য chatId ব্যবহার করছি)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.setupChat(chatId: chatId);
    });

    return Scaffold(
      body: Column(
        children: [
          GroupChatHeader(
            chatId: chatId ?? '',
            groupName: groupName ?? '',
            groupImage: groupImage ?? '',
            groupId: groupId ?? '',
          ),

          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (ctrl.messages.isEmpty) {
                return Center(
                  child: EmptyGroupInfoCard(
                    isGroup: true,
                    name: groupName ?? '',
                    member: '5',
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                controller: ctrl.scrollController,
                padding: EdgeInsets.all(10.r),
                itemCount: ctrl.messages.length,
                itemBuilder: (context, index) {
                  final msg = ctrl.messages[index];
                  final isMe =
                      msg[SocketMessageKeys.senderId] == ctrl.userAuthId;

                  final String senderName =
                      msg[SocketMessageKeys.senderName] ?? 'Unknown';
                  final String? senderImage =
                      msg[SocketMessageKeys.senderImage];

                  final imageUrl = msg[SocketMessageKeys.imageUrl] ?? "";
                  final time = DateFormatter(
                    msg[SocketMessageKeys.createdAt],
                  ).getRelativeTimeFormat();

                  return MessageBubble(
                    message: msg,
                    isMe: isMe,
                    imageUrl: imageUrl,
                    time: time,
                    senderName: senderName,
                    senderImage: senderImage,
                    isGroupChat: true,
                  );
                },
              );
            }),
          ),

          MessageInputBar(
            controller: ctrl.textController,
            onSend: () => ctrl.sendMessage(chatId ?? ''),
            onAttachment: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => const AttachmentBottomSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ====== MessageBubble & AttachmentBottomSheet (অপরিবর্তিত) ======

class AttachmentBottomSheet extends StatelessWidget {
  const AttachmentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: Get.height * 0.15,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Option(
                onTap: () {},
                imagePath: Assets.images.gallery.keyName,
                iconColor: const Color(0xff6192FD),
                title: 'Image',
              ),
              Option(
                onTap: () {},
                imagePath: Assets.images.video.keyName,
                iconColor: const Color(0xffB95BFC),
                title: 'Video',
              ),
              Option(
                onTap: () {},
                imagePath: Assets.images.file.keyName,
                iconColor: const Color(0xff00F359),
                title: 'Document',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
