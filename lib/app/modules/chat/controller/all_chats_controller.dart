// app/modules/chat/controller/all_chats_controller.dart

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/socket/socket_service.dart';
import 'package:wisper/app/modules/authentication/views/sign_in_screen.dart';
import 'package:wisper/app/modules/chat/model/all_chats_model.dart';
import 'package:wisper/app/urls.dart';

class AllChatsController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();

  final RxBool inProgress = false.obs;
  final RxString errorMessage = ''.obs;

  final Rx<AllChatsModel?> allChatsModel = Rx<AllChatsModel?>(null);

  final String myAuthId = StorageUtil.getData(StorageUtil.userId) ?? '';

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await socketService.init();
    _setupSocketListeners();
    await getAllChats();
  }

  void _setupSocketListeners() {
    // পুরানো listener গুলো remove করে নতুন add করা
    socketService.socket.off('chatList');
    socketService.socket.off('typingStatus');
    socketService.socket.off('chatList:typing');

    socketService.socket.on('chatList', _handleIncomingChat);
    socketService.socket.on('typingStatus', _handleIncomingChat);
    socketService.socket.on('chatList:typing', _handleIncomingChat);
  }

  void _handleIncomingChat(dynamic rawData) {
    print('Real-time chatList event received: $rawData');

    if (rawData == null) return;

    final Map<String, dynamic> data = rawData is String
        ? jsonDecode(rawData)
        : rawData as Map<String, dynamic>;

    final chat = data['chats'] ?? data;
    final String chatId = chat['id']?.toString() ?? '';
    if (chatId.isEmpty) return;

    final latestMessage = chat['latestMessage'];
    final String text = latestMessage?['text']?.toString() ?? 'New message';
    final String time =
        latestMessage?['createdAt']?.toString() ??
        DateTime.now().toIso8601String();
    final String senderId = latestMessage?['sender']?['id']?.toString() ?? '';
    final bool isFromMe = senderId == myAuthId;

    final list = socketService.socketFriendList;
    final int index = list.indexWhere((e) => e['id'] == chatId);

    if (index != -1) {
      // Existing chat — শুধু যা দরকার তাই update করি, বাকি key অক্ষত থাকে
      final item = list[index]; // reference নয়, original map

      item['lastMessage'] = text;
      item['latestMessageAt'] = time;

      if (!isFromMe) {
        item['unreadMessageCount'] = (item['unreadMessageCount'] ?? 0) + 1;
      }

      // Top-এ নিয়ে আসি
      list.removeAt(index);
      list.insert(0, item);
    } else {
      // নতুন চ্যাট — minimal data দিয়ে insert করি
      // কিন্তু key গুলো same রাখি যাতে UI crash না করে
      final newItem = {
        "id": chatId,
        "type": chat['type'] ?? 'INDIVIDUAL',
        "lastMessage": text,
        "latestMessageAt": time,
        "unreadMessageCount": isFromMe ? 0 : 1,
        "group": chat['group'], // null or map
        "chatClass": chat['class'], // null or map
        "receiverName":
            chat['receiverName'] ??
            'Unknown', // default name, পরে API reload করলে update হবে
        "receiverImage": '',
        "receiverId": '',
      };

      list.insert(0, newItem);
    }

    _sortSocketList();
  }

  Future<void> getAllChats() async {
    if (inProgress.value) return;
    inProgress.value = true;

    try {
      final response = await Get.find<NetworkCaller>().getRequest(
        Urls.allChatsUrl,
        accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
      );

      if (response.isSuccess && response.responseData != null) {
        errorMessage.value = '';
        final model = AllChatsModel.fromJson(response.responseData);
        allChatsModel.value = model;

        socketService.socketFriendList.clear();

        print(
          'Socket List length initial : ${socketService.socketFriendList.length}',
        );

        for (final chat in model.data?.chats ?? []) {
          final String type = chat.type ?? 'INDIVIDUAL';
          print('type: $type');

          // // অন্য participant বের করা
          final otherParticipant = chat.participants.firstWhere(
            (p) => p.auth?.id != StorageUtil.getData(StorageUtil.userId),
          );

          final receiverAuth =
              (otherParticipant ?? chat.participants.first).auth;

          String displayName = 'Unknown';
          String displayImage = '';
          String receiverId = '';

          if (type == 'INDIVIDUAL') {
            displayName =
                receiverAuth?.person?.name ??
                receiverAuth?.business?.name ??
                'Unknown';
            displayImage =
                receiverAuth?.person?.image ??
                receiverAuth?.business?.image ??
                '';
            receiverId = receiverAuth?.id ?? '';
          }

          String tileName = '';
          if (type == 'GROUP') {
            tileName = chat.group?.name ?? 'Group Chat';
          } else if (type == 'CLASS') {
            tileName = chat.chatClass?.name ?? 'Class Chat';
          }

          print(
            'Socket List length before adding: ${socketService.socketFriendList.length}',
          );

          socketService.socketFriendList.add({
            "id": chat.id ?? '',
            "type": type,
            "latestMessageAt": chat.latestMessageAt?.toIso8601String() ?? '',
            "lastMessage": chat.messages.isNotEmpty
                ? chat.messages.first.text ?? 'No messages yet'
                : 'No messages yet',
            "unreadMessageCount": chat.count?.messages ?? 0,
            "group": chat.group != null
                ? {"name": chat.group?.name, "image": chat.group?.image}
                : null,
            "chatClass": chat.chatClass != null
                ? {"name": chat.chatClass?.name, "image": chat.chatClass?.image}
                : null,
            "receiverName": type == 'INDIVIDUAL' ? displayName : '',
            "receiverImage": type == 'INDIVIDUAL' ? displayImage : '',
            "receiverId": type == 'INDIVIDUAL' ? receiverId : '',
          });

          print(
            'Socket List length after adding: ${socketService.socketFriendList.length}',
          );
        }

        _sortSocketList();
      } else {
        errorMessage.value = response.errorMessage;
        if ((response.errorMessage).toLowerCase().contains('expired')) {
          Get.offAll(() => SignInScreen());
        }
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      inProgress.value = false;
    }
  }

  void _sortSocketList() {
    socketService.socketFriendList.sort((a, b) {
      final DateTime aTime =
          DateTime.tryParse(a['latestMessageAt'] ?? '') ?? DateTime(1970);
      final DateTime bTime =
          DateTime.tryParse(b['latestMessageAt'] ?? '') ?? DateTime(1970);
      return bTime.compareTo(aTime); // Latest first
    });

    socketService.socketFriendList.refresh(); // GetX UI update
  }

  @override
  void onClose() {
    socketService.socket.off('chatList');
    socketService.socket.off('typingStatus');
    socketService.socket.off('chatList:typing');
    super.onClose();
  }
}
