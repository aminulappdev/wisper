import 'dart:io';
import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/network_caller/network_response.dart';
import 'package:wisper/app/modules/authentication/views/sign_in_screen.dart';
import 'package:wisper/app/urls.dart';

class FileDecodeController extends GetxController {
  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  final RxString _url = ''.obs;
  String get imageUrl => _url.value;
  set imageUrl(String value) => _url.value = value;

  // নতুন: current file type ট্র্যাক করার জন্য
  final RxString _currentFileType = ''.obs;
  String get  currentFileType => _currentFileType.value;

  // Clear everything
  void clearAll() {
    _url.value = '';
    _currentFileType.value = '';
  }

  Future<bool> imageDecode({File? image}) async {
    _currentFileType.value = "IMAGE"; // টাইপ সেট
    _inProgress.value = true;

    try {
      final NetworkResponse response = await Get.find<NetworkCaller>().postRequest(
        image: image,
        keyNameImage: 'file',
        Urls.fileDecodeUrl,
        accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
      );

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';
        _url.value = response.responseData['data']['url'];
        _inProgress.value = false;
        return true;
      } else {
        _errorMessage.value = response.errorMessage;
        if (_errorMessage.value.contains('expired')) Get.to(() => SignInScreen());
        _inProgress.value = false;
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Failed to decode image: ${e.toString()}';
      print('Error decoding image: $e');
      _inProgress.value = false;
      return false;
    }
  }

  Future<bool> videoDecode({File? image}) async {
    _currentFileType.value = "VIDEO"; // টাইপ সেট
    _inProgress.value = true;

    try {
      final NetworkResponse response = await Get.find<NetworkCaller>().postRequest(
        image: image,
        keyNameImage: 'file',
        Urls.fileDecodeUrl,
        accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
      );

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';
        _url.value = response.responseData['data']['url'];
        _inProgress.value = false;
        return true;
      } else {
        _errorMessage.value = response.errorMessage;
        if (_errorMessage.value.contains('expired')) Get.to(() => SignInScreen());
        _inProgress.value = false;
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Failed to decode video: ${e.toString()}';
      print('Error decoding video: $e');
      _inProgress.value = false;
      return false;
    }
  }

  Future<bool> fileDecode({File? image}) async {
    _currentFileType.value = "DOC"; // টাইপ সেট
    _inProgress.value = true;

    try {
      final NetworkResponse response = await Get.find<NetworkCaller>().postRequest(
        image: image,
        keyNameImage: 'file',
        Urls.fileDecodeUrl,
        accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
      );

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';
        _url.value = response.responseData['data']['url'];
        _inProgress.value = false;
        return true;
      } else {
        _errorMessage.value = response.errorMessage;
        if (_errorMessage.value.contains('expired')) Get.to(() => SignInScreen());
        _inProgress.value = false;
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Failed to decode file: ${e.toString()}';
      print('Error decoding file: $e');
      _inProgress.value = false;
      return false;
    }
  }
}