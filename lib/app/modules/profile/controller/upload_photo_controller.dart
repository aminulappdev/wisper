// lib/app/modules/profile/controller/profile_photo_controller.dart

import 'dart:io';
import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/network_caller/network_response.dart';
import 'package:wisper/app/modules/authentication/views/sign_in_screen.dart';
import 'package:wisper/app/urls.dart';

class ProfilePhotoController extends GetxController {
  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  Future<bool> uploadProfilePhoto(File image) async {
    _inProgress.value = true;
    update();

    try {
      final response = await Get.find<NetworkCaller>().patchRequest(
        image: image,
        keyNameImage: 'image',
        Urls.editProfilePhotoUrl,
        accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
      );

      if (response.isSuccess) {
       
        update();
        return true;
      } else {
        final msg = response.errorMessage ?? 'Upload failed';
        if (msg.toLowerCase().contains('expired') || msg.toLowerCase().contains('unauthenticated')) {
          Get.offAll(() => const SignInScreen());
        } else {
         
        }
        _inProgress.value = false;
        update();
        return false;
      }
    } catch (e) {
     
      _inProgress.value = false;
      update();
      return false;
    }
  }
}