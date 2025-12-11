import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/socket/socket_service.dart';
import 'package:wisper/app/modules/chat/controller/all_chats_controller.dart';
import 'package:wisper/app/modules/chat/views/class/class_message_screen.dart';
import 'package:wisper/app/modules/chat/views/group/group_message_screen.dart';
import 'package:wisper/app/modules/chat/views/person/message_screen.dart';
import 'package:wisper/app/modules/chat/widgets/chat_list_widget.dart';
import 'package:wisper/app/modules/chat/widgets/member_list_title.dart';
import 'package:wisper/gen/assets.gen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final AllChatsController _allChatsController = Get.put(AllChatsController());
  final SocketService socketService = Get.put(SocketService());

  @override
  void initState() {
    super.initState();
    socketService.init();
    print('Eta Chat List Screen');
    _allChatsController.getAllChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatListHeader(), // assuming this widget exists
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Obx(() {
                  if (_allChatsController.inProgress) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_allChatsController.allChatsData!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Chats Found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: _allChatsController.allChatsData?.length,
                    itemBuilder: (context, index) {
                      final chat = _allChatsController.allChatsData?[index];
                      final type = chat?.type ?? '';

                      // Current user ID
                      final currentUserId = StorageUtil.getData(
                        StorageUtil.userAuthId,
                      );

                      // Find the receiver participant (the one who is not current user)
                      final receiverParticipant = chat?.participants.firstWhere(
                        (p) => p.auth?.id != currentUserId,
                        orElse: () => chat.participants.first, // fallback
                      );

                      // Receiver name: person first, then business, then fallback
                      final receiverName =
                          receiverParticipant?.auth?.person?.name ??
                          receiverParticipant?.auth?.business?.name ??
                          'Unknown';

                      // Receiver image: person profile -> business profile -> default asset
                      final receiverImagePath =
                          receiverParticipant?.auth?.person?.image ??
                          receiverParticipant?.auth?.business?.image ??
                          Assets.images.image.keyName;

                      // Receiver ID
                      final receiverId = receiverParticipant?.auth?.id ?? '';

                      final name = type == 'GROUP'
                          ? chat!.group?.name ?? ''
                          : type == 'CLASS'
                          ? chat!.chatClass?.name ?? ''
                          : receiverName;

                      final tileImagePath = (type == 'GROUP' || type == 'CLASS')
                          ? Assets.images.image.keyName
                          : receiverImagePath;

                      return MemberListTile(
                        onTap: () {
                          if (type == 'GROUP') {
                            Get.to(
                              () => GroupChatScreen(
                                chatId: chat!.id,
                                receiverName: chat.group?.name ?? '',
                                receiverId: receiverId,
                              ),
                            );
                          } else if (type == 'CLASS') {
                            Get.to(() => ClassChatScreen());
                          } else {
                            Get.to(
                              () => ChatScreen(
                                chatId: chat!.id,
                                receiverName: receiverName,
                                receiverId: receiverId,
                              ),
                            );
                          }
                        },
                        isGroup: type == 'GROUP',
                        isClass: type == 'CLASS',
                        imagePath: tileImagePath,
                        name: name,
                        message: 'No message',
                        time: '10:00 AM',
                        unreadMessageCount: (chat?.count?.messages ?? 0)
                            .toString(),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
