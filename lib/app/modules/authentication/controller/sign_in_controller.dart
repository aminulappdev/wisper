import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/network_caller/network_response.dart';
import 'package:wisper/app/modules/profile/controller/profile_controller.dart';
import 'package:wisper/app/urls.dart';

class SignInController extends GetxController {
  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  Future<bool> signIn({String? email, String? password}) async {
    _inProgress.value = true;

    try {
      Map<String, dynamic> body = {"email": email, "password": password};
      final NetworkResponse response = await Get.find<NetworkCaller>()
          .postRequest(Urls.signInUrl, body: body);

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';

        print('Response roken');
        print(response.responseData['data']['accessToken']);
        StorageUtil.saveData(
          StorageUtil.userAccessToken,
          response.responseData['data']['accessToken'],
        );

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
