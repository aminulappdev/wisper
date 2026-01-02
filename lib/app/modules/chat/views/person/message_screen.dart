// ChatScreen (unchanged)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/modules/chat/controller/message_controller.dart';
import 'package:wisper/app/modules/chat/model/message_keys.dart';
import 'package:wisper/app/modules/chat/views/person/message_input_bar.dart';
import 'package:wisper/app/modules/chat/widgets/chatting_header.dart';
import 'package:wisper/app/modules/chat/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String? receiverId;
  final String? receiverName;
  final String? receiverImage;
  final String? chatId;
  final bool? isPerson;

  const ChatScreen({
    super.key,
    this.receiverId,
    this.receiverName,
    this.receiverImage,
    this.chatId,
    this.isPerson,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessageController ctrl = Get.put(MessageController());

  @override
  void initState() {
    print(
      'Chat ID: ${widget.chatId} Receiver ID: ${widget.receiverId} Receiver Name: ${widget.receiverName} Receiver Image: ${widget.receiverImage}',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.setupChat(chatId: widget.chatId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ChatHeader(
            isPerson: widget.isPerson,
            chatId: widget.chatId,
            name: widget.receiverName,
            image: widget.receiverImage,
            memberId: widget.receiverId,
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
                    fileUrl: imageUrl,
                    fileType: msg[SocketMessageKeys.fileType] ?? '',
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
            onSend: () => ctrl.sendMessage(widget.chatId ?? ''),
          ),
        ],
      ),
    );
  }
}
