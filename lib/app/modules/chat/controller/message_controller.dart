// app/modules/chat/controller/message_controller.dart
import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/network_caller/network_response.dart';
import 'package:wisper/app/core/services/socket/socket_service.dart';
import 'package:wisper/app/modules/chat/model/message_keys.dart';
import 'package:wisper/app/modules/chat/model/message_model.dart';
import 'package:wisper/app/urls.dart';

class MessageController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final SocketService socketService = Get.find<SocketService>();
  var isLoading = false.obs;

  var messageResponse = MessageModel(
    success: false,
    message: "",
    data: null,
  ).obs;
  var messageList = <Message>[].obs;

  Future<void> getMessages({required String chatId}) async {
    _inProgress = true;
    isLoading(true);
    update();

    try {
      String token = await StorageUtil.getData(StorageUtil.userAccessToken);

      final NetworkResponse response = await Get.find<NetworkCaller>()
          .getRequest(
            Urls.messagesById(chatId),
            accessToken: token,
            queryParams: {"sort": "createdAt", "limit": "9999"},
          );

      if (response.isSuccess && response.responseData != null) {
        messageResponse.value = MessageModel.fromJson(response.responseData);

        messageList.clear();
        // socketService.messageList.clear();
        if (messageResponse.value.data?.messages != null) {
          messageList.addAll(messageResponse.value.data!.messages);

          for (final msg in messageResponse.value.data!.messages) {
            final mapMsg = {
              SocketMessageKeys.id: msg.id ?? "",
              SocketMessageKeys.text: msg.text ?? "",
              SocketMessageKeys.imageUrl: msg.file,
              SocketMessageKeys.seen: msg.isRead ?? false,
              SocketMessageKeys.senderId: msg.sender?.id ?? "",
              SocketMessageKeys.chat: msg.chatId ?? "",
              SocketMessageKeys.createdAt:
                  msg.createdAt?.toIso8601String() ??
                  DateTime.now().toIso8601String(),
            };

            // ডুপ্লিকেট চেক করে যোগ করো
            if (!socketService.messageList.any(
              (e) => e[SocketMessageKeys.id] == mapMsg[SocketMessageKeys.id],
            )) {
              socketService.messageList.add(mapMsg);
            }
          }
        }
      } else {
        _errorMessage = response.errorMessage;
        Get.snackbar("Error", _errorMessage!);
      }
    } catch (e) {
      _errorMessage = "Exception: $e";
      Get.snackbar("Error", "Failed to load messages");
      print(e);
    } finally {
      _inProgress = false;
      isLoading(false);
      update();
    }
  }
}
