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

  // Search related
  final TextEditingController _searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    print('Chat List Screen');

    socketService.socket.off('chatList');
    socketService.socket.on('chatList', (data) {
      print('chat_list socket event received');
      updateData();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketService.init();
      print('Eta Chat List Screen');
      _allChatsController.getAllChats();
    });

    // Listen to search text changes
    _searchController.addListener(() {
      searchQuery.value = _searchController.text.toLowerCase();
    });
  }

  void updateData() {
    print('updateData called');
    _allChatsController.getAllChats();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: ChatListHeader(
          searchController: _searchController,
          onSearchChanged: () {
            searchQuery.value = _searchController.text.toLowerCase();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Obx(() {
                  final chats = _allChatsController.allChatsData;
                  final query = searchQuery.value;

                  // Filter chats based on search query
                  final filteredChats = query.isEmpty
                      ? chats
                      : chats.where((chat) {
                          final type = chat.type ?? '';
                          String nameToSearch = '';

                          if (type == 'GROUP') {
                            nameToSearch = chat.group?.name?.toLowerCase() ?? '';
                          } else if (type == 'CLASS') {
                            nameToSearch = chat.chatClass?.name?.toLowerCase() ?? '';
                          } else {
                            // Personal chat
                            final currentUserId =
                                StorageUtil.getData(StorageUtil.userId);

                            final receiverParticipant = chat.participants
                                .firstWhere(
                                  (p) => p.auth?.id != currentUserId,
                                  orElse: () => chat.participants.first,
                                );

                            nameToSearch = (receiverParticipant.auth?.person?.name ??
                                    receiverParticipant.auth?.business?.name ??
                                    '')
                                .toLowerCase();
                          }

                          return nameToSearch.contains(query);
                        }).toList();

                  if (_allChatsController.inProgress.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (filteredChats.isEmpty) {
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
                    itemCount: filteredChats.length,
                    itemBuilder: (context, index) {
                      final chat = filteredChats[index];
                      final type = chat.type ?? '';
                      DateFormatter formatter = DateFormatter(
                        chat.latestMessageAt ?? DateTime.now(),
                      );
                      var time = chat.messages.isEmpty
                          ? ''
                          : formatter.getRelativeTimeFormat();

                      final currentUserId =
                          StorageUtil.getData(StorageUtil.userId);

                      final receiverParticipant = chat.participants.firstWhere(
                        (p) => p.auth?.id != currentUserId,
                        orElse: () => chat.participants.first,
                      );

                      final receiverName =
                          receiverParticipant.auth?.person?.name ??
                              receiverParticipant.auth?.business?.name ??
                              'Unknown';

                      final receiverImagePath =
                          receiverParticipant.auth?.person?.image ??
                              receiverParticipant.auth?.business?.image ??
                              Assets.images.image.keyName;

                      final receiverId = receiverParticipant.auth?.id ?? '';

                      final name = type == 'GROUP'
                          ? chat.group?.name ?? ''
                          : type == 'CLASS'
                              ? chat.chatClass?.name ?? ''
                              : receiverName;

                      final tileImagePath = (type == 'GROUP' || type == 'CLASS')
                          ? Assets.images.image.keyName
                          : receiverImagePath;

                      // Fixed: socketService.socketFriendList may cause error
                      // We now use local chat.messages instead
                      final lastMessageText = chat.messages.isEmpty
                          ? 'No messages yet'
                          : chat.messages.first.text ?? '';

                      return MemberListTile(
                        onTap: () {
                          if (type == 'GROUP') {
                            Get.to(() => GroupChatScreen(
                                  chatId: chat.id,
                                  groupName: chat.group?.name ?? '',
                                  groupId: chat.groupId ?? '',
                                ));
                          } else if (type == 'CLASS') {
                            Get.to(() => ClassChatScreen(
                                  chatId: chat.id,
                                  className: chat.chatClass?.name ?? '',
                                  classId: chat.classId ?? '',
                                ));
                          } else {
                            Get.to(() => ChatScreen(
                                  chatId: chat.id,
                                  receiverName: receiverName,
                                  receiverId: receiverId,
                                ));
                          }
                        },
                        isGroup: type == 'GROUP',
                        isClass: type == 'CLASS',
                        imagePath: tileImagePath,
                        name: name,
                        message: lastMessageText,
                        time: time,
                        unreadMessageCount:
                            (chat.count?.messages ?? 0).toString(),
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