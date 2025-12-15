// // app/modules/chat/controller/all_chats_controller.dart

// import 'package:get/Get.dart';
// import 'package:wisper/app/core/get_storage.dart';
// import 'package:wisper/app/core/services/network_caller/network_caller.dart';
// import 'package:wisper/app/core/services/socket/socket_service.dart';
// import 'package:wisper/app/modules/authentication/views/sign_in_screen.dart';
// import 'package:wisper/app/modules/chat/model/all_chats_model.dart';
// import 'package:wisper/app/urls.dart';

// class AllChatsController extends GetxController {
//   late final SocketService socketService;

//   var inProgress = false.obs;
//   var isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     socketService = Get.find<SocketService>();

//     socketService.init().then((_) {
//       _setupChatListSocketListener();
//     });

//     getAllChats();
//   }

//   Future<bool> getAllChats() async {
//     inProgress.value = true;
//     isLoading.value = true;

//     try {
//       final response = await Get.find<NetworkCaller>().getRequest(
//         Urls.allChatsUrl,
//         accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
//       );

//       if (response.isSuccess && response.responseData != null) {
//         final model = AllChatsModel.fromJson(response.responseData);
//         final chats = model.data?.chats ?? [];

//         socketService.socketFriendList.clear();
//         _populateSocketList(chats);

//         print("API → ${socketService.socketFriendList.length} chats loaded");
//         return true;
//       }
//     } catch (e) {
//       print("getAllChats error: $e");
//     } finally {
//       inProgress.value = false;
//       isLoading.value = false;
//     }
//     return false;
//   }

//   void _populateSocketList(List<AllChatsItemModel> chats) {
//     for (final chat in chats) {
//       socketService.socketFriendList.add({
//         "id": chat.id ?? '',
//         "type": chat.type ?? 'INDIVIDUAL',
//         "latestMessageAt": chat.latestMessageAt?.toIso8601String() ?? '',
//         "groupId": chat.groupId ?? '',
//         "classId": chat.classId ?? '',
//         "group": chat.group != null
//             ? {"image": chat.group!.image ?? '', "name": chat.group!.name ?? ''}
//             : null,
//         "chatClass": chat.chatClass != null
//             ? {
//                 "image": chat.chatClass!.image ?? '',
//                 "name": chat.chatClass!.name ?? '',
//               }
//             : null,
//         // toJson() ছাড়াই manually Map তৈরি
//         // "messages": chat.messages
//         //     .map(
//         //       (m) => {
//         //         "id": m.id ?? '',
//         //         "text": m.text ?? '',
//         //         "file": m.file,
//         //         "fileType": m.fileType,
//         //         "sender": m.sender != null
//         //             ? {
//         //                 "id": m.sender!.id ?? '',
//         //                 "person": m.sender!.person != null
//         //                     ? {"name": m.sender!.person!.name ?? 'Unknown'}
//         //                     : null,
//         //                 "business": m.sender!.business,
//         //               }
//         //             : null,
//         //       },
//         //     )
//         //     .toList(),
//         "_count": {"messages": chat.count?.messages ?? 0},
//         "participants": chat.participants
//             .map(
//               (p) => {
//                 "id": p.id ?? '',
//                 "auth": {
//                   "id": p.auth?.id ?? '',
//                   "person": p.auth?.person != null
//                       ? {
//                           "name": p.auth!.person!.name ?? 'Unknown',
//                           "image": p.auth!.person!.image ?? '',
//                         }
//                       : null,
//                   "business": p.auth?.business,
//                 },
//               },
//             )
//             .toList(),
//       });
//     }
//   }

//   void _setupChatListSocketListener() {
//     socketService.socket.off('chatList');
//     socketService.socket.on('chatList', (data) {
//       print("chatList socket event received");
//       try {
//         if (data is Map<String, dynamic> &&
//             data['data'] != null &&
//             data['data']['chats'] != null) {
//           final model = AllChatsModel.fromJson(data);
//           socketService.socketFriendList.clear();
//           _populateSocketList(model.data!.chats);
//           print(
//             "Socket → ${socketService.socketFriendList.length} chats updated",
//           );
//         }
//       } catch (e) {
//         print("chatList socket error: $e");
//       }
//     });
//   }

//   @override
//   void onClose() {
//     socketService.socket.off('chatList');
//     super.onClose();
//   }
// }
 

//  // app/modules/chat/views/chat_list_screen.dart

