// app/modules/chat/controller/message_controller.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/socket/socket_service.dart';
import 'package:wisper/app/modules/chat/controller/image_decode_controller.dart';
import 'package:wisper/app/modules/chat/model/message_keys.dart';
import 'package:wisper/app/modules/chat/model/message_model.dart';
import 'package:wisper/app/urls.dart';

class MessageController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final FileDecodeController imageDecodeController =
      Get.find<FileDecodeController>(); // Added

  var isLoading = false.obs;
  var messages = <Map<String, dynamic>>[].obs; // newest first

  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  late String userAuthId;

  @override
  void onInit() {
    super.onInit();
    userAuthId = StorageUtil.getData(StorageUtil.userId) ?? "";
  }

  void setupChat({required String? chatId}) {
    messages.clear();
    isLoading.value = true;

    getMessages(chatId: chatId ?? '').then((_) => scrollToBottom());

    // Socket listener (একবারই on করা)
    socketService.socket.off('newMessage');
    socketService.socket.on('newMessage', _handleIncomingMessage);
    socketService.socket.on('chatList', _handleIncomingChat);
    socketService.socket.on('typingStatus', _handleTypingStatus);
  }

  void _handleIncomingChat(dynamic rawData) {
  print('Real-time chatList event received: $rawData');

  if (rawData == null) return;

  final Map<String, dynamic> data = rawData is String
      ? jsonDecode(rawData)
      : rawData as Map<String, dynamic>;

  // যদি 'chats' key না থাকে বা list না হয় → invalid payload
  if (!data.containsKey('chats') || data['chats'] is! List) {
    print('Invalid payload format for chatList event');
    return;
  }

  final List<dynamic> incomingChats = data['chats'];

  final list = socketService.socketFriendList;
  list.clear(); // Full replace

  final String currentUserId = StorageUtil.getData(StorageUtil.userId) ?? '';

  for (final chatJson in incomingChats) {
    if (chatJson is! Map<String, dynamic>) continue;

    final String chatId = chatJson['id']?.toString() ?? '';
    if (chatId.isEmpty) continue;

    final String type = chatJson['type'] ?? 'INDIVIDUAL';

    // Default values
    String displayName = 'Unknown User';
    String displayImage = '';
    String receiverId = '';


    // INDIVIDUAL চ্যাটের জন্য অন্য participant থেকে নাম/ইমেজ বের করা
    if (type == 'INDIVIDUAL' && chatJson['participants'] is List) {
      final participants = chatJson['participants'] as List;
      final other = participants.firstWhere(
        (p) => p['auth']?['id'] != currentUserId,
        orElse: () => participants.firstOrNull,
      );

      if (other != null && other['auth'] != null) {
        final auth = other['auth'];
        displayName = auth['person']?['name'] ??
            auth['business']?['name'] ??
            'Unknown User';
        displayImage = auth['person']?['image'] ??
            auth['business']?['image'] ??
            '';
        receiverId = auth['id'] ?? '';
      }
    }

    // GROUP বা CLASS এর নাম/ইমেজ
    if (type == 'GROUP') {
      displayName = chatJson['group']?['name'] ?? 'Group Chat';
      displayImage = chatJson['group']?['image'] ?? '';
    } else if (type == 'CLASS') {
      displayName = chatJson['class']?['name'] ?? 'Class Chat';
      displayImage = chatJson['class']?['image'] ?? '';
    }

    // Latest message
    final messagesList = chatJson['messages'] as List<dynamic>? ?? [];
    final latestMsg = messagesList.isNotEmpty ? messagesList.first : null;
    final String lastMessage = latestMsg?['text']?.toString() ?? 'No messages yet';

    final String latestTime = chatJson['latestMessageAt']?.toString() ??
        DateTime.now().toIso8601String();

    // Unread count
    final int unreadCount = chatJson['_count']?['messages'] ?? 0;

    // Add to socket list
    list.add({
      "id": chatId,
      "type": type,
      "latestMessageAt": latestTime,
      "lastMessage": lastMessage,
      "unreadMessageCount": unreadCount,
      "group": chatJson['group'] != null
          ? {
              "name": chatJson['group']['name'],
              "image": chatJson['group']['image'],
            }
          : null,
      "chatClass": chatJson['class'] != null
          ? {
              "name": chatJson['class']['name'],
              "image": chatJson['class']['image'],
            }
          : null,
      "receiverName": displayName,
      "receiverImage": displayImage,
      "receiverId": type == 'INDIVIDUAL' ? receiverId : '',
    });
  }

  // Sort by latest message time (newest first)
  _sortSocketList();
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

  void _handleTypingStatus(dynamic data) {
    print('typingStatus called');
    print(data);
  }

  void _handleIncomingMessage(dynamic data) {
    try {
      final String msgId = data['id'] ?? '';
      if (messages.any((e) => e[SocketMessageKeys.id] == msgId)) return;

      // Sender name & image (Group + Personal দুটোতেই কাজ করবে)
      String senderName = 'Unknown';
      String? senderImage;

      if (data['sender'] != null) {
        final sender = data['sender'];
        if (sender['person'] != null) {
          senderName = sender['person']['name'] ?? 'Unknown';
          senderImage = sender['person']['image'];
        } else if (sender['business'] != null) {
          senderName = sender['business']['name'] ?? 'Unknown';
          senderImage = sender['business']['image'];
        }
      }

      final msg = {
        SocketMessageKeys.id: msgId,
        SocketMessageKeys.text: (data['text'] ?? "").toString(),
        SocketMessageKeys.imageUrl: _safeImageUrl(data['file']),
        SocketMessageKeys.senderId:
            data['sender']['id'] ?? data['senderId'] ?? '',
        SocketMessageKeys.senderName: senderName,
        SocketMessageKeys.senderImage: senderImage,
        SocketMessageKeys.chat: data['chatId'] ?? '',
        SocketMessageKeys.createdAt: (data['createdAt'] ?? DateTime.now())
            .toString(),
        SocketMessageKeys.seen: data['isRead'] ?? false,
        SocketMessageKeys.fileType: data['fileType'] ?? '',
      };

      messages.insert(0, msg);
      scrollToBottom();
    } catch (e) {
      print("Socket parse error: $e");
    }
  }

  String _safeImageUrl(dynamic file) {
    if (file == null || file.toString() == 'null') return "";
    if (file is String && file.trim().isNotEmpty) return file.trim();
    if (file is List && file.isNotEmpty) return file.first.toString().trim();
    return "";
  }

  void scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void sendMessage(String chatId) {
    final text = textController.text.trim();
    final fileUrl = imageDecodeController.imageUrl.trim();
    final fileType = imageDecodeController.currentFileType; // নতুন

    if (text.isEmpty && fileUrl.isEmpty) {
      Get.snackbar('Error', 'Message or attachment required');
      return;
    }

    final messageData = {
      "chatId": chatId,
      if (text.isNotEmpty) "text": text,
      if (fileUrl.isNotEmpty) "file": fileUrl,
      if (fileUrl.isNotEmpty) "fileType": fileType, // সঠিক টাইপ যাবে
    };

    socketService.socket.emit('sendMessage', messageData);
    print('File type********************************** : $fileType');

    // Clear everything
    textController.clear();
    imageDecodeController.clearAll();
  }

  Future<void> getMessages({required String chatId}) async {
    isLoading(true);
    try {
      final token = await StorageUtil.getData(StorageUtil.userAccessToken);
      final response = await Get.find<NetworkCaller>().getRequest(
        Urls.messagesById(chatId),
        accessToken: token,
        queryParams: {"sort": "createdAt", "limit": "9999"},
      );

      if (response.isSuccess && response.responseData != null) {
        final model = MessageModel.fromJson(response.responseData);
        messages.clear();

        if (model.data?.messages != null) {
          for (final msg in model.data!.messages.reversed) {
            String senderName = 'Unknown';
            String? senderImage;

            if (msg.sender != null) {
              if (msg.sender!.person != null) {
                senderName = msg.sender!.person!.name ?? 'Unknown';
                senderImage = msg.sender!.person!.image;
              } else if (msg.sender!.business != null) {
                senderName = msg.sender!.business!.name ?? 'Unknown';
                senderImage = msg.sender!.business!.image;
              }
            }

            final mapMsg = {
              SocketMessageKeys.id: msg.id ?? "",
              SocketMessageKeys.text: msg.text ?? "",
              SocketMessageKeys.imageUrl: _safeImageUrl(msg.file),
              SocketMessageKeys.fileType: msg.fileType ?? "",
              SocketMessageKeys.seen: msg.isRead ?? false,
              SocketMessageKeys.senderId: msg.sender?.id ?? "",
              SocketMessageKeys.senderName: senderName,
              SocketMessageKeys.senderImage: senderImage,
              SocketMessageKeys.chat: msg.chatId ?? "",
              SocketMessageKeys.createdAt:
                  msg.createdAt?.toIso8601String() ??
                  DateTime.now().toIso8601String(),
            };

            if (!messages.any(
              (e) => e[SocketMessageKeys.id] == mapMsg[SocketMessageKeys.id],
            )) {
              messages.add(mapMsg);
            }
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load messages");
    } finally {
      isLoading(false);
      scrollToBottom();
    }
  }

  @override
  void onClose() {
    socketService.socket.off('newMessage');
    scrollController.dispose();
    textController.dispose();
    super.onClose();
  }
}
