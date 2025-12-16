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

  final Rx<AllChatsModel?> _allChatsModel = Rx<AllChatsModel?>(null);

  List<AllChatsItemModel> get allChatsData =>
      _allChatsModel.value?.data?.chats ?? [];

  final String myAuthId = StorageUtil.getData(StorageUtil.userAuthId) ?? '';

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  /// 🔑 IMPORTANT:
  /// Socket init শেষ না হওয়া পর্যন্ত socket ব্যবহার করা হচ্ছে না
  Future<void> _bootstrap() async {
    await socketService.init(); // ✅ Socket initialized FIRST

    _setupSocketListeners(); // ✅ Safe now
    await getAllChats(); // API load
  }

  // ================= SOCKET =================

  void _setupSocketListeners() {
    socketService.socket.off('chatList');
    socketService.socket.on('chatList', _handleIncomingChat);
  }

  void _handleIncomingChat(dynamic rawData) {
    print('chatList socket event received');
    if (rawData == null) return;

    final Map<String, dynamic> data = rawData is String
        ? Map<String, dynamic>.from(jsonDecode(rawData))
        : Map<String, dynamic>.from(rawData);

    final chat = data['chat'] ?? data;
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

    final index = list.indexWhere((e) => e['id'] == chatId);

    if (index != -1) {
      final item = Map<String, dynamic>.from(list[index]);

      item['lastMessage'] = text;
      item['latestMessageAt'] = time;

      if (!isFromMe) {
        item['unreadMessageCount'] = (item['unreadMessageCount'] ?? 0) + 1;
      }

      list.removeAt(index);
      list.insert(0, item);
    } else {
      list.insert(0, {
        "id": chatId,
        "type": chat['type'] ?? 'INDIVIDUAL',
        "lastMessage": text,
        "latestMessageAt": time,
        "unreadMessageCount": isFromMe ? 0 : 1,
        "group": chat['group'],
        "chatClass": chat['chatClass'],
      });
    }

    _sortSocketList();
  }

  // ================= API =================

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
        _allChatsModel.value = model;

        socketService.socketFriendList.clear();

        for (final chat in model.data?.chats ?? []) {
          socketService.socketFriendList.add({
            "id": chat.id ?? '',
            "type": chat.type ?? 'INDIVIDUAL',
            "latestMessageAt": chat.latestMessageAt?.toIso8601String() ?? '',
            "lastMessage": chat.messages.isNotEmpty
                ? chat.messages.first.text ?? ''
                : 'No messages yet',
            "unreadMessageCount": chat.count?.messages ?? 0,
            "group": chat.group,
            "chatClass": chat.chatClass,
            "messages": chat.messages.map((m) {
              return {"id": m.id, "text": m.text, "senderId": m.sender?.id};
            }).toList(),
          });
        }

        _sortSocketList();
      } else {
        errorMessage.value = response.errorMessage;
        if (errorMessage.value.toLowerCase().contains('expired')) {
          Get.offAll(() => SignInScreen());
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      inProgress.value = false;
    }
  }

  // ================= UTIL =================

  void _sortSocketList() {
    socketService.socketFriendList.sort((a, b) {
      final aTime =
          DateTime.tryParse(a['latestMessageAt'] ?? '') ?? DateTime(1970);
      final bTime =
          DateTime.tryParse(b['latestMessageAt'] ?? '') ?? DateTime(1970);
      return bTime.compareTo(aTime);
    });

    socketService.socketFriendList.refresh();
  }

  @override
  void onClose() {
    socketService.socket.off('chatList');
    socketService.socket.off('new_message');
    super.onClose();
  }
}
