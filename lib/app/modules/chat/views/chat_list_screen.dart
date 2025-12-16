import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/socket/socket_service.dart';
import 'package:wisper/app/core/utils/date_formatter.dart';
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
  final SocketService socketService = Get.find<SocketService>();

  @override
  void initState() {
    super.initState();
    print('Chat List Screen');

    // পুরনো listener গুলো remove করে নতুন add করুন (duplicate avoid করার জন্য)
    socketService.socket.off('chatList'); // সব chatList listener remove

    socketService.socket.on('chatList', (data) {
      print('chat_list socket event received'); // এটা এখন সবসময় print হবে
      updateData(); // API call for refresh
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketService.init();
      print('Eta Chat List Screen');
      _allChatsController.getAllChats();
    });
  }

  void updateData() {
    print('updateData called');
    _allChatsController.getAllChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size * 0.15,
        child: ChatListHeader(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // assuming this widget exists
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Obx(() {
                  final chats = _allChatsController.allChatsData;
                  if (_allChatsController.inProgress.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (chats.isEmpty) {
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
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = _allChatsController.allChatsData[index];
                      final type = chat.type ?? '';
                      DateFormatter formatter = DateFormatter(
                        chat.latestMessageAt ?? DateTime.now(),
                      );
                      var time =
                          _allChatsController
                              .allChatsData[index]
                              .messages
                              .isEmpty
                          ? ''
                          : formatter.getRelativeTimeFormat();
                      // Current user ID
                      final currentUserId = StorageUtil.getData(
                        StorageUtil.userAuthId,
                      );

                      // Find the receiver participant (the one who is not current user)
                      final receiverParticipant = chat.participants.firstWhere(
                        (p) => p.auth?.id != currentUserId,
                        orElse: () => chat.participants.first, // fallback
                      );

                      // Receiver name: person first, then business, then fallback
                      final receiverName =
                          receiverParticipant.auth?.person?.name ??
                          receiverParticipant.auth?.business?.name ??
                          'Unknown';

                      // Receiver image: person profile -> business profile -> default asset
                      final receiverImagePath =
                          receiverParticipant.auth?.person?.image ??
                          receiverParticipant.auth?.business?.image ??
                          Assets.images.image.keyName;

                      // Receiver ID
                      final receiverId = receiverParticipant.auth?.id ?? '';

                      final name = type == 'GROUP'
                          ? chat.group?.name ?? ''
                          : type == 'CLASS'
                          ? chat.chatClass?.name ?? ''
                          : receiverName;

                      final tileImagePath = (type == 'GROUP' || type == 'CLASS')
                          ? Assets.images.image.keyName
                          : receiverImagePath;

                      var lastMessage =
                          socketService
                              .socketFriendList[index]['messages']
                              .isEmpty
                          ? ''
                          : socketService
                                .socketFriendList[index]['messages'][0]['text'];

                      return MemberListTile(
                        onTap: () {
                          if (type == 'GROUP') {
                            Get.to(
                              () => GroupChatScreen(
                                chatId: chat.id,
                                groupName: chat.group?.name ?? '',

                                groupId: chat.groupId ?? '',
                              ),
                            );
                          } else if (type == 'CLASS') {
                            Get.to(() => ClassChatScreen());
                          } else {
                            Get.to(
                              () => ChatScreen(
                                chatId: chat.id,
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
                        message:
                            _allChatsController
                                .allChatsData[index]
                                .messages
                                .isEmpty
                            ? 'No messages yet'
                            : lastMessage ?? '',
                        time: time,
                        unreadMessageCount: (chat.count?.messages ?? 0)
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
