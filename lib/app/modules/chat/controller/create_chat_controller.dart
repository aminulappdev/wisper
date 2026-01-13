import 'package:get/get.dart';
import 'package:wisper/app/core/others/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/network_caller/network_response.dart';
import 'package:wisper/app/urls.dart';

class CreateChatController extends GetxController {
  final RxBool _inProgress = false.obs; 
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  final RxString _chatId = ''.obs;
  String get chatId => _chatId.value;

  Future<bool> createChat({String? memberId}) async {
    _inProgress.value = true;

    try {
      Map<String, dynamic> body = {"participantId": memberId};
      final NetworkResponse response = await Get.find<NetworkCaller>()
          .postRequest(
            Urls.createChatsUrl,
            body: body,
            accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
          );

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';

        _chatId.value = response.responseData['data']['id'];

        _inProgress.value = false;
        return true;
      } else {
        _errorMessage.value = response.errorMessage;
        _inProgress.value = false;
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Failed to fetch district data: ${e.toString()}';
      print('Error fetching district data: $e');
      _inProgress.value = false;
      return false;
    }
  }
}
