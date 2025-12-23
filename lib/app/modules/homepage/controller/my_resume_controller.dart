import 'package:get/get.dart';
import 'package:wisper/app/core/get_storage.dart';
import 'package:wisper/app/core/services/download_services.dart';
import 'package:wisper/app/core/services/network_caller/network_caller.dart';
import 'package:wisper/app/core/services/network_caller/network_response.dart';
import 'package:wisper/app/modules/authentication/views/sign_in_screen.dart';
import 'package:wisper/app/modules/homepage/model/resume_model.dart';
import 'package:wisper/app/urls.dart';

class MyResumeController extends GetxController {
  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  final Rx<ResumeModel?> _myResumeModel = Rx<ResumeModel?>(null);
  List<ResumeItemModel>? get myResumeData => _myResumeModel.value?.data;

  Future<bool> getAllResume(String userId) async {
    _inProgress.value = true;
    print('User ID avobe getAllResume: $userId');

    try {
      final NetworkResponse response = await Get.find<NetworkCaller>()
          .getRequest(
            Urls.resumeById(userId),
            queryParams: {"limit": "9999"},
            accessToken: StorageUtil.getData(StorageUtil.userAccessToken),
          );

      if (response.isSuccess && response.responseData != null) {
        _errorMessage.value = '';
        _myResumeModel.value = ResumeModel.fromJson(response.responseData);
        _inProgress.value = false;
        return true;
      } else {
        _errorMessage.value = response.errorMessage;
        if (_errorMessage.value.contains('expired')) {
          Get.offAll(() => SignInScreen());
        }
        _inProgress.value = false;
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Failed to fetch resume data: $e';
      _inProgress.value = false;
      return false;
    }
  }

  Future<void> downloadResume(ResumeItemModel resume) async {
    try {
      Get.snackbar('Downloading', resume.name ?? 'Resume');

      await ResumeDownloadService.downloadAndOpen(
        url: resume.file ?? '',
        fileName: resume.name ?? 'resume.pdf',
      );

      Get.snackbar('Success', 'File downloaded successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