// import 'package:flutter/material.dart';
// import 'package:get/Get.dart';
// import 'package:wisper/app/core/get_storage.dart';
// import 'package:wisper/app/core/services/socket/socket_service.dart';
// import 'package:wisper/app/core/utils/date_formatter.dart';
// import 'package:wisper/app/modules/chat/controller/all_chats_controller.dart';
// import 'package:wisper/app/modules/chat/views/class/class_message_screen.dart';
// import 'package:wisper/app/modules/chat/views/group/group_message_screen.dart';
// import 'package:wisper/app/modules/chat/views/person/message_screen.dart';
// import 'package:wisper/app/modules/chat/widgets/chat_list_widget.dart';
// import 'package:wisper/app/modules/chat/widgets/member_list_title.dart';
// import 'package:wisper/gen/assets.gen.dart';

// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AllChatsController>();
//     final socketService = Get.find<SocketService>();

//     return Scaffold(
//       body: Obx(() {
//         final list = socketService.socketFriendList;

//         if (controller.isLoading.value && list.isEmpty) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (list.isEmpty) {
//           return const Center(
//             child: Text(
//               'No Chats Found',
//               style: TextStyle(fontSize: 18, color: Colors.white70),
//             ),
//           );
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           itemCount: list.length,
//           itemBuilder: (context, index) {
//             final chat = list[index] as Map<String, dynamic>;
//             final type = chat['type'] as String? ?? 'INDIVIDUAL';

//             final currentUserId = StorageUtil.getData(StorageUtil.userAuthId) ?? '';

//             final participants = chat['participants'] as List<dynamic>;

//             // সঠিক orElse function — error চলে যাবে
//             final receiver = participants.firstWhere(
//               (p) => (p as Map<String, dynamic>)['auth']['id'] != currentUserId,
//               orElse: () => participants.isNotEmpty
//                   ? participants[0] as Map<String, dynamic>
//                   : {'auth': {'id': '', 'person': null}},
//             ) as Map<String, dynamic>;

//             final auth = receiver['auth'] as Map<String, dynamic>;

//             final receiverName = auth['person']?['name'] as String? ??
//                 auth['business']?['name'] as String? ??
//                 'Unknown';

//             // Image ফিক্স — empty/null হলে default asset
//             String receiverImage = auth['person']?['image'] as String? ?? '';
//             if (receiverImage.isEmpty || receiverImage.trim().isEmpty || receiverImage == 'null') {
//               receiverImage = Assets.images.image.keyName;
//             }

//             final receiverId = auth['id'] as String? ?? '';

//             // Name
//             String name;
//             if (type == 'GROUP') {
//               name = (chat['group'] as Map<String, dynamic>?)?['name'] as String? ?? 'Group Chat';
//             } else if (type == 'CLASS') {
//               name = (chat['chatClass'] as Map<String, dynamic>?)?['name'] as String? ?? 'Class Chat';
//             } else {
//               name = receiverName;
//             }

//             String tileImage = (type == 'GROUP' || type == 'CLASS')
//                 ? Assets.images.image.keyName
//                 : receiverImage;

//             // Preview message
//             String preview = 'No message';
//             final messages = chat['messages'] as List<dynamic>;
//             if (messages.isNotEmpty) {
//               final msg = messages[0] as Map<String, dynamic>;
//               final text = msg['text'] as String? ?? '';
//               if (text.trim().isNotEmpty) {
//                 preview = text.trim();
//               } else if (msg['file'] != null && (msg['file'].toString().trim().isNotEmpty)) {
//                 preview = 'Photo';
//               } else {
//                 preview = 'Media';
//               }
//             }

//             // Time
//             String time = 'Just now';
//             final latestAt = chat['latestMessageAt'] as String? ?? '';
//             if (latestAt.isNotEmpty) {
//               time = DateFormatter(latestAt).getRelativeTimeFormat();
//             }

//             // Unread
//             final unread = ((chat['_count'] as Map<String, dynamic>?)?['messages'] as int? ?? 0).toString();

//             return MemberListTile(
//               onTap: () {
//                 if (type == 'GROUP') {
//                   Get.to(() => GroupChatScreen(
//                         chatId: chat['id'] as String,
//                         groupName: (chat['group'] as Map?)?['name'] as String? ?? '',
//                         groupId: chat['groupId'] as String? ?? '',
//                       ));
//                 } else if (type == 'CLASS') {
//                   Get.to(() => ClassChatScreen());
//                 } else {
//                   Get.to(() => ChatScreen(
//                         chatId: chat['id'] as String,
//                         receiverName: receiverName,
//                         receiverImage: receiverImage,
//                         receiverId: receiverId,
//                       ));
//                 }
//               },
//               isGroup: type == 'GROUP',
//               isClass: type == 'CLASS',
//               imagePath: tileImage,
//               name: name,
//               message: preview,
//               time: time,
//               unreadMessageCount: unread == '0' ? '' : unread,
//             );
//           },
//         );
//       }),
//     );
//   }
// }