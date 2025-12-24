import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/modules/chat/controller/message_controller.dart';
import 'package:wisper/app/modules/chat/model/message_keys.dart';
import 'package:wisper/app/modules/chat/views/person/message_input_bar.dart';
import 'package:wisper/app/modules/chat/widgets/chatting_header.dart';
import 'package:wisper/app/modules/chat/widgets/message_bubble.dart';
import 'package:wisper/app/modules/chat/widgets/option.dart';
import 'package:wisper/gen/assets.gen.dart';

class ChatScreen extends StatelessWidget {
  final String? receiverId;
  final String? receiverName;
  final String? receiverImage;
  final String? chatId;

  const ChatScreen({
    super.key,
    this.receiverId,
    this.receiverName,
    this.receiverImage,
    this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    final MessageController ctrl = Get.put(MessageController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.setupChat(chatId: chatId);
    });

    return Scaffold(
      body: Column(
        children: [
          ChatHeader(
            chatId: chatId,
            name: receiverName,
            image: receiverImage,
            memberId: receiverId,
            status: 'online',
          ),

          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (ctrl.messages.isEmpty) {
                return Center(
                  child: Text(
                    "No messages yet. Start the conversation!",
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
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
                  final imageUrl = msg[SocketMessageKeys.imageUrl] ?? "";

                  return MessageBubble(
                    message: msg,
                    isMe: isMe,
                    imageUrl: imageUrl,
                    senderImage: msg[SocketMessageKeys.senderImage],
                    senderName: msg[SocketMessageKeys.senderName],
                    time: DateFormatter(
                      msg[SocketMessageKeys.createdAt],
                    ).getRelativeTimeFormat(),
                    isGroupChat: false,
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
