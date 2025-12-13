// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/custom_size.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/socket/socket_service.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
import 'package:wisper/app/core/widgets/circle_icon.dart';
import 'package:wisper/app/modules/chat/controller/message_controller.dart';
import 'package:wisper/app/modules/chat/model/message_keys.dart';
import 'package:wisper/app/modules/chat/widgets/chatting_field.dart';
import 'package:wisper/app/modules/chat/widgets/chatting_header.dart';
import 'package:wisper/app/modules/chat/widgets/option.dart';
import 'package:wisper/gen/assets.gen.dart';

class ChatScreen extends StatefulWidget {
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
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessageController messageCtrl = Get.put(MessageController());
  final SocketService socketService = Get.find<SocketService>(); // যেমন আছে
  final TextEditingController textCtrl = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late final String userAuthId;
  late final String receiverId;

  @override
  void initState() {
    super.initState();
    userAuthId = StorageUtil.getData(StorageUtil.userAuthId) ?? "";
    receiverId = widget.receiverId ?? '';

    // Delete previous messages
    socketService.messageList.clear();
    messageCtrl.isLoading.value = true;

    messageCtrl.getMessages(chatId: widget.chatId ?? '').then((_) {
      _scrollToBottom();
    });

    socketService.socket.on('newMessage', _handleIncomingMessage);
    print("socketService.messageList: ${socketService.messageList.length}");
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String _safeImageUrl(dynamic file) {
    if (file == null || file.toString() == 'null') return "";
    if (file is String && file.trim().isNotEmpty) return file.trim();
    if (file is List && file.isNotEmpty) return file.first.toString().trim();
    return "";
  }

  void _handleIncomingMessage(dynamic data) {
    try {
      print('Incoming message from socket: $data');

      final String msgId = data['id'] ?? '';
      print("msgId: $msgId");

      if (socketService.messageList.any((e) => e['id'] == msgId)) {
        print("Duplicate blocked: $msgId");
        return;
      }

      print('Adding message to list: $msgId');

      final Map<String, dynamic> msg = {
        SocketMessageKeys.id: msgId,
        SocketMessageKeys.text: (data['text'] ?? "").toString(),
        SocketMessageKeys.imageUrl: _safeImageUrl(data['file']),
        SocketMessageKeys.senderId:
            data['sender']['id'] ?? data['senderId'] ?? '',
        SocketMessageKeys.chat: data['chatId'] ?? '',
        SocketMessageKeys.createdAt: (data['createdAt'] ?? DateTime.now())
            .toString(),
      };

      socketService.messageList.add(msg);
      print("socketService.messageList: ${socketService.messageList.length}");
      if (mounted) setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      print("Socket parse error: $e");
    }
  }

  bool _isMe(Map<String, dynamic> msg) =>
      msg[SocketMessageKeys.senderId] == userAuthId;

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const AttachmentBottomSheet(),
    );
  }

  Future<void> sendMessageBTN(String chatId, String text) async {
    print('BUTTON CLICKED');
    print('Chat ID: $chatId');
    print('Text: $text');
    if (text.trim().isEmpty) {
      Get.snackbar('Error', 'Message or image cannot be empty');
      return;
    }
    socketService.socket.emit('sendMessage', {
      "chatId": chatId,
      "text": text.trim(),
    });

    textCtrl.clear();
  }

  @override
  void dispose() {
    // অবশ্যই off করো → না হলে ডুপ্লিকেট মেসেজ আসবে
    socketService.socket.off('newMessage', _handleIncomingMessage);
    textCtrl.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('is me: $_isMe');
    return Scaffold(
      body: Column(
        children: [
          ChatHeader(
            name: widget.receiverName,
            image: widget.receiverImage,
            id: widget.receiverId,
            status: 'online',
          ),
          Expanded(
            child: Obx(() {
              final messages = socketService.messageList.reversed.toList();

              if (messageCtrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (messages.isEmpty) {
                return Center(
                  child: Text(
                    "No messages yet. Start the conversation!",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                controller: scrollController,
                padding: EdgeInsets.all(10.r),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMe = _isMe(msg);
                  final imageUrl = _safeImageUrl(msg['imageUrl']);
                  final DateFormatter formattedTime = DateFormatter(
                    msg[SocketMessageKeys.createdAt],
                  );
                  final String time = formattedTime.getRelativeTimeFormat();
                  return MessageBubble(
                    message: msg,
                    isMe: isMe,
                    imageUrl: imageUrl,
                    receiverImage:
                        widget.receiverImage ?? Assets.images.image.keyName,
                    time: time,
                  );
                },
              );
            }),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        color: Colors.black,
        child: Container(
          height: 70.h,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(child: ChattingFieldWidget(controller: textCtrl)),

              CircleIconWidget(
                imagePath: Assets.images.attatchment.keyName,
                onTap: _showAttachmentOptions,
                radius: 18,
                iconRadius: 24,
              ),
              widthBox8,
              CircleIconWidget(
                imagePath: Assets.images.send.keyName,
                onTap: () {
                  sendMessageBTN(widget.chatId ?? '', textCtrl.text);
                },
                radius: 18,
                iconRadius: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====== MessageBubble & AttachmentBottomSheet (অপরিবর্তিত) ======
class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final String imageUrl;
  final String receiverImage;
  final String time;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.imageUrl,
    required this.receiverImage,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              backgroundImage: AssetImage(receiverImage),
              radius: 16.r,
            ),
          if (!isMe) widthBox4 else widthBox10,
          SizedBox(
            width: 270.w,
            child: Column(
              crossAxisAlignment: isMe
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
                      colors: isMe
                          ? [const Color(0xff2799EA), const Color(0xff2799EA)]
                          : [const Color(0xffF3F3F5), const Color(0xffF3F3F5)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: isMe
                          ? Radius.circular(16.r)
                          : Radius.circular(0.r),
                      bottomRight: isMe
                          ? Radius.circular(0.r)
                          : Radius.circular(16.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.network(
                              imageUrl,
                              height: 160.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 160.h,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (message['text'].toString().isNotEmpty)
                        Text(
                          message['text'].toString(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Text(
                      time, // পরে dynamic করো
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isMe ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 8),
                      Icon(
                        message['seen'] == true
                            ? Icons.check_circle
                            : Icons.check,
                        size: 16,
                        color: message['seen'] == true
                            ? Colors.cyan
                            : Colors.white70,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
