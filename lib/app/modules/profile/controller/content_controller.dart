import 'package:get/get.dart';
import 'package:wisper/app/core/others/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/network_caller/network_response.dart';
import 'package:wisper/app/modules/authentication/views/sign_in_screen.dart';
import 'package:wisper/app/modules/settings/model/content_model.dart';
import 'package:wisper/app/urls.dart';

class ContentController extends GetxController {
  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  final Rx<ContentModel?> _contentModel = Rx<ContentModel?>(null);
  ContentData? get contentData => _contentModel.value?.data;

  Future<bool> getMyContent() async {
    print(
      'User ID avobe getAllPost: ${StorageUtil.getData(StorageUtil.userAccessToken)}',
    );
    _inProgress.value = true;

    try {
      final NetworkResponse response = await Get.find<NetworkCaller>()
          .getRequest(
            Urls.contentUrl,
            accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
          );

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';
        print('My Profile Response data : ${response.responseData}');
        _contentModel.value = ContentModel.fromJson(response.responseData);
        _inProgress.value = false;
        return true;
      } else {
        _errorMessage.value = response.errorMessage;
        _errorMessage.value.contains('expired') ? Get.to(SignInScreen()) : null;
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
